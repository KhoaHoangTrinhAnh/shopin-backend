import { Injectable, BadRequestException, NotFoundException, ForbiddenException, Inject, forwardRef } from '@nestjs/common';
import { SupabaseService } from '../supabase/supabase.service';
import { ChatGateway } from './chat.gateway';

/**
 * Chat Service
 * 
 * Handles all chat-related operations for both customers and admins.
 * Uses Supabase RPC functions for business logic (defined in migration 019).
 * Direct table queries are used only for read operations with RLS protection.
 * Emits WebSocket events for real-time updates.
 */
@Injectable()
export class ChatService {
  constructor(
    private readonly supabaseService: SupabaseService,
    @Inject(forwardRef(() => ChatGateway))
    private readonly chatGateway?: ChatGateway,
  ) {}

  // ============================================================================
  // ADMIN METHODS
  // ============================================================================

  /**
   * Get all conversations for admin panel
   * Sorted by last_message_at descending (most recent first)
   */
  async getConversations(page: number = 1, limit: number = 20, filters?: {
    status?: string;
    search?: string;
  }) {
    const supabase = this.supabaseService.getClient();
    const offset = (page - 1) * limit;

    // Build query for conversations (fetch profiles separately since there's no direct FK)
    let query = supabase
      .from('conversations')
      .select('*', { count: 'exact' });

    // Filter by status (default: exclude archived)
    if (filters?.status) {
      query = query.eq('status', filters.status);
    } else {
      // By default, show active and resolved (not archived)
      query = query.neq('status', 'archived');
    }

    const { data: conversations, error, count } = await query
      .order('last_message_at', { ascending: false, nullsFirst: false })
      .range(offset, offset + limit - 1);

    if (error) {
      throw new BadRequestException(`Error fetching conversations: ${error.message}`);
    }

    // Fetch user profiles for all conversations
    if (conversations && conversations.length > 0) {
      const userIds = conversations.map(c => c.user_id);
      const { data: profiles } = await supabase
        .from('profiles')
        .select('user_id, full_name, email, avatar_url')
        .in('user_id', userIds);

      // Map profiles to conversations
      const profileMap = new Map(profiles?.map(p => [p.user_id, p]) || []);
      
      const conversationsWithProfiles = conversations.map(c => ({
        ...c,
        user: profileMap.get(c.user_id) || null,
      }));

      // Apply search filter if needed (after fetching profiles)
      let filteredData = conversationsWithProfiles;
      if (filters?.search) {
        const searchLower = filters.search.toLowerCase();
        filteredData = conversationsWithProfiles.filter(c => {
          const fullName = c.user?.full_name?.toLowerCase() || '';
          const email = c.user?.email?.toLowerCase() || '';
          return fullName.includes(searchLower) || email.includes(searchLower);
        });
      }

      return {
        data: filteredData,
        meta: {
          total: count || 0,
          page,
          limit,
          totalPages: Math.ceil((count || 0) / limit),
        },
      };
    }

    return {
      data: [],
      meta: {
        total: count || 0,
        page,
        limit,
        totalPages: Math.ceil((count || 0) / limit),
      },
    };
  }

  /**
   * Get single conversation detail (admin)
   */
  async getConversation(id: string) {
    const supabase = this.supabaseService.getClient();

    const { data: conversation, error } = await supabase
      .from('conversations')
      .select('*')
      .eq('id', id)
      .single();

    if (error || !conversation) {
      throw new NotFoundException(`Conversation not found with ID: ${id}`);
    }

    // Fetch user profile separately
    const { data: profile } = await supabase
      .from('profiles')
      .select('user_id, full_name, email, avatar_url, created_at')
      .eq('user_id', conversation.user_id)
      .single();

    return {
      ...conversation,
      user: profile || null,
    };
  }

  /**
   * Get messages in a conversation
   * RLS ensures admin can only see if they have access
   */
  async getMessages(conversationId: string, limit: number = 50, offset: number = 0) {
    const supabase = this.supabaseService.getClient();

    // Fetch messages first
    const { data: messages, error, count } = await supabase
      .from('chat_messages')
      .select('*', { count: 'exact' })
      .eq('conversation_id', conversationId)
      .order('created_at', { ascending: true })
      .range(offset, offset + limit - 1);

    if (error) {
      throw new BadRequestException(`Error fetching messages: ${error.message}`);
    }

    // Fetch sender profiles separately if messages exist
    if (messages && messages.length > 0) {
      const senderIds = [...new Set(messages.map(m => m.sender_id))];
      const { data: profiles } = await supabase
        .from('profiles')
        .select('user_id, full_name, email, avatar_url, role')
        .in('user_id', senderIds);

      // Map profiles to messages
      const profileMap = new Map(profiles?.map(p => [p.user_id, p]) || []);
      const messagesWithSender = messages.map(m => ({
        ...m,
        sender: profileMap.get(m.sender_id) || null,
      }));

      return {
        data: messagesWithSender,
        meta: {
          total: count || 0,
          limit,
          offset,
        },
      };
    }

    return {
      data: [],
      meta: {
        total: count || 0,
        limit,
        offset,
      },
    };
  }

  /**
   * Send message as admin using RPC function
   * Emits WebSocket event for real-time delivery
   * Note: senderId is derived from accessToken via auth.uid() in RPC function
   */
  async sendMessageAsAdmin(conversationId: string, message: string, accessToken: string) {
    // Use authenticated client so RPC function can access auth.uid()
    const supabase = this.supabaseService.getClientWithAuth(accessToken);

    // Use RPC function which handles all business logic
    const { data, error } = await supabase
      .rpc('send_chat_message', {
        p_conversation_id: conversationId,
        p_message: message,
      });

    if (error) {
      throw new BadRequestException(`Error sending message: ${error.message}`);
    }

    // Fetch the message with sender profile
    const senderIds = [data.sender_id];
    const { data: profiles } = await supabase
      .from('profiles')
      .select('user_id, full_name, email, avatar_url, role')
      .in('user_id', senderIds);

    const profile = profiles?.[0] || null;
    const messageWithSender = {
      ...data,
      sender: profile,
    };

    // Emit WebSocket event for real-time delivery
    if (this.chatGateway?.server) {
      console.log(`[ChatService] Emitting message_received to room ${conversationId}`);
      // Use a timeout to ensure event is emitted after response
      setImmediate(() => {
        this.chatGateway?.server?.to(conversationId).emit('message_received', {
          message: messageWithSender,
          conversationId,
        });
        console.log(`[ChatService] ✅ Event emitted for room ${conversationId}`);
      });
    } else {
      console.warn('[ChatService] ⚠️ ChatGateway or server not available');
    }

    return messageWithSender;
  }

  /**
   * Update conversation status (resolve/archive) - admin only
   */
  async updateConversationStatus(conversationId: string, status: 'active' | 'resolved' | 'archived', accessToken: string) {
    // Use authenticated client so RPC function can access auth.uid()
    const supabase = this.supabaseService.getClientWithAuth(accessToken);

    const { data, error } = await supabase
      .rpc('update_conversation_status', {
        p_conversation_id: conversationId,
        p_status: status,
      });

    if (error) {
      throw new BadRequestException(`Error updating status: ${error.message}`);
    }

    return data;
  }

  /**
   * Mark messages as read using RPC function
   */
  async markAsRead(conversationId: string, accessToken?: string) {
    // Use authenticated client if token provided (for customer calls)
    // Otherwise use service client (for admin calls)
    const supabase = accessToken 
      ? this.supabaseService.getClientWithAuth(accessToken)
      : this.supabaseService.getClient();

    const { error } = await supabase
      .rpc('mark_messages_read', {
        p_conversation_id: conversationId,
      });

    if (error) {
      throw new BadRequestException(`Error marking messages as read: ${error.message}`);
    }

    return { success: true };
  }

  /**
   * Get admin unread count across all conversations
   */
  async getAdminUnreadCount(accessToken: string): Promise<number> {
    // Use authenticated client so RPC function can access auth.uid()
    const supabase = this.supabaseService.getClientWithAuth(accessToken);

    const { data, error } = await supabase
      .rpc('get_admin_unread_count');

    if (error) {
      console.error('Error getting admin unread count:', error);
      return 0;
    }

    return data || 0;
  }

  // ============================================================================
  // CUSTOMER METHODS
  // ============================================================================

  /**
   * Get or create conversation for customer using RPC function
   * Returns existing conversation or creates new one
   * Note: userId is derived from accessToken via auth.uid() in RPC function
   */
  async getOrCreateConversation(accessToken: string) {
    // Use authenticated client so RPC function can access auth.uid()
    const supabase = this.supabaseService.getClientWithAuth(accessToken);

    // Use RPC function which handles the logic
    const { data, error } = await supabase
      .rpc('create_or_get_conversation');

    if (error) {
      throw new BadRequestException(`Error getting conversation: ${error.message}`);
    }

    return data;
  }

  /**
   * Get customer's own conversation
   * Uses authenticated client to enforce RLS
   */
  async getUserConversation(accessToken: string) {
    const supabase = this.supabaseService.getClientWithAuth(accessToken);

    // RLS ensures user can only see their own conversation
    const { data, error } = await supabase
      .from('conversations')
      .select('*')
      .single();

    if (error && error.code !== 'PGRST116') {
      throw new BadRequestException(`Error fetching conversation: ${error.message}`);
    }

    return data || null;
  }

  /**
   * Send message as customer using RPC function
   * Supports auto-creating conversation if conversationId is null
   * Emits WebSocket event for real-time delivery
   */
  async sendMessageAsUser(userId: string, conversationId: string | null, message: string, accessToken: string) {
    // Use authenticated client so RPC function can access auth.uid()
    const supabase = this.supabaseService.getClientWithAuth(accessToken);

    // Use RPC function which handles:
    // - Auto-create conversation if null
    // - Validate message length
    // - Update conversation metadata
    const { data, error } = await supabase
      .rpc('send_chat_message', {
        p_conversation_id: conversationId,
        p_message: message,
      });

    if (error) {
      throw new BadRequestException(`Error sending message: ${error.message}`);
    }

    // Fetch sender profile
    const { data: profiles } = await supabase
      .from('profiles')
      .select('user_id, full_name, email, avatar_url, role')
      .eq('user_id', data.sender_id)
      .limit(1);

    const messageWithSender = {
      ...data,
      sender: profiles?.[0] || null,
    };

    // Emit WebSocket event for real-time delivery
    if (this.chatGateway?.server && data.conversation_id) {
      console.log(`[ChatService] Emitting message_received to room ${data.conversation_id}`);
      setImmediate(() => {
        this.chatGateway?.server?.to(data.conversation_id).emit('message_received', {
          message: messageWithSender,
          conversationId: data.conversation_id,
        });
        console.log(`[ChatService] ✅ Event emitted for room ${data.conversation_id}`);
        
        // Also notify admin of new conversation if it was just created
        if (!conversationId) {
          console.log('[ChatService] Broadcasting new conversation to admins');
          this.chatGateway?.broadcastNewConversation({ id: data.conversation_id, user_id: userId });
        }
      });
    } else {
      console.warn('[ChatService] ⚠️ ChatGateway or server not available');
    }

    return messageWithSender;
  }

  /**
   * Get customer unread count
   */
  async getCustomerUnreadCount(accessToken: string): Promise<number> {
    // Use authenticated client so RPC function can access auth.uid()
    const supabase = this.supabaseService.getClientWithAuth(accessToken);

    const { data, error } = await supabase
      .rpc('get_customer_unread_count');

    if (error) {
      console.error('Error getting customer unread count:', error);
      return 0;
    }

    return data || 0;
  }

  // ============================================================================
  // LEGACY METHODS (removed - use specific methods instead)
  // ============================================================================
  // sendMessage() - removed, use sendMessageAsAdmin() or sendMessageAsUser()
  // archiveConversation() - removed, use updateConversationStatus()
}
