import { Module } from '@nestjs/common';
import { AdminController } from './admin.controller';
import { AdminService } from './admin.service';
import { ArticlesController, PublicArticlesController } from './articles.controller';
import { ArticlesService } from './articles.service';
import { CouponsController, PublicCouponsController } from './coupons.controller';
import { CouponsService } from './coupons.service';
import { SettingsController } from './settings.controller';
import { SettingsService } from './settings.service';
import { AuditLogsController } from './audit-logs.controller';
import { AuditLogsService } from './audit-logs.service';
import { AdminChatController, ChatController } from './chat.controller';
import { ChatService } from './chat.service';
import { SupabaseModule } from '../supabase/supabase.module';
import { AuthModule } from '../auth/auth.module';

@Module({
  imports: [SupabaseModule, AuthModule],
  controllers: [
    AdminController,
    ArticlesController,
    PublicArticlesController,
    CouponsController,
    PublicCouponsController,
    SettingsController,
    AuditLogsController,
    AdminChatController,
    ChatController,
  ],
  providers: [AdminService, ArticlesService, CouponsService, SettingsService, AuditLogsService, ChatService],
  exports: [AdminService, ArticlesService, CouponsService, SettingsService, AuditLogsService, ChatService],
})
export class AdminModule {}
