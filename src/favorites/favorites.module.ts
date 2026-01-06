import { Module } from '@nestjs/common';
import { FavoritesController } from './favorites.controller';
import { FavoritesService } from './favorites.service';
import { SupabaseModule } from '../supabase/supabase.module';
import { AuthModule } from '../auth/auth.module';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';

@Module({
  imports: [SupabaseModule, AuthModule],
  controllers: [FavoritesController],
  providers: [FavoritesService, JwtAuthGuard],
  exports: [FavoritesService],
})
export class FavoritesModule {}
