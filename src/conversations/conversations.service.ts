import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { SupabaseService } from '../supabase/supabase.service';

@Injectable()
export class ConversationsService {
  constructor(private readonly supabaseService: SupabaseService) {}

  /**
   * Get user's active conversation (or most recent)
   */
  async getMyConversation(profileId: string) {
    const supabase = this.supabaseService.getClient();
    
    // Get user's most recent open conversation
    const { data: conversation, error } = await supabase
      .from('conversations')
      .select(`
        id,
        status,
        subject,
        created_at,
        updated_at,
        last_message_at,
        messages:chat_messages(
          id,
          content,
          sender_type,
          sender_id,
          is_read,
          created_at
        )
      `)
      .eq('user_id', profileId)
      .order('created_at', { ascending: false })
      .limit(1)
      .single();

    if (error && error.code !== 'PGRST116') {
      throw new BadRequestException(`Error fetching conversation: ${error.message}`);
    }

    if (!conversation) {
      return null;
    }

    // Sort messages by date
    if (conversation.messages) {
      conversation.messages.sort((a: any, b: any) => 
        new Date(a.created_at).getTime() - new Date(b.created_at).getTime()
      );
    }

    return conversation;
  }

  /**
   * Start a new conversation
   */
  async createConversation(profileId: string, subject?: string) {
    const supabase = this.supabaseService.getClient();
    
    // Check if user has an open conversation
    const { data: existing } = await supabase
      .from('conversations')
      .select('id')
      .eq('user_id', profileId)
      .eq('status', 'open')
      .single();

    if (existing) {
      return this.getConversationById(profileId, existing.id);
    }

    // Create new conversation
    const { data: conversation, error } = await supabase
      .from('conversations')
      .insert({
        user_id: profileId,
        subject: subject || 'Hỗ trợ khách hàng',
        status: 'open',
      })
      .select()
      .single();

    if (error) {
      throw new BadRequestException(`Error creating conversation: ${error.message}`);
    }

    return conversation;
  }

  /**
   * Get conversation by ID (must belong to user)
   */
  async getConversationById(profileId: string, conversationId: string) {
    const supabase = this.supabaseService.getClient();
    
    const { data: conversation, error } = await supabase
      .from('conversations')
      .select(`
        id,
        status,
        subject,
        created_at,
        updated_at,
        last_message_at
      `)
      .eq('id', conversationId)
      .eq('user_id', profileId)
      .single();

    if (error) {
      throw new NotFoundException('Conversation not found');
    }

    return conversation;
  }

  /**
   * Get messages for a conversation
   */
  async getMessages(profileId: string, conversationId: string) {
    const supabase = this.supabaseService.getClient();
    
    // Verify ownership
    const { data: conversation } = await supabase
      .from('conversations')
      .select('id')
      .eq('id', conversationId)
      .eq('user_id', profileId)
      .single();

    if (!conversation) {
      throw new NotFoundException('Conversation not found');
    }

    const { data: messages, error } = await supabase
      .from('chat_messages')
      .select(`
        id,
        content,
        sender_type,
        sender_id,
        is_read,
        created_at
      `)
      .eq('conversation_id', conversationId)
      .order('created_at', { ascending: true });

    if (error) {
      throw new BadRequestException(`Error fetching messages: ${error.message}`);
    }

    // Get admin names for admin messages
    const adminIds = messages
      .filter((m: any) => m.sender_type === 'admin' && m.sender_id)
      .map((m: any) => m.sender_id);

    let adminNames: Record<string, string> = {};
    if (adminIds.length > 0) {
      const { data: admins } = await supabase
        .from('profiles')
        .select('id, full_name')
        .in('id', adminIds);

      if (admins) {
        adminNames = admins.reduce((acc: any, admin: any) => {
          acc[admin.id] = admin.full_name || 'Nhân viên hỗ trợ';
          return acc;
        }, {});
      }
    }

    // Add sender names
    const messagesWithNames = messages.map((m: any) => ({
      ...m,
      sender_name: m.sender_type === 'admin' 
        ? adminNames[m.sender_id] || 'Nhân viên hỗ trợ'
        : undefined,
    }));

    return { messages: messagesWithNames };
  }

  /**
   * Send a message
   */
  async sendMessage(profileId: string, conversationId: string, content: string) {
    const supabase = this.supabaseService.getClient();
    
    // Verify ownership
    const { data: conversation } = await supabase
      .from('conversations')
      .select('id, status')
      .eq('id', conversationId)
      .eq('user_id', profileId)
      .single();

    if (!conversation) {
      throw new NotFoundException('Conversation not found');
    }

    // Insert message
    const { data: message, error } = await supabase
      .from('chat_messages')
      .insert({
        conversation_id: conversationId,
        content: content.trim(),
        sender_type: 'customer',
        sender_id: profileId,
        is_read: false,
      })
      .select()
      .single();

    if (error) {
      throw new BadRequestException(`Error sending message: ${error.message}`);
    }

    // Update conversation last_message_at and status
    await supabase
      .from('conversations')
      .update({
        last_message_at: new Date().toISOString(),
        status: 'open',
      })
      .eq('id', conversationId);

    return message;
  }

  /**
   * Mark messages as read
   */
  async markAsRead(profileId: string, conversationId: string) {
    const supabase = this.supabaseService.getClient();
    
    // Verify ownership
    const { data: conversation } = await supabase
      .from('conversations')
      .select('id')
      .eq('id', conversationId)
      .eq('user_id', profileId)
      .single();

    if (!conversation) {
      throw new NotFoundException('Conversation not found');
    }

    // Mark admin messages as read
    const { error } = await supabase
      .from('chat_messages')
      .update({ is_read: true })
      .eq('conversation_id', conversationId)
      .eq('sender_type', 'admin')
      .eq('is_read', false);

    if (error) {
      throw new BadRequestException(`Error marking messages as read: ${error.message}`);
    }

    return { success: true };
  }
}
