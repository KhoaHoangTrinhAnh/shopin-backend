import { Controller, Get, Post, Delete, Param, Body, UseGuards } from '@nestjs/common';
import { FavoritesService } from './favorites.service';
import { AddFavoriteDto } from './dto/favorites.dto';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';
import { Profile } from '../decorators/profile.decorator';

@Controller('favorites')
@UseGuards(JwtAuthGuard)
export class FavoritesController {
  constructor(private readonly favoritesService: FavoritesService) {}

  @Get()
  async getFavorites(@Profile() profile: any) {
    return this.favoritesService.getFavorites(profile.user_id);
  }

  @Post()
  async addFavorite(@Profile() profile: any, @Body() dto: AddFavoriteDto) {
    return this.favoritesService.addFavorite(profile.user_id, dto);
  }

  @Delete(':productId')
  async removeFavorite(@Profile() profile: any, @Param('productId') productId: string) {
    return this.favoritesService.removeFavorite(profile.user_id, productId);
  }

  @Get(':productId/check')
  async checkFavorite(@Profile() profile: any, @Param('productId') productId: string) {
    const isFavorite = await this.favoritesService.isFavorite(profile.user_id, productId);
    return { isFavorite };
  }

  @Post(':productId/toggle')
  async toggleFavorite(@Profile() profile: any, @Param('productId') productId: string) {
    return this.favoritesService.toggleFavorite(profile.user_id, productId);
  }
}
