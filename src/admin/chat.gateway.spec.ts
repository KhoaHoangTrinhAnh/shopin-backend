import { Test, TestingModule } from '@nestjs/testing';
import { ChatGateway } from './chat.gateway';
import { ChatService } from './chat.service';
import { Server, Socket } from 'socket.io';

/**
 * ChatGateway Unit Tests
 * 
 * Tests WebSocket gateway functionality including:
 * - Connection/disconnection handling
 * - Joining/leaving conversation rooms
 * - Message broadcasting
 * - Typing indicators
 */
describe('ChatGateway', () => {
  let gateway: ChatGateway;
  let chatService: ChatService;
  let mockServer: Partial<Server>;
  let mockSocket: Partial<Socket>;

  beforeEach(async () => {
    // Mock Server
    mockServer = {
      to: jest.fn().mockReturnThis(),
      emit: jest.fn(),
    };

    // Mock Socket
    mockSocket = {
      id: 'test-socket-id',
      data: {},
      handshake: {
        query: {
          userId: 'test-user-id',
          userRole: 'user',
        },
      } as any,
      join: jest.fn(),
      leave: jest.fn(),
      emit: jest.fn(),
      to: jest.fn().mockReturnThis(),
      disconnect: jest.fn(),
    };

    // Mock ChatService
    const mockChatService = {
      // Add methods if needed
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ChatGateway,
        {
          provide: ChatService,
          useValue: mockChatService,
        },
      ],
    }).compile();

    gateway = module.get<ChatGateway>(ChatGateway);
    gateway.server = mockServer as Server;
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('Gateway Lifecycle', () => {
    it('should be defined', () => {
      expect(gateway).toBeDefined();
    });

    it('should log on initialization', () => {
      const loggerSpy = jest.spyOn(gateway['logger'], 'log');
      gateway.afterInit(mockServer as Server);
      expect(loggerSpy).toHaveBeenCalledWith('ChatGateway initialized');
    });
  });

  describe('handleConnection', () => {
    it('should accept connection with valid userId', () => {
      gateway.handleConnection(mockSocket as Socket);
      
      expect(mockSocket.data.userId).toBe('test-user-id');
      expect(mockSocket.data.userRole).toBe('user');
      expect(mockSocket.disconnect).not.toHaveBeenCalled();
    });

    it('should disconnect client without userId', () => {
      const invalidSocket = {
        ...mockSocket,
        handshake: {
          query: {},
        },
      } as any;

      gateway.handleConnection(invalidSocket as Socket);
      expect(invalidSocket.disconnect).toHaveBeenCalled();
    });

    it('should default to user role if not provided', () => {
      const socketWithoutRole = {
        ...mockSocket,
        handshake: {
          query: {
            userId: 'test-user-id',
          },
        },
      } as any;

      gateway.handleConnection(socketWithoutRole as Socket);
      expect(socketWithoutRole.data.userRole).toBe('user');
    });
  });

  describe('handleJoinConversation', () => {
    beforeEach(() => {
      mockSocket.data = {
        userId: 'test-user-id',
        userRole: 'user',
      };
    });

    it('should join conversation room successfully', async () => {
      const data = { conversationId: 'conv-123' };
      
      await gateway.handleJoinConversation(
        mockSocket as Socket,
        data,
      );

      expect(mockSocket.join).toHaveBeenCalledWith('conv-123');
      expect(mockSocket.emit).toHaveBeenCalledWith('joined_conversation', { conversationId: 'conv-123' });
      expect(mockSocket.to).toHaveBeenCalledWith('conv-123');
    });

    it('should emit error if conversationId is missing', async () => {
      const data = { conversationId: '' };
      
      await gateway.handleJoinConversation(
        mockSocket as Socket,
        data,
      );

      expect(mockSocket.emit).toHaveBeenCalledWith('error', { message: 'conversationId is required' });
      expect(mockSocket.join).not.toHaveBeenCalled();
    });
  });

  describe('handleLeaveConversation', () => {
    it('should leave conversation room', async () => {
      const data = { conversationId: 'conv-123' };
      mockSocket.data = {
        userId: 'test-user-id',
      };

      await gateway.handleLeaveConversation(
        mockSocket as Socket,
        data,
      );

      expect(mockSocket.leave).toHaveBeenCalledWith('conv-123');
      expect(mockSocket.to).toHaveBeenCalledWith('conv-123');
    });

    it('should handle missing conversationId gracefully', async () => {
      const data = { conversationId: '' };

      await gateway.handleLeaveConversation(
        mockSocket as Socket,
        data,
      );

      expect(mockSocket.leave).not.toHaveBeenCalled();
    });
  });

  describe('handleNewMessage', () => {
    it('should broadcast message to conversation room', async () => {
      const message = {
        id: 'msg-123',
        conversation_id: 'conv-123',
        sender_id: 'user-123',
        message: 'Hello World',
        created_at: new Date().toISOString(),
      };

      await gateway.handleNewMessage(mockSocket as Socket, message);

      expect(mockServer.to).toHaveBeenCalledWith('conv-123');
      expect(mockServer.emit).toHaveBeenCalledWith('message_received', message);
    });

    it('should emit error if conversation_id is missing', async () => {
      const message = {
        id: 'msg-123',
        sender_id: 'user-123',
        message: 'Hello World',
      };

      await gateway.handleNewMessage(mockSocket as Socket, message);

      expect(mockSocket.emit).toHaveBeenCalledWith('error', { message: 'conversation_id is required' });
      expect(mockServer.to).not.toHaveBeenCalled();
    });
  });

  describe('handleTyping', () => {
    it('should broadcast typing indicator to others in room', () => {
      const data = {
        conversationId: 'conv-123',
        isTyping: true,
      };
      mockSocket.data = {
        userId: 'user-123',
        userRole: 'user',
      };

      const toEmit = jest.fn();
      (mockSocket.to as jest.Mock).mockReturnValue({ emit: toEmit });

      gateway.handleTyping(mockSocket as Socket, data);

      expect(mockSocket.to).toHaveBeenCalledWith('conv-123');
      expect(toEmit).toHaveBeenCalledWith('user_typing', {
        userId: 'user-123',
        userRole: 'user',
        isTyping: true,
      });
    });
  });

  describe('handleMessagesRead', () => {
    it('should broadcast read status to room', () => {
      const data = { conversationId: 'conv-123' };
      mockSocket.data = {
        userId: 'user-123',
      };

      const toEmit = jest.fn();
      (mockSocket.to as jest.Mock).mockReturnValue({ emit: toEmit });

      gateway.handleMessagesRead(mockSocket as Socket, data);

      expect(mockSocket.to).toHaveBeenCalledWith('conv-123');
      expect(toEmit).toHaveBeenCalledWith('messages_marked_read', {
        userId: 'user-123',
        conversationId: 'conv-123',
      });
    });
  });

  describe('broadcastConversationUpdate', () => {
    it('should broadcast conversation update to room', () => {
      const conversation = {
        id: 'conv-123',
        status: 'resolved',
        updated_at: new Date().toISOString(),
      };

      gateway.broadcastConversationUpdate('conv-123', conversation);

      expect(mockServer.to).toHaveBeenCalledWith('conv-123');
      expect(mockServer.emit).toHaveBeenCalledWith('conversation_updated', conversation);
    });
  });

  describe('broadcastNewConversation', () => {
    it('should broadcast new conversation to all clients', () => {
      const conversation = {
        id: 'conv-123',
        user_id: 'user-123',
        status: 'active',
        created_at: new Date().toISOString(),
      };

      gateway.broadcastNewConversation(conversation);

      expect(mockServer.emit).toHaveBeenCalledWith('new_conversation', conversation);
    });
  });

  describe('handleDisconnect', () => {
    it('should clean up user from conversation rooms', () => {
      // Setup: User joins a conversation first
      const testSocket = {
        ...mockSocket,
        id: 'test-socket-id',
        data: { userId: 'user-123' },
      } as Socket;
      
      const conversationId = 'conv-123';
      
      // Manually add to tracking (simulating join)
      gateway['conversationUsers'].set(conversationId, new Set(['test-socket-id']));

      gateway.handleDisconnect(testSocket);

      // Verify cleanup
      const users = gateway['conversationUsers'].get(conversationId);
      expect(users).toBeUndefined(); // Should be deleted when last user leaves
    });
  });
});
