import {
  WebSocketGateway,
  WebSocketServer,
  SubscribeMessage,
  OnGatewayConnection,
  OnGatewayDisconnect,
  OnGatewayInit,
  ConnectedSocket,
  MessageBody,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { Logger, Inject, forwardRef } from '@nestjs/common';
import { ChatService } from './chat.service';
import { createHash } from 'crypto';

/**
 * Anonymize user ID for logging (GDPR/PII compliance)
 */
function anonymizeUserId(userId: string): string {
  return createHash('sha256').update(userId).digest('hex').substring(0, 8);
}

/**
 * ChatGateway
 * 
 * WebSocket gateway for real-time chat functionality.
 * Handles bidirectional communication between clients and server.
 * 
 * Events:
 * - join_conversation: Client joins a specific conversation room
 * - leave_conversation: Client leaves a conversation room
 * - send_message: Client sends a message
 * - new_message: Server broadcasts new message to room
 * - message_read: Client marks messages as read
 * - conversation_updated: Server broadcasts conversation updates
 * - typing: Client is typing indicator
 */
@WebSocketGateway({
  cors: {
    origin: process.env.FRONTEND_URL || 'http://localhost:3001',
    credentials: true,
  },
  namespace: '/chat',
})
export class ChatGateway implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  private readonly logger = new Logger(ChatGateway.name);
  
  // Track which users are in which conversations
  private readonly conversationUsers = new Map<string, Set<string>>();

  constructor(
    @Inject(forwardRef(() => ChatService))
    private readonly chatService?: ChatService,
  ) {}

  /**
   * Gateway initialization
   */
  afterInit(server: Server) {
    this.logger.log('ChatGateway initialized');
  }

  /**
   * Handle client connection
   * TODO: Replace query-based auth with JWT token validation
   */
  handleConnection(client: Socket) {
    this.logger.log(`Client connected: ${client.id}`);
    
    // Extract user info from handshake (TODO: Replace with JWT token validation)
    const userId = client.handshake.query.userId as string;
    const userRole = client.handshake.query.userRole as string;
    
    if (!userId) {
      this.logger.warn(`Client ${client.id} connected without userId`);
      client.disconnect();
      return;
    }

    // Store user info in socket data (preserve original for internal use)
    client.data.userId = userId;
    client.data.userRole = userRole || 'user';
    
    // Join admin room if user is admin
    if (userRole === 'admin') {
      client.join('admin');
      this.logger.log(`Admin user ${anonymizeUserId(userId)} joined admin room`);
    }
    
    this.logger.log(`User ${anonymizeUserId(userId)} (${userRole}) connected with socket ${client.id}`);
  }

  /**
   * Handle client disconnection
   */
  handleDisconnect(client: Socket) {
    const userId = client.data.userId;
    this.logger.log(`Client disconnected: ${client.id} (User: ${anonymizeUserId(userId)})`);
    
    // Remove user from all conversation rooms
    this.conversationUsers.forEach((users, conversationId) => {
      if (users.has(client.id)) {
        users.delete(client.id);
        if (users.size === 0) {
          this.conversationUsers.delete(conversationId);
        }
      }
    });
  }

  /**
   * Client joins a conversation room
   * @event join_conversation
   */
  @SubscribeMessage('join_conversation')
  async handleJoinConversation(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { conversationId: string },
  ) {
    const { conversationId } = data;
    const userId = client.data.userId;

    if (!conversationId) {
      client.emit('error', { message: 'conversationId is required' });
      return;
    }

    // TODO: Add authorization check
    // const canAccess = await this.chatService.canUserAccessConversation(userId, conversationId);
    // if (!canAccess) {
    //   client.emit('error', { message: 'Unauthorized to join this conversation' });
    //   return;
    // }

    // Join the room
    await client.join(conversationId);
    
    // Track users in conversation
    if (!this.conversationUsers.has(conversationId)) {
      this.conversationUsers.set(conversationId, new Set());
    }
    this.conversationUsers.get(conversationId)!.add(client.id);

    this.logger.log(`User ${anonymizeUserId(userId)} joined conversation ${conversationId}`);
    
    // Notify client of successful join
    client.emit('joined_conversation', { conversationId });
    
    // Notify others in the room
    client.to(conversationId).emit('user_joined', { 
      userId: anonymizeUserId(userId),
      userRole: client.data.userRole,
    });
  }

  /**
   * Client leaves a conversation room
   * @event leave_conversation
   */
  @SubscribeMessage('leave_conversation')
  async handleLeaveConversation(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { conversationId: string },
  ) {
    const { conversationId } = data;
    const userId = client.data.userId;

    if (!conversationId) {
      return;
    }

    await client.leave(conversationId);
    
    // Remove from tracking
    const users = this.conversationUsers.get(conversationId);
    if (users) {
      users.delete(client.id);
      if (users.size === 0) {
        this.conversationUsers.delete(conversationId);
      }
    }

    this.logger.log(`User ${anonymizeUserId(userId)} left conversation ${conversationId}`);
    
    // Notify others
    client.to(conversationId).emit('user_left', { userId: anonymizeUserId(userId) });
  }

  /**
   * Handle new message from client
   * This should be called AFTER message is saved to DB
   * @event new_message
   */
  @SubscribeMessage('new_message')
  async handleNewMessage(
    @ConnectedSocket() client: Socket,
    @MessageBody() message: any,
  ) {
    const { conversation_id } = message;
    
    if (!conversation_id) {
      client.emit('error', { message: 'conversation_id is required' });
      return;
    }

    // Broadcast to all clients in the conversation room
    this.server.to(conversation_id).emit('message_received', message);
    
    this.logger.log(`Message broadcast to conversation ${conversation_id}`);
  }

  /**
   * Handle typing indicator
   * @event typing
   */
  @SubscribeMessage('typing')
  handleTyping(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { conversationId: string; isTyping: boolean },
  ) {
    const { conversationId, isTyping } = data;
    const userId = client.data.userId;

    // Validate conversationId
    if (!conversationId || typeof conversationId !== 'string' || conversationId.trim() === '') {
      client.emit('error', { message: 'Invalid conversationId' });
      return;
    }

    // Broadcast to others in the room (not sender)
    client.to(conversationId).emit('user_typing', {
      userId: anonymizeUserId(userId),
      userRole: client.data.userRole,
      isTyping,
    });
  }

  /**
   * Handle messages marked as read
   * @event messages_read
   */
  @SubscribeMessage('messages_read')
  handleMessagesRead(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { conversationId: string },
  ) {
    const { conversationId } = data;
    const userId = client.data.userId;

    // Validate conversationId
    if (!conversationId || typeof conversationId !== 'string' || conversationId.trim() === '') {
      client.emit('error', { message: 'Invalid conversationId' });
      return;
    }

    // Broadcast to others in the room
    client.to(conversationId).emit('messages_marked_read', {
      userId: anonymizeUserId(userId),
      conversationId,
    });
  }

  /**
   * Broadcast conversation update to all clients
   * Called from service layer when conversation status changes
   */
  broadcastConversationUpdate(conversationId: string, conversation: any) {
    this.server.to(conversationId).emit('conversation_updated', conversation);
    this.logger.log(`Conversation ${conversationId} update broadcast`);
  }

  /**
   * Broadcast new conversation to admin clients only
   */
  broadcastNewConversation(conversation: any) {
    // Emit only to admin room
    this.server.to('admin').emit('new_conversation', { conversation });
    this.logger.log(`New conversation broadcast to admins: ${conversation.id}`);
  }
}
