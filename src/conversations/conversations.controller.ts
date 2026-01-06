import { Controller, Get, Post, Body, Param, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';
import { Profile } from '../decorators/profile.decorator';
import { ConversationsService } from './conversations.service';

@Controller('conversations')
@UseGuards(JwtAuthGuard)
export class ConversationsController {
  constructor(private readonly conversationsService: ConversationsService) {}

  /**
   * Get user's active/recent conversation
   */
  @Get('my')
  async getMyConversation(@Profile() profile: any) {
    return this.conversationsService.getMyConversation(profile.id);
  }

  /**
   * Start a new conversation
   */
  @Post()
  async createConversation(
    @Profile() profile: any,
    @Body() body: { subject?: string },
  ) {
    return this.conversationsService.createConversation(profile.id, body.subject);
  }

  /**
   * Get conversation by ID
   */
  @Get(':id')
  async getConversation(
    @Profile() profile: any,
    @Param('id') id: string,
  ) {
    return this.conversationsService.getConversationById(profile.id, id);
  }

  /**
   * Get messages for a conversation
   */
  @Get(':id/messages')
  async getMessages(
    @Profile() profile: any,
    @Param('id') id: string,
  ) {
    return this.conversationsService.getMessages(profile.id, id);
  }

  /**
   * Send a message
   */
  @Post(':id/messages')
  async sendMessage(
    @Profile() profile: any,
    @Param('id') id: string,
    @Body() body: { content: string },
  ) {
    return this.conversationsService.sendMessage(profile.id, id, body.content);
  }

  /**
   * Mark messages as read
   */
  @Post(':id/read')
  async markAsRead(
    @Profile() profile: any,
    @Param('id') id: string,
  ) {
    return this.conversationsService.markAsRead(profile.id, id);
  }
}
