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
import { ChatService } from './chat.service';
import { SendMessageDto, MarkAsReadDto } from './dto/chat.dto';

// Admin chat controller
@Controller('admin/chat')
@UseGuards(JwtAuthGuard, AdminGuard)
export class AdminChatController {
  constructor(private readonly chatService: ChatService) {}

  /**
   * Get all conversations
   */
  @Get('conversations')
  async getConversations(
    @Query('page') page?: string,
    @Query('limit') limit?: string,
    @Query('status') status?: string,
  ) {
    return this.chatService.getConversations(
      parseInt(page || '1'),
      parseInt(limit || '20'),
      { status },
    );
  }

  /**
   * Get conversation detail
   */
  @Get('conversations/:id')
  async getConversation(@Param('id') id: string) {
    return this.chatService.getConversation(id);
  }

  /**
   * Get messages in conversation
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
   * Send message as admin
   */
  @Post('messages')
  async sendMessage(@Profile() profile: any, @Body() dto: SendMessageDto) {
    return this.chatService.sendMessage(
      profile.id,
      dto.conversation_id,
      dto.message,
      'admin',
    );
  }

  /**
   * Mark messages as read
   */
  @Put('conversations/:id/mark-read')
  async markAsRead(@Param('id') conversationId: string) {
    return this.chatService.markAsRead(conversationId, 'admin');
  }

  /**
   * Archive conversation
   */
  @Put('conversations/:id/archive')
  async archiveConversation(@Param('id') id: string) {
    return this.chatService.archiveConversation(id);
  }
}

// User chat controller (public)
@Controller('chat')
@UseGuards(JwtAuthGuard)
export class ChatController {
  constructor(private readonly chatService: ChatService) {}

  /**
   * Get user's own conversation
   */
  @Get('conversation')
  async getMyConversation(@Profile() profile: any) {
    return this.chatService.getUserConversation(profile.id);
  }

  /**
   * Create or get conversation
   */
  @Post('conversation')
  async createConversation(@Profile() profile: any) {
    return this.chatService.getOrCreateConversation(profile.id);
  }

  /**
   * Get messages in my conversation
   */
  @Get('messages')
  async getMessages(
    @Profile() profile: any,
    @Query('limit') limit?: string,
    @Query('offset') offset?: string,
  ) {
    const conversation = await this.chatService.getUserConversation(profile.id);
    if (!conversation) {
      return { data: [], meta: { total: 0, limit: 0, offset: 0 } };
    }

    return this.chatService.getMessages(
      conversation.id,
      parseInt(limit || '50'),
      parseInt(offset || '0'),
    );
  }

  /**
   * Send message as user
   */
  @Post('messages')
  async sendMessage(@Profile() profile: any, @Body() dto: { message: string }) {
    // Get or create conversation
    const conversation = await this.chatService.getOrCreateConversation(profile.id);

    return this.chatService.sendMessage(
      profile.id,
      conversation.id,
      dto.message,
      'user',
    );
  }

  /**
   * Mark messages as read
   */
  @Put('messages/mark-read')
  async markAsRead(@Profile() profile: any) {
    const conversation = await this.chatService.getUserConversation(profile.id);
    if (!conversation) {
      return { success: true };
    }

    return this.chatService.markAsRead(conversation.id, 'user');
  }
}
