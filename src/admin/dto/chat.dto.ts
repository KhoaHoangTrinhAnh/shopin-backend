import { IsString, IsNotEmpty, IsUUID, IsOptional } from 'class-validator';

export class SendMessageDto {
  @IsUUID()
  @IsNotEmpty()
  conversation_id: string;

  @IsString()
  @IsNotEmpty()
  message: string;
}

export class CreateConversationDto {
  @IsUUID()
  @IsNotEmpty()
  user_id: string;
}

export class MarkAsReadDto {
  @IsUUID()
  @IsNotEmpty()
  conversation_id: string;
}

export class GetMessagesQueryDto {
  @IsUUID()
  @IsNotEmpty()
  conversation_id: string;

  @IsOptional()
  limit?: number;

  @IsOptional()
  offset?: number;
}
