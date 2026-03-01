import {
  Controller,
  Get,
  Post,
  Param,
  Body,
  Query,
  UseGuards,
  Put,
} from '@nestjs/common';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';
import { AdminGuard } from './guards/admin.guard';
import { Profile } from '../decorators/profile.decorator';
import { AccessToken } from '../decorators/access-token.decorator';
import { ChatService } from './chat.service';
import { SendMessageDto, UpdateConversationStatusDto } from './dto/chat.dto';

/**
 * Admin Chat Controller
 * 
 * Handles all admin-side chat operations:
 * - View all conversations
 * - Read messages in any conversation
 * - Send messages as admin
 * - Update conversation status (resolve/archive)
 */
@Controller('admin/chat')
@UseGuards(JwtAuthGuard, AdminGuard)
export class AdminChatController {
  constructor(private readonly chatService: ChatService) {}

  /**
   * GET /admin/chat/conversations
   * Get paginated list of all conversations
   */
  @Get('conversations')
  async getConversations(
    @Query('page') page?: string,
    @Query('limit') limit?: string,
    @Query('status') status?: string,
    @Query('search') search?: string,
  ) {
    return this.chatService.getConversations(
      parseInt(page || '1'),
      parseInt(limit || '20'),
      { status, search },
    );
  }

  /**
   * GET /admin/chat/conversations/:id
   * Get single conversation detail with user info
   */
  @Get('conversations/:id')
  async getConversation(@Param('id') id: string) {
    return this.chatService.getConversation(id);
  }

  /**
   * GET /admin/chat/conversations/:id/messages
   * Get messages in a conversation
   */
  @Get('conversations/:id/messages')
  async getMessages(
    @Param('id') conversationId: string,
    @Query('limit') limit?: string,
    @Query('offset') offset?: string,
  ) {
    return this.chatService.getMessages(
      conversationId,
      parseInt(limit || '50'),
      parseInt(offset || '0'),
    );
  }

  /**
   * POST /admin/chat/messages
   * Send message as admin to a conversation
   */
  @Post('messages')
  async sendMessage(@Profile() profile: any, @AccessToken() token: string, @Body() dto: SendMessageDto) {
    return this.chatService.sendMessageAsAdmin(
      dto.conversation_id,
      dto.message,
      token,
    );
  }

  /**
   * PUT /admin/chat/conversations/:id/mark-read
   * Mark all messages in conversation as read
   */
  @Put('conversations/:id/mark-read')
  async markAsRead(@Param('id') conversationId: string) {
    return this.chatService.markAsRead(conversationId);
  }

  /**
   * PUT /admin/chat/conversations/:id/status
   * Update conversation status (active/resolved/archived)
   */
  @Put('conversations/:id/status')
  async updateStatus(
    @Param('id') id: string,
    @AccessToken() token: string,
    @Body() dto: UpdateConversationStatusDto,
  ) {
    return this.chatService.updateConversationStatus(id, dto.status, token);
  }

  /**
   * PUT /admin/chat/conversations/:id/archive
   * Archive a conversation (shortcut for status=archived)
   */
  @Put('conversations/:id/archive')
  async archiveConversation(@Param('id') id: string, @AccessToken() token: string) {
    return this.chatService.updateConversationStatus(id, 'archived', token);
  }

  /**
   * PUT /admin/chat/conversations/:id/resolve
   * Resolve a conversation (shortcut for status=resolved)
   */
  @Put('conversations/:id/resolve')
  async resolveConversation(@Param('id') id: string, @AccessToken() token: string) {
    return this.chatService.updateConversationStatus(id, 'resolved', token);
  }

  /**
   * GET /admin/chat/unread-count
   * Get total unread message count across all conversations
   */
  @Get('unread-count')
  async getUnreadCount(@AccessToken() token: string) {
    const count = await this.chatService.getAdminUnreadCount(token);
    return { count };
  }
}

/**
 * Customer Chat Controller
 * 
 * Handles customer-side chat operations:
 * - Get/create their single conversation
 * - Send messages
 * - Mark messages as read
 */
@Controller('chat')
@UseGuards(JwtAuthGuard)
export class ChatController {
  constructor(private readonly chatService: ChatService) {}

  /**
   * GET /chat/conversation
   * Get customer's own conversation (or null if none exists)
   */
  @Get('conversation')
  async getMyConversation(@Profile() profile: any, @AccessToken() token: string) {
    return this.chatService.getUserConversation(token);
  }

  /**
   * POST /chat/conversation
   * Create or get existing conversation
   * Uses RPC function that handles UNIQUE constraint
   */
  @Post('conversation')
  async createConversation(@Profile() profile: any, @AccessToken() token: string) {
    return this.chatService.getOrCreateConversation(token);
  }

  /**
   * GET /chat/messages
   * Get messages in customer's conversation
   */
  @Get('messages')
  async getMessages(
    @Profile() profile: any,
    @AccessToken() token: string,
    @Query('limit') limit?: string,
    @Query('offset') offset?: string,
  ) {
    const conversation = await this.chatService.getUserConversation(token);
    if (!conversation) {
      return { data: [], meta: { total: 0, limit: 50, offset: 0 } };
    }

    return this.chatService.getMessages(
      conversation.id,
      parseInt(limit || '50'),
      parseInt(offset || '0'),
    );
  }

  /**
   * POST /chat/messages
   * Send message as customer
   * Supports sending without conversation_id (auto-creates conversation)
   */
  @Post('messages')
  async sendMessage(
    @Profile() profile: any,
    @AccessToken() token: string,
    @Body() dto: { message: string; conversation_id?: string },
  ) {
    // Use RPC function which auto-creates conversation if needed
    return this.chatService.sendMessageAsUser(
      profile.user_id,
      dto.conversation_id || null,
      dto.message,
      token,
    );
  }

  /**
   * PUT /chat/messages/mark-read
   * Mark all admin messages as read
   */
  @Put('messages/mark-read')
  async markAsRead(@Profile() profile: any, @AccessToken() token: string) {
    const conversation = await this.chatService.getUserConversation(token);
    if (!conversation) {
      return { success: true };
    }

    return this.chatService.markAsRead(conversation.id, token);
  }

  /**
   * GET /chat/unread-count
   * Get customer's unread message count
   */
  @Get('unread-count')
  async getUnreadCount(@AccessToken() token: string) {
    const count = await this.chatService.getCustomerUnreadCount(token);
    return { count };
  }
}
