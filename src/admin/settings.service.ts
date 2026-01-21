import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { SupabaseService } from '../supabase/supabase.service';
import {
  AISettingsDto,
  ShopSettingsDto,
  ShopInfoDto,
  ShippingConfigDto,
  OrderConfigDto,
  DefaultSEODto,
  APISettingsDto,
} from './dto/admin.dto';

@Injectable()
export class SettingsService {
  constructor(private readonly supabaseService: SupabaseService) {}

  // Default AI prompt
  private readonly defaultAIPrompt = `Hãy viết một bài viết chi tiết, chuyên nghiệp và hấp dẫn. Bài viết cần có:
1. Tiêu đề hấp dẫn
2. Mở bài thu hút
3. Nội dung chính với các tiêu đề phụ rõ ràng
4. Kết luận súc tích
5. Sử dụng ngôn ngữ tự nhiên, dễ hiểu

Đảm bảo bài viết có giá trị thông tin cao và tối ưu cho SEO.`;

  /**
   * Get AI settings
   */
  async getAISettings() {
    const supabase = this.supabaseService.getClient();

    const { data, error } = await supabase
      .from('admin_settings')
      .select('value')
      .eq('key', 'ai_content_generation')
      .single();

    if (error || !data) {
      // Return default settings
      return {
        api_key: '',
        model: 'gpt-4',
        api_url: 'https://api.openai.com/v1/chat/completions',
        prompt: this.defaultAIPrompt,
      };
    }

    // Mask API key for security
    const settings = data.value as {
      api_key: string;
      model: string;
      api_url: string;
      prompt: string;
    };

    return {
      ...settings,
      api_key: settings.api_key ? '***' + settings.api_key.slice(-4) : '',
      has_api_key: !!settings.api_key,
    };
  }

  /**
   * Update AI settings
   */
  async updateAISettings(dto: AISettingsDto) {
    const supabase = this.supabaseService.getClient();

    // Get current settings
    const { data: current } = await supabase
      .from('admin_settings')
      .select('value')
      .eq('key', 'ai_content_generation')
      .single();

    const currentSettings = current?.value || {};

    // Prepare update data (only update provided fields)
    const updateData = { ...currentSettings };
    if (dto.api_key !== undefined && dto.api_key !== '') {
      updateData.api_key = dto.api_key;
    }
    if (dto.model !== undefined) {
      updateData.model = dto.model;
    }
    if (dto.api_url !== undefined) {
      updateData.api_url = dto.api_url;
    }
    if (dto.prompt !== undefined) {
      updateData.prompt = dto.prompt;
    }

    const { data, error } = await supabase
      .from('admin_settings')
      .upsert({
        key: 'ai_content_generation',
        value: updateData,
        updated_at: new Date().toISOString(),
      })
      .select()
      .single();

    if (error) {
      throw new BadRequestException(`Lỗi khi cập nhật AI settings: ${error.message}`);
    }

    return {
      message: 'Cập nhật AI settings thành công',
      ...updateData,
      api_key: updateData.api_key ? '***' + updateData.api_key.slice(-4) : '',
      has_api_key: !!updateData.api_key,
    };
  }

  /**
   * Reset AI prompt to default
   */
  async resetAIPrompt() {
    const supabase = this.supabaseService.getClient();

    // Get current settings
    const { data: current } = await supabase
      .from('admin_settings')
      .select('value')
      .eq('key', 'ai_content_generation')
      .single();

    const currentSettings = current?.value || {};

    const { error } = await supabase
      .from('admin_settings')
      .upsert({
        key: 'ai_content_generation',
        value: { ...currentSettings, prompt: this.defaultAIPrompt },
        updated_at: new Date().toISOString(),
      });

    if (error) {
      throw new BadRequestException(`Lỗi khi reset AI prompt: ${error.message}`);
    }

    return {
      message: 'Reset AI prompt thành công',
      prompt: this.defaultAIPrompt,
    };
  }

  /**
   * Get shop settings
   */
  async getShopSettings() {
    const supabase = this.supabaseService.getClient();

    const { data, error } = await supabase
      .from('admin_settings')
      .select('value')
      .eq('key', 'shop_settings')
      .single();

    if (error || !data) {
      // Return default settings
      return {
        shop_name: 'ShopIn',
        shop_description: 'Cửa hàng điện tử trực tuyến',
        contact_email: 'contact@shopin.vn',
        contact_phone: '+84123456789',
        address: '123 Đường ABC, Quận 1, TP.HCM',
        social_links: {
          facebook: '',
          instagram: '',
          youtube: '',
        },
        shipping_fee: 30000,
        free_shipping_threshold: 5000000,
      };
    }

    return data.value;
  }

  /**
   * Update shop settings
   */
  async updateShopSettings(dto: ShopSettingsDto) {
    const supabase = this.supabaseService.getClient();

    // Get current settings
    const { data: current } = await supabase
      .from('admin_settings')
      .select('value')
      .eq('key', 'shop_settings')
      .single();

    const currentSettings = current?.value || {};

    // Merge with new settings
    const updateData = {
      ...currentSettings,
      ...dto,
      social_links: {
        ...currentSettings.social_links,
        ...dto.social_links,
      },
    };

    const { data, error } = await supabase
      .from('admin_settings')
      .upsert({
        key: 'shop_settings',
        value: updateData,
        updated_at: new Date().toISOString(),
      })
      .select()
      .single();

    if (error) {
      throw new BadRequestException(`Lỗi khi cập nhật shop settings: ${error.message}`);
    }

    return {
      message: 'Cập nhật cài đặt cửa hàng thành công',
      ...updateData,
    };
  }

  /**
   * Get all settings (for admin dashboard)
   */
  async getAllSettings() {
    const [aiSettings, shopSettings] = await Promise.all([
      this.getAISettings(),
      this.getShopSettings(),
    ]);

    return {
      ai: aiSettings,
      shop: shopSettings,
    };
  }

  // =========================================================================
  // NEW SEPARATED SETTINGS (Migration 013)
  // =========================================================================

  /**
   * Get shop info (shop_info key)
   */
  async getShopInfo() {
    const supabase = this.supabaseService.getClient();

    const { data, error } = await supabase
      .from('admin_settings')
      .select('value')
      .eq('key', 'shop_info')
      .single();

    if (error || !data) {
      return {
        shop_name: 'ShopIn',
        contact_email: 'contact@shopin.vn',
        hotline: '+84 123 456 789',
      };
    }

    return data.value;
  }

  /**
   * Update shop info
   */
  async updateShopInfo(dto: ShopInfoDto) {
    const supabase = this.supabaseService.getClient();

    const { error } = await supabase
      .from('admin_settings')
      .upsert({
        key: 'shop_info',
        value: dto,
        updated_at: new Date().toISOString(),
      });

    if (error) {
      throw new BadRequestException(`Lỗi khi cập nhật thông tin cửa hàng: ${error.message}`);
    }

    return {
      message: 'Cập nhật thông tin cửa hàng thành công',
      ...dto,
    };
  }

  /**
   * Get shipping config (shipping_config key)
   */
  async getShippingConfig() {
    const supabase = this.supabaseService.getClient();

    const { data, error } = await supabase
      .from('admin_settings')
      .select('value')
      .eq('key', 'shipping_config')
      .single();

    if (error || !data) {
      return {
        default_shipping_fee: 30000,
        estimated_delivery_days: 3,
      };
    }

    return data.value;
  }

  /**
   * Update shipping config
   */
  async updateShippingConfig(dto: ShippingConfigDto) {
    const supabase = this.supabaseService.getClient();

    const { error } = await supabase
      .from('admin_settings')
      .upsert({
        key: 'shipping_config',
        value: dto,
        updated_at: new Date().toISOString(),
      });

    if (error) {
      throw new BadRequestException(`Lỗi khi cập nhật cấu hình vận chuyển: ${error.message}`);
    }

    return {
      message: 'Cập nhật cấu hình vận chuyển thành công',
      ...dto,
    };
  }

  /**
   * Get order config (order_config key)
   */
  async getOrderConfig() {
    const supabase = this.supabaseService.getClient();

    const { data, error } = await supabase
      .from('admin_settings')
      .select('value')
      .eq('key', 'order_config')
      .single();

    if (error || !data) {
      return {
        cod_enabled: true,
      };
    }

    return data.value;
  }

  /**
   * Update order config
   */
  async updateOrderConfig(dto: OrderConfigDto) {
    const supabase = this.supabaseService.getClient();

    const { error } = await supabase
      .from('admin_settings')
      .upsert({
        key: 'order_config',
        value: dto,
        updated_at: new Date().toISOString(),
      });

    if (error) {
      throw new BadRequestException(`Lỗi khi cập nhật cấu hình đơn hàng: ${error.message}`);
    }

    return {
      message: 'Cập nhật cấu hình đơn hàng thành công',
      ...dto,
    };
  }

  /**
   * Get default SEO (default_seo key)
   */
  async getDefaultSEO() {
    const supabase = this.supabaseService.getClient();

    const { data, error } = await supabase
      .from('admin_settings')
      .select('value')
      .eq('key', 'default_seo')
      .single();

    if (error || !data) {
      return {
        meta_title: 'ShopIn - Mua sắm trực tuyến',
        meta_description: 'Cửa hàng điện tử trực tuyến uy tín, giá tốt',
      };
    }

    return data.value;
  }

  /**
   * Update default SEO
   */
  async updateDefaultSEO(dto: DefaultSEODto) {
    const supabase = this.supabaseService.getClient();

    const { error } = await supabase
      .from('admin_settings')
      .upsert({
        key: 'default_seo',
        value: dto,
        updated_at: new Date().toISOString(),
      });

    if (error) {
      throw new BadRequestException(`Lỗi khi cập nhật SEO mặc định: ${error.message}`);
    }

    return {
      message: 'Cập nhật SEO mặc định thành công',
      ...dto,
    };
  }

  // =========================================================================
  // API SETTINGS (api_settings table)
  // =========================================================================

  /**
   * Get API settings for article generation
   */
  async getAPISettings(key: string = 'article_generation') {
    const supabase = this.supabaseService.getClient();

    const { data, error } = await supabase
      .from('api_settings')
      .select('*')
      .eq('key', key)
      .single();

    if (error || !data) {
      // Return default
      return {
        key: 'article_generation',
        model_name: 'gpt-4',
        api_endpoint: 'https://api.openai.com/v1/chat/completions',
        default_prompt: this.defaultAIPrompt,
        description: 'Tạo nội dung bài viết tự động từ từ khóa',
      };
    }

    return data;
  }

  /**
   * Update API settings
   */
  async updateAPISettings(key: string, dto: APISettingsDto) {
    const supabase = this.supabaseService.getClient();

    const { error } = await supabase
      .from('api_settings')
      .upsert({
        key,
        model_name: dto.model_name,
        api_endpoint: dto.api_endpoint,
        default_prompt: dto.default_prompt,
        description: dto.description,
        updated_at: new Date().toISOString(),
      });

    if (error) {
      throw new BadRequestException(`Lỗi khi cập nhật API settings: ${error.message}`);
    }

    return {
      message: 'Cập nhật API settings thành công',
      key,
      ...dto,
    };
  }

  /**
   * Get all API settings
   */
  async getAllAPISettings() {
    const supabase = this.supabaseService.getClient();

    const { data, error } = await supabase
      .from('api_settings')
      .select('*')
      .order('key', { ascending: true });

    if (error) {
      throw new BadRequestException(`Lỗi khi lấy danh sách API settings: ${error.message}`);
    }

    return data || [];
  }
}
