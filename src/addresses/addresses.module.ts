import { Module } from '@nestjs/common';
import { AddressesController } from './addresses.controller';
import { AddressesService } from './addresses.service';
import { SupabaseModule } from '../supabase/supabase.module';
import { AuthModule } from '../auth/auth.module';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';

@Module({
  imports: [SupabaseModule, AuthModule],
  controllers: [AddressesController],
  providers: [AddressesService, JwtAuthGuard],
  exports: [AddressesService],
})
export class AddressesModule {}
