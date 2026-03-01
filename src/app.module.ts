import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { SupabaseModule } from './supabase/supabase.module';
import { ProductsModule } from './products/products.module';
import { CategoriesModule } from './categories/categories.module';
import { AuthModule } from './auth/auth.module';
import { CartModule } from './cart/cart.module';
import { FavoritesModule } from './favorites/favorites.module';
import { AddressesModule } from './addresses/addresses.module';
import { OrdersModule } from './orders/orders.module';
import { ProfilesModule } from './profiles/profiles.module';
import { AdminModule } from './admin/admin.module';
// ConversationsModule removed - consolidated into AdminModule (ChatController handles both admin and customer)
import { PaymentsModule } from './payments/payments.module';
import supabaseConfig from './config/supabase.config';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [supabaseConfig],
      envFilePath: '.env',
    }),
    SupabaseModule,
    ProductsModule,
    CategoriesModule,
    AuthModule,
    CartModule,
    FavoritesModule,
    AddressesModule,
    OrdersModule,
    ProfilesModule,
    AdminModule,
    // ConversationsModule removed - chat functionality now in AdminModule
    PaymentsModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
