import { Module } from '@nestjs/common';
import { CategoriesController, BrandsController, AdminCategoriesController, AdminBrandsController } from './categories.controller';
import { CategoriesService, BrandsService } from './categories.service';
import { SupabaseModule } from '../supabase/supabase.module';
import { AuthModule } from '../auth/auth.module';

@Module({
  imports: [SupabaseModule, AuthModule],
  controllers: [CategoriesController, BrandsController, AdminCategoriesController, AdminBrandsController],
  providers: [CategoriesService, BrandsService],
  exports: [CategoriesService, BrandsService],
})
export class CategoriesModule {}
