import { Module } from '@nestjs/common';
import { ProfilesController } from './profiles.controller';
import { ProfilesService } from './profiles.service';
import { SupabaseModule } from '../supabase/supabase.module';
import { AuthModule } from '../auth/auth.module';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';

@Module({
  imports: [SupabaseModule, AuthModule],
  controllers: [ProfilesController],
  providers: [ProfilesService, JwtAuthGuard],
  exports: [ProfilesService],
})
export class ProfilesModule {}
