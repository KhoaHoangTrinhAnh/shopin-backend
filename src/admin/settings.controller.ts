import {
  Controller,
  Get,
  Put,
  Post,
  Body,
  UseGuards,
  Param,
} from '@nestjs/common';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';
import { AdminGuard } from './guards/admin.guard';
import { SettingsService } from './settings.service';
import {
  AISettingsDto,
  ShopSettingsDto,
  ShopInfoDto,
  ShippingConfigDto,
  OrderConfigDto,
  DefaultSEODto,
  APISettingsDto,
} from './dto/admin.dto';

@Controller('admin/settings')
@UseGuards(JwtAuthGuard, AdminGuard)
export class SettingsController {
  constructor(private readonly settingsService: SettingsService) {}

  /**
   * Get all settings
   */
  @Get()
  async getAllSettings() {
    return this.settingsService.getAllSettings();
  }

  /**
   * Get AI settings
   */
  @Get('ai')
  async getAISettings() {
    return this.settingsService.getAISettings();
  }

  /**
   * Update AI settings
   */
  @Put('ai')
  async updateAISettings(@Body() dto: AISettingsDto) {
    return this.settingsService.updateAISettings(dto);
  }

  /**
   * Reset AI prompt to default
   */
  @Post('ai/reset-prompt')
  async resetAIPrompt() {
    return this.settingsService.resetAIPrompt();
  }

  /**
   * Get shop settings
   */
  @Get('shop')
  async getShopSettings() {
    return this.settingsService.getShopSettings();
  }

  /**
   * Update shop settings
   */
  @Put('shop')
  async updateShopSettings(@Body() dto: ShopSettingsDto) {
    return this.settingsService.updateShopSettings(dto);
  }

  // =========================================================================
  // NEW SEPARATED SETTINGS (Migration 013)
  // =========================================================================

  /**
   * Get shop info
   */
  @Get('shop-info')
  async getShopInfo() {
    return this.settingsService.getShopInfo();
  }

  /**
   * Update shop info
   */
  @Put('shop-info')
  async updateShopInfo(@Body() dto: ShopInfoDto) {
    return this.settingsService.updateShopInfo(dto);
  }

  /**
   * Get shipping config
   */
  @Get('shipping')
  async getShippingConfig() {
    return this.settingsService.getShippingConfig();
  }

  /**
   * Update shipping config
   */
  @Put('shipping')
  async updateShippingConfig(@Body() dto: ShippingConfigDto) {
    return this.settingsService.updateShippingConfig(dto);
  }

  /**
   * Get order config
   */
  @Get('order')
  async getOrderConfig() {
    return this.settingsService.getOrderConfig();
  }

  /**
   * Update order config
   */
  @Put('order')
  async updateOrderConfig(@Body() dto: OrderConfigDto) {
    return this.settingsService.updateOrderConfig(dto);
  }

  /**
   * Get default SEO
   */
  @Get('seo')
  async getDefaultSEO() {
    return this.settingsService.getDefaultSEO();
  }

  /**
   * Update default SEO
   */
  @Put('seo')
  async updateDefaultSEO(@Body() dto: DefaultSEODto) {
    return this.settingsService.updateDefaultSEO(dto);
  }

  // =========================================================================
  // API SETTINGS (api_settings table)
  // =========================================================================

  /**
   * Get all API settings
   */
  @Get('api')
  async getAllAPISettings() {
    return this.settingsService.getAllAPISettings();
  }

  /**
   * Get specific API setting by key
   */
  @Get('api/:key')
  async getAPISettings(@Param('key') key: string) {
    return this.settingsService.getAPISettings(key);
  }

  /**
   * Update API settings
   */
  @Put('api/:key')
  async updateAPISettings(@Param('key') key: string, @Body() dto: APISettingsDto) {
    return this.settingsService.updateAPISettings(key, dto);
  }
}
