import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { SupabaseService } from '../supabase/supabase.service';

@Injectable()
export class ChatService {
  constructor(private readonly supabaseService: SupabaseService) {}

  /**
   * Get all conversations for admin
   */
  async getConversations(page: number = 1, limit: number = 20, filters?: {
    status?: string;
    search?: string;
  }) {
    const supabase = this.supabaseService.getClient();
    const offset = (page - 1) * limit;

    let query = supabase
      .from('conversations')
      .select(`
        *,
        user:profiles!conversations_user_id_fkey(
          id,
          full_name,
          email,
          avatar_url
        )
      `, { count: 'exact' });

    // Apply filters
    if (filters?.status) {
      query = query.eq('status', filters.status);
    }

    const { data, error, count } = await query
      .order('last_message_at', { ascending: false })
      .range(offset, offset + limit - 1);

    if (error) {
      throw new BadRequestException(`Error fetching conversations: ${error.message}`);
    }

    return {
      data: data || [],
      meta: {
        total: count || 0,
        page,
        limit,
        totalPages: Math.ceil((count || 0) / limit),
      },
    };
  }

  /**
   * Get conversation detail
   */
  async getConversation(id: string) {
    const supabase = this.supabaseService.getClient();

    const { data, error } = await supabase
      .from('conversations')
      .select(`
        *,
        user:profiles!conversations_user_id_fkey(
          id,
          full_name,
          email,
          avatar_url,
          created_at
        )
      `)
      .eq('id', id)
      .single();

    if (error || !data) {
      throw new NotFoundException(`Conversation not found with ID: ${id}`);
    }

    return data;
  }

  /**
   * Get messages in a conversation
   */
  async getMessages(conversationId: string, limit: number = 50, offset: number = 0) {
    const supabase = this.supabaseService.getClient();

    const { data, error, count } = await supabase
      .from('chat_messages')
      .select(`
        *,
        sender:profiles!chat_messages_sender_id_fkey(
          id,
          full_name,
          email,
          avatar_url,
          role
        )
      `, { count: 'exact' })
      .eq('conversation_id', conversationId)
      .order('created_at', { ascending: true })
      .range(offset, offset + limit - 1);

    if (error) {
      throw new BadRequestException(`Error fetching messages: ${error.message}`);
    }

    return {
      data: data || [],
      meta: {
        total: count || 0,
        limit,
        offset,
      },
    };
  }

  /**
   * Send a message (admin or user)
   */
  async sendMessage(senderId: string, conversationId: string, message: string, senderRole: string) {
    const supabase = this.supabaseService.getClient();

    // Create message
    const { data: messageData, error: messageError } = await supabase
      .from('chat_messages')
      .insert({
        conversation_id: conversationId,
        sender_id: senderId,
        sender_role: senderRole,
        message,
        is_read: false,
      })
      .select()
      .single();

    if (messageError) {
      throw new BadRequestException(`Error sending message: ${messageError.message}`);
    }

    // Update conversation last message
    const { data: conversation } = await supabase
      .from('conversations')
      .select('unread_count')
      .eq('id', conversationId)
      .single();

    await supabase
      .from('conversations')
      .update({
        last_message: message,
        last_message_at: new Date().toISOString(),
        unread_count: (conversation?.unread_count || 0) + 1,
        updated_at: new Date().toISOString(),
      })
      .eq('id', conversationId);

    return messageData;
  }

  /**
   * Create or get existing conversation for a user
   */
  async getOrCreateConversation(userId: string) {
    const supabase = this.supabaseService.getClient();

    // Check if conversation exists
    const { data: existing } = await supabase
      .from('conversations')
      .select('*')
      .eq('user_id', userId)
      .eq('status', 'active')
      .single();

    if (existing) {
      return existing;
    }

    // Create new conversation
    const { data, error } = await supabase
      .from('conversations')
      .insert({
        user_id: userId,
        status: 'active',
      })
      .select()
      .single();

    if (error) {
      throw new BadRequestException(`Error creating conversation: ${error.message}`);
    }

    return data;
  }

  /**
   * Mark messages as read
   */
  async markAsRead(conversationId: string, role: 'user' | 'admin') {
    const supabase = this.supabaseService.getClient();

    // Mark all unread messages in this conversation as read
    const { error } = await supabase
      .from('chat_messages')
      .update({ is_read: true })
      .eq('conversation_id', conversationId)
      .eq('is_read', false)
      .neq('sender_role', role); // Don't mark own messages as read

    if (error) {
      throw new BadRequestException(`Error marking messages as read: ${error.message}`);
    }

    // Reset unread count
    await supabase
      .from('conversations')
      .update({ unread_count: 0 })
      .eq('id', conversationId);

    return { success: true };
  }

  /**
   * Archive conversation
   */
  async archiveConversation(id: string) {
    const supabase = this.supabaseService.getClient();

    const { error } = await supabase
      .from('conversations')
      .update({ status: 'archived', updated_at: new Date().toISOString() })
      .eq('id', id);

    if (error) {
      throw new BadRequestException(`Error archiving conversation: ${error.message}`);
    }

    return { success: true };
  }

  /**
   * Get user's own conversation
   */
  async getUserConversation(userId: string) {
    const supabase = this.supabaseService.getClient();

    const { data } = await supabase
      .from('conversations')
      .select('*')
      .eq('user_id', userId)
      .eq('status', 'active')
      .single();

    return data || null;
  }
}
