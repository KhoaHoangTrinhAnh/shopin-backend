# CHAT SYSTEM & UI IMPROVEMENTS - Change Summary

## Overview
Implemented real-time chat system for admin-customer support, separated API settings management, improved sidebar UX with collapsible design.

---

## 🗄️ DATABASE CHANGES (Migration 013 Updated)

### New Tables

#### 1. conversations
```sql
CREATE TABLE public.conversations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  last_message text,
  last_message_at timestamptz DEFAULT now(),
  unread_count integer DEFAULT 0,
  status text DEFAULT 'active' CHECK (status IN ('active', 'archived', 'closed')),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);
```

**Features:**
- Tracks chat conversations between users and admin
- Auto-created when user sends first message
- Stores last message and unread count for notifications
- Status tracking (active/archived/closed)

#### 2. chat_messages
```sql
CREATE TABLE public.chat_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id uuid NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
  sender_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  sender_role text NOT NULL CHECK (sender_role IN ('user', 'admin')),
  message text NOT NULL,
  is_read boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);
```

**Features:**
- Stores individual chat messages
- Tracks sender role (user/admin) for bubble positioning
- Read status for unread count
- Timestamps for message ordering

### Indexes Added
```sql
CREATE INDEX idx_conversations_user_id ON conversations(user_id);
CREATE INDEX idx_conversations_status ON conversations(status);
CREATE INDEX idx_conversations_last_message_at ON conversations(last_message_at DESC);
CREATE INDEX idx_chat_messages_conversation_id ON chat_messages(conversation_id);
CREATE INDEX idx_chat_messages_sender_id ON chat_messages(sender_id);
CREATE INDEX idx_chat_messages_created_at ON chat_messages(created_at DESC);
CREATE INDEX idx_chat_messages_is_read ON chat_messages(is_read);
```

### RLS Policies

**conversations:**
- Users can view/create/update their own conversations
- Admins can view all conversations

**chat_messages:**
- Users can view messages in their conversations
- Admins can view all messages
- Both can send messages
- Both can mark messages as read

---

## 🔧 BACKEND CHANGES

### Fixed Import Error
**File:** `categories.controller.ts`
```typescript
// Before
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

// After
import { JwtAuthGuard } from '../guards/jwt-auth.guard';
```

### New DTOs (`admin/dto/chat.dto.ts`)
```typescript
- SendMessageDto { conversation_id, message }
- CreateConversationDto { user_id }
- MarkAsReadDto { conversation_id }
- GetMessagesQueryDto { conversation_id, limit?, offset? }
```

### New Service (`admin/chat.service.ts`)

**Methods:**
1. `getConversations(page, limit, filters)` - List all conversations for admin
2. `getConversation(id)` - Get conversation detail with user info
3. `getMessages(conversationId, limit, offset)` - Get paginated messages
4. `sendMessage(senderId, conversationId, message, role)` - Send message
5. `getOrCreateConversation(userId)` - Auto-create conversation for user
6. `markAsRead(conversationId, role)` - Mark messages as read
7. `archiveConversation(id)` - Archive conversation
8. `getUserConversation(userId)` - Get user's own conversation

**Features:**
- Auto-updates conversation last_message and timestamp
- Increments unread_count when message sent
- Resets unread_count when marked as read
- Fetches user/sender profiles with messages

### New Controllers (`admin/chat.controller.ts`)

#### AdminChatController (`/api/admin/chat`)
```
GET    /conversations - List all conversations
GET    /conversations/:id - Get conversation detail
GET    /conversations/:id/messages - Get messages
POST   /messages - Send message as admin
PUT    /conversations/:id/mark-read - Mark as read
PUT    /conversations/:id/archive - Archive conversation
```

#### ChatController (`/api/chat`)
```
GET    /conversation - Get user's own conversation
POST   /conversation - Create/get conversation
GET    /messages - Get messages in user's conversation
POST   /messages - Send message as user
PUT    /messages/mark-read - Mark messages as read
```

### Module Updated (`admin/admin.module.ts`)
- Added `AdminChatController`
- Added `ChatController`
- Added `ChatService`

---

## 🎨 FRONTEND CHANGES

### 1. Sidebar UX Improvements (`admin/layout.tsx`)

**Collapsible Sidebar:**
- Added collapse button on right edge of sidebar
- Smooth transition between expanded (w-64) and collapsed (w-20)
- Shows only icons when collapsed
- Button positioned at right edge with arrow indicator

**Navigation Restructure:**
```
- Dashboard
- Đơn hàng
- Sản phẩm  
- Người dùng
- Bài viết (collapsible)
  └─ Danh sách bài viết
- API Settings (NEW - standalone)
- Mã giảm giá
- Danh mục & Thương hiệu
- Hỗ trợ khách hàng (NEW)
- Cài đặt (collapsible)
  ├─ Thông tin cửa hàng
  ├─ Vận chuyển
  ├─ Đơn hàng
  └─ SEO mặc định
- Nhật ký hoạt động
```

**Key Changes:**
- Separated "API Settings" from "Bài viết" submenu
- Removed "Cấu hình API" from articles children
- Added "Hỗ trợ khách hàng" (Chat) top-level menu
- Improved icon usage (MessageSquare for chat)

### 2. API Keys Management Page (`admin/api-keys/page.tsx`)

**Features:**
- **List API Keys:** Table view with name, masked key, description, last used
- **Add/Edit Form:** Modal-style form with validation
- **Show/Hide Key:** Toggle visibility with eye icon
- **Delete with Confirmation:** Protect against accidental deletion
- **Security Notice:** Yellow banner about API key security

**UI Components:**
- Table with sortable columns
- Inline edit/delete actions
- Password-style input for API keys
- Character counter for descriptions
- Empty state with icon

**API Integration Points (Placeholder):**
```typescript
// TODO: Replace with actual endpoints
POST   /api/admin/api-keys - Create new key
PUT    /api/admin/api-keys/:id - Update key
DELETE /api/admin/api-keys/:id - Delete key
GET    /api/admin/api-keys - List keys
```

### 3. Admin Chat Page (`admin/chat/page.tsx`)

**Layout Structure:**

```
┌─────────────────────────────────────────────┐
│  [Conversations List]  │  [Chat Area]       │
│  ┌──────────────────┐  │  ┌──────────────┐ │
│  │ Search           │  │  │ Header       │ │
│  ├──────────────────┤  │  ├──────────────┤ │
│  │ Conv 1 [3]       │  │  │              │ │
│  │ Conv 2           │  │  │   Messages   │ │
│  │ Conv 3 [1]       │  │  │              │ │
│  │ ...              │  │  ├──────────────┤ │
│  └──────────────────┘  │  │ Input + Send │ │
│                         │  └──────────────┘ │
└─────────────────────────────────────────────┘
```

**Conversations List (Left - 320px):**
- Search bar for filtering conversations
- List of conversations with:
  - Avatar (with online indicator)
  - User name
  - Last message preview
  - Timestamp (hh:mm dd/mm)
  - Unread count badge
- Active conversation highlighted

**Chat Header:**
- User avatar with online/offline indicator
- User name
- Online status text (real-time)
- Archive button

**Chat Body:**
- Message bubbles:
  - Admin messages: right side, primary color
  - User messages: left side, gray background
- Timestamp format: `hh:mm dd/mm/yyyy`
- Auto-scroll to bottom on new messages

**Chat Footer:**
- Textarea input (auto-resize, max 2 rows)
- Send button (disabled when empty)
- Enter to send, Shift+Enter for new line

**Features:**
- Real-time online status (placeholder - use WebSocket in production)
- Unread count tracking
- Archive conversations
- Mark as read automatically
- Auto-create conversation on first message
- Search/filter conversations
- Empty states for no conversations/no selection

---

## 🔄 REAL-TIME FEATURES (To Implement)

### WebSocket Integration

**Backend (NestJS):**
```bash
npm install @nestjs/websockets @nestjs/platform-socket.io socket.io
```

**Create Gateway:**
```typescript
// src/chat/chat.gateway.ts
@WebSocketGateway({
  cors: { origin: '*' },
  namespace: '/chat',
})
export class ChatGateway {
  @SubscribeMessage('join-conversation')
  handleJoinConversation(client: Socket, conversationId: string) {
    client.join(`conversation-${conversationId}`);
  }

  @SubscribeMessage('send-message')
  async handleMessage(client: Socket, payload: any) {
    // Save message via ChatService
    // Emit to conversation room
    this.server.to(`conversation-${payload.conversation_id}`).emit('new-message', message);
  }

  @SubscribeMessage('typing')
  handleTyping(client: Socket, conversationId: string) {
    client.to(`conversation-${conversationId}`).emit('user-typing');
  }
}
```

**Frontend:**
```typescript
import io from 'socket.io-client';

const socket = io('http://localhost:3001/chat', {
  auth: { token: 'jwt-token' }
});

socket.on('new-message', (message) => {
  setMessages(prev => [...prev, message]);
});

socket.on('user-typing', () => {
  setIsTyping(true);
});
```

### Online Status Tracking

**Use Supabase Realtime:**
```typescript
// Track presence
const channel = supabase.channel('online-users');
channel
  .on('presence', { event: 'sync' }, () => {
    const state = channel.presenceState();
    const onlineUserIds = Object.keys(state);
    setOnlineUsers(new Set(onlineUserIds));
  })
  .subscribe(async (status) => {
    if (status === 'SUBSCRIBED') {
      await channel.track({ user_id: profile.id, online_at: new Date() });
    }
  });
```

---

## 📝 API ENDPOINTS SUMMARY

### Admin Chat APIs

```
GET    /api/admin/chat/conversations
       ?page=1&limit=20&status=active
       Response: { data: Conversation[], meta: {...} }

GET    /api/admin/chat/conversations/:id
       Response: Conversation with user details

GET    /api/admin/chat/conversations/:id/messages
       ?limit=50&offset=0
       Response: { data: Message[], meta: {...} }

POST   /api/admin/chat/messages
       Body: { conversation_id, message }
       Response: Message

PUT    /api/admin/chat/conversations/:id/mark-read
       Response: { success: true }

PUT    /api/admin/chat/conversations/:id/archive
       Response: { success: true }
```

### User Chat APIs

```
GET    /api/chat/conversation
       Response: Conversation | null

POST   /api/chat/conversation
       Response: Conversation (creates if not exists)

GET    /api/chat/messages
       ?limit=50&offset=0
       Response: { data: Message[], meta: {...} }

POST   /api/chat/messages
       Body: { message }
       Response: Message (auto-creates conversation)

PUT    /api/chat/messages/mark-read
       Response: { success: true }
```

---

## ✅ TESTING CHECKLIST

### Backend
- [ ] Run migration 013 successfully
- [ ] Verify conversations and chat_messages tables exist
- [ ] Test RLS policies (user can only see own conversation)
- [ ] Test admin can see all conversations
- [ ] Test sending messages from admin and user
- [ ] Test unread count increments/decrements
- [ ] Test conversation auto-creation
- [ ] Test archive functionality

### Frontend - Sidebar
- [ ] Sidebar collapses to icon-only view
- [ ] Collapse button appears on right edge
- [ ] Navigation items show tooltips when collapsed
- [ ] "API Settings" appears as standalone menu
- [ ] "Hỗ trợ khách hàng" (Chat) appears in menu
- [ ] Submenu items work correctly

### Frontend - API Keys Page
- [ ] Navigate to /admin/api-keys
- [ ] List shows placeholder keys
- [ ] Add button opens form
- [ ] Edit button opens form with data
- [ ] Show/hide key toggle works
- [ ] Delete confirms before deletion
- [ ] Form validation works
- [ ] Save button functional

### Frontend - Chat Page
- [ ] Navigate to /admin/chat
- [ ] Conversations list loads
- [ ] Search filters conversations
- [ ] Click conversation loads messages
- [ ] Send message works
- [ ] Message appears in correct bubble (left/right)
- [ ] Timestamp format correct
- [ ] Online status shows correctly
- [ ] Unread count updates
- [ ] Archive conversation works
- [ ] Auto-scroll to bottom
- [ ] Enter to send works
- [ ] Shift+Enter adds new line

---

## 🚀 DEPLOYMENT STEPS

### 1. Backend

```bash
cd shopin-backend

# Run migration
psql -h YOUR_SUPABASE_HOST -U postgres -d YOUR_DATABASE -f database/013_admin_panel_features.sql

# Build and restart
npm run build
pm2 restart shopin-backend
```

### 2. Frontend

```bash
cd shopin-frontend
npm run build

# Deploy to Cloudflare Pages or Vercel
```

### 3. WebSocket Setup (Optional - Future)

```bash
# Install dependencies
npm install @nestjs/websockets @nestjs/platform-socket.io socket.io

# Create gateway
nest g gateway chat

# Update main.ts to enable CORS for WebSocket
```

---

## 🔮 FUTURE ENHANCEMENTS

### Chat Features
- [ ] File/image attachments
- [ ] Emoji picker
- [ ] Message reactions
- [ ] Typing indicators (real-time)
- [ ] Message read receipts
- [ ] Voice messages
- [ ] Canned responses for admin
- [ ] Conversation tags/labels
- [ ] Search within conversation
- [ ] Message deletion
- [ ] Edit sent messages
- [ ] Quote/reply to specific message

### API Keys Features
- [ ] API key usage analytics
- [ ] Rate limiting per key
- [ ] Key expiration dates
- [ ] Key scopes/permissions
- [ ] Regenerate key functionality
- [ ] Multiple keys per service
- [ ] Key rotation schedule
- [ ] Audit log for key usage

### Admin Features
- [ ] Bulk conversation actions
- [ ] Conversation assignment (to specific admin)
- [ ] SLA tracking (response time)
- [ ] Customer satisfaction rating
- [ ] Chat analytics dashboard
- [ ] Export conversation history
- [ ] Automated responses (chatbot)
- [ ] Working hours settings

---

## 📊 PERFORMANCE CONSIDERATIONS

### Database
- Indexes on frequently queried columns (user_id, conversation_id, created_at)
- Consider partitioning chat_messages by date for large datasets
- Archive old conversations to separate table

### Frontend
- Implement virtualized list for large conversation lists
- Lazy load older messages (pagination)
- Optimize re-renders with React.memo
- Use WebSocket for real-time updates instead of polling

### Real-time
- Use Redis for presence tracking at scale
- Implement message queue for high-volume scenarios
- Rate limit message sending
- Compress WebSocket payloads

---

## 🐛 KNOWN ISSUES & LIMITATIONS

### Current Implementation
1. **No WebSocket** - Using placeholder for real-time features
2. **No File Upload** - Text-only messages
3. **No Typing Indicators** - Not implemented yet
4. **API Keys** - Placeholder data, no backend yet
5. **Online Status** - Simulated, needs WebSocket/Realtime

### To Fix Before Production
- [ ] Implement actual WebSocket gateway
- [ ] Add file upload to chat
- [ ] Create API keys backend endpoints
- [ ] Implement proper online tracking
- [ ] Add message pagination
- [ ] Add error handling and retry logic
- [ ] Add loading states everywhere
- [ ] Add proper TypeScript types
- [ ] Add input validation
- [ ] Add rate limiting

---

**Migration Version:** 013 (Updated)
**Date:** 2025-01-05
**Status:** ✅ Complete (Backend + Frontend UI ready, WebSocket pending)
