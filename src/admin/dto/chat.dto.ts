import { IsString, IsNotEmpty, IsUUID, IsOptional, IsIn, MinLength, MaxLength } from 'class-validator';

/**
 * DTO for sending a message (admin)
 * conversation_id is required for admin
 */
export class SendMessageDto {
  @IsUUID()
  @IsNotEmpty()
  conversation_id: string;

  @IsString()
  @IsNotEmpty()
  @MinLength(1, { message: 'Message cannot be empty' })
  @MaxLength(5000, { message: 'Message too long (max 5000 characters)' })
  message: string;
}

/**
 * DTO for sending a message (customer)
 * conversation_id is optional - auto-creates if null
 */
export class CustomerSendMessageDto {
  @IsUUID()
  @IsOptional()
  conversation_id?: string;

  @IsString()
  @IsNotEmpty()
  @MinLength(1, { message: 'Message cannot be empty' })
  @MaxLength(5000, { message: 'Message too long (max 5000 characters)' })
  message: string;
}

/**
 * DTO for updating conversation status
 */
export class UpdateConversationStatusDto {
  @IsString()
  @IsNotEmpty()
  @IsIn(['active', 'resolved', 'archived'], {
    message: 'Status must be: active, resolved, or archived',
  })
  status: 'active' | 'resolved' | 'archived';
}

/**
 * DTO for creating a conversation (legacy, kept for compatibility)
 */
export class CreateConversationDto {
  @IsUUID()
  @IsNotEmpty()
  user_id: string;
}

/**
 * DTO for marking messages as read (legacy, kept for compatibility)
 */
export class MarkAsReadDto {
  @IsUUID()
  @IsNotEmpty()
  conversation_id: string;
}

/**
 * Query DTO for getting messages with pagination
 */
export class GetMessagesQueryDto {
  @IsUUID()
  @IsNotEmpty()
  conversation_id: string;

  @IsOptional()
  limit?: number;

  @IsOptional()
  offset?: number;
}
