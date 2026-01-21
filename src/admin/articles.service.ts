import { Injectable, NotFoundException, BadRequestException, ForbiddenException } from '@nestjs/common';
import { SupabaseService } from '../supabase/supabase.service';
import { CreateArticleDto, UpdateArticleDto, GenerateArticleDto, PaginationQueryDto } from './dto/admin.dto';

// ============================================================================
// Types for AI Response Parsing
// ============================================================================

export interface ParsedArticleContent {
  title: string;
  body: string;
  slug: string;
  tags: string[];
  meta: {
    meta_title: string;
    meta_description: string;
    seo_keywords: string;
  };
}

export interface ValidationResult {
  valid: boolean;
  warnings: string[];
  errors: string[];
}

interface RateLimitEntry {
  count: number;
  resetAt: number;
}

// ============================================================================
// Constants
// ============================================================================

const RATE_LIMIT_MAX_REQUESTS = 10;
const RATE_LIMIT_WINDOW_MS = 60 * 60 * 1000; // 1 hour

const DEFAULT_OPENROUTER_ENDPOINT = 'https://openrouter.ai/api/v1/chat/completions';
const DEFAULT_MODEL_NAME = 'meta-llama/llama-3.3-70b-instruct:free';

const HARD_PROMPT_PREFIX = `Dựa trên từ khóa: '{keyword}', hãy viết một bài viết tin tức hoàn chỉnh bằng tiếng Việt.

QUAN TRỌNG: Trả lời CHÍNH XÁC theo format sau, không thêm ký tự đặc biệt, sử dụng định dạng thẻ <h3> cho tiêu đề phụ và thẻ <p> cho nội dung, KHÔNG sử dụng ** hoặc markdown formatting:

`;

@Injectable()
export class ArticlesService {
  // In-memory rate limiting (per-user or global)
  private readonly rateLimitMap = new Map<string, RateLimitEntry>();

  private readonly DEFAULT_PROMPT_TEMPLATE = `TITLE: Tiêu đề bài viết hấp dẫn và SEO-friendly (tối đa 200 ký tự)

DESCRIPTION: Nội dung bài viết chi tiết, ít nhất 500 từ.
CẤU TRÚC BÀI VIẾT:
- Giới thiệu
- Các điểm chính
- Kết luận

TAGS: 5-8 từ khóa liên quan, cách nhau bằng dấu phẩy, không có dấu ngoặc

SEO_KEYWORD: URL slug thân thiện SEO (ví dụ: tin-tuc-cong-nghe-moi-nhat), lowercase, a-z, 0-9, hyphens only, tối đa 100 ký tự

META_TITLE: Tiêu đề SEO tối ưu, dài 50-60 ký tự, tự nhiên, không trùng 100% với TITLE

META_DESCRIPTION: Mô tả SEO hấp dẫn 120-150 ký tự, tự nhiên

META_KEYWORDS: Từ khóa SEO, cách nhau bằng dấu phẩy, ĐÚNG chính tả, đầy đủ chữ

Yêu cầu:
- Nội dung đầy đủ, không bị cắt giữa chừng
- DESCRIPTION phải có cấu trúc <h3>Tiêu đề</h3><p>Nội dung</p> rõ ràng
- Mọi nội dung HTML phải hợp lệ
- Tất cả field phải có nội dung hoàn chỉnh
- Viết văn phong báo chí tự nhiên, đúng chính tả
- Tập trung cung cấp thông tin hữu ích, có thể đăng ngay lên website tin tức`;

  constructor(private readonly supabaseService: SupabaseService) {}

  /**
   * Convert JSONB prompt template to text format for AI
   */
  private convertPromptJsonbToText(promptJsonb: any): string {
    if (!promptJsonb || typeof promptJsonb === 'string') {
      // If it's already text or invalid, return default
      return this.DEFAULT_PROMPT_TEMPLATE;
    }

    // Build structured text prompt from JSONB
    let textPrompt = '';

    // TITLE section
    if (promptJsonb.title) {
      const title = promptJsonb.title;
      textPrompt += `TITLE: ${title.instruction || 'Tiêu đề bài viết hấp dẫn và SEO-friendly'}`;
      if (title.max_length) {
        textPrompt += ` (tối đa ${title.max_length} ký tự)`;
      }
      textPrompt += '\n\n';
    }

    // DESCRIPTION section
    if (promptJsonb.description) {
      const desc = promptJsonb.description;
      textPrompt += `DESCRIPTION: ${desc.instruction || 'Nội dung bài viết chi tiết'}`;
      if (desc.min_words) {
        textPrompt += `, ít nhất ${desc.min_words} từ`;
      }
      textPrompt += '.\n\n';

      if (desc.structure && Array.isArray(desc.structure)) {
        textPrompt += 'CẤU TRÚC BÀI VIẾT:\n';
        desc.structure.forEach((item: string) => {
          textPrompt += `- ${item}\n`;
        });
        textPrompt += '\n';
      }
    }

    // TAGS section
    if (promptJsonb.tags) {
      const tags = promptJsonb.tags;
      textPrompt += `TAGS: ${tags.quantity || '5-8'} từ khóa liên quan, cách nhau bằng dấu phẩy`;
      if (tags.no_quotes) {
        textPrompt += ', không có dấu ngoặc';
      }
      textPrompt += '\n\n';
    }

    // SEO_KEYWORD section
    if (promptJsonb.seo_keyword) {
      const seo = promptJsonb.seo_keyword;
      textPrompt += `SEO_KEYWORD: ${seo.instruction || 'URL slug thân thiện SEO'}`;
      if (seo.example) {
        textPrompt += ` (ví dụ: ${seo.example})`;
      }
      if (seo.format) {
        textPrompt += `, ${seo.format}`;
      }
      if (seo.max_length) {
        textPrompt += `, tối đa ${seo.max_length} ký tự`;
      }
      textPrompt += '\n\n';
    }

    // META_TITLE section
    if (promptJsonb.meta_title) {
      const meta = promptJsonb.meta_title;
      textPrompt += `META_TITLE: ${meta.instruction || 'Tiêu đề SEO tối ưu'}`;
      if (meta.length) {
        textPrompt += `, dài ${meta.length}`;
      }
      if (meta.natural) {
        textPrompt += ', tự nhiên';
      }
      if (meta.no_duplicate_with_title) {
        textPrompt += ', không trùng 100% với TITLE';
      }
      textPrompt += '\n\n';
    }

    // META_DESCRIPTION section
    if (promptJsonb.meta_description) {
      const metaDesc = promptJsonb.meta_description;
      textPrompt += `META_DESCRIPTION: ${metaDesc.instruction || 'Mô tả SEO hấp dẫn'}`;
      if (metaDesc.length) {
        textPrompt += ` ${metaDesc.length}`;
      }
      if (metaDesc.natural) {
        textPrompt += ', tự nhiên';
      }
      textPrompt += '\n\n';
    }

    // META_KEYWORDS section
    if (promptJsonb.meta_keywords) {
      const metaKeys = promptJsonb.meta_keywords;
      textPrompt += `META_KEYWORDS: ${metaKeys.instruction || 'Từ khóa SEO'}, cách nhau bằng dấu phẩy`;
      if (metaKeys.correct_spelling) {
        textPrompt += ', ĐÚNG chính tả';
      }
      if (metaKeys.complete_words) {
        textPrompt += ', đầy đủ chữ';
      }
      textPrompt += '\n\n';
    }

    // Add general requirements
    textPrompt += 'Yêu cầu:\n';
    textPrompt += '- Nội dung đầy đủ, không bị cắt giữa chừng\n';
    textPrompt += '- DESCRIPTION phải có cấu trúc <h3>Tiêu đề</h3><p>Nội dung</p> rõ ràng\n';
    textPrompt += '- Mọi nội dung HTML phải hợp lệ\n';
    textPrompt += '- Tất cả field phải có nội dung hoàn chỉnh\n';
    textPrompt += '- Viết văn phong báo chí tự nhiên, đúng chính tả\n';
    textPrompt += '- Tập trung cung cấp thông tin hữu ích, có thể đăng ngay lên website tin tức';

    return textPrompt;
  }

  /**
   * Get all articles with pagination
   */
  async findAll(query: PaginationQueryDto) {
    const { page = 1, limit = 20, search, status, sort = 'created_at', order = 'desc' } = query;
    const offset = (page - 1) * limit;

    const supabase = this.supabaseService.getClient();
    let queryBuilder = supabase
      .from('articles')
      .select('*, author:profiles!articles_author_id_fkey(id, full_name, avatar_url)', { count: 'exact' });

    // Apply filters
    if (search) {
      queryBuilder = queryBuilder.or(`title.ilike.%${search}%,body.ilike.%${search}%`);
    }

    if (status) {
      queryBuilder = queryBuilder.eq('status', status);
    }

    // Apply sorting
    queryBuilder = queryBuilder.order(sort, { ascending: order === 'asc' });

    // Apply pagination
    queryBuilder = queryBuilder.range(offset, offset + limit - 1);

    const { data, error, count } = await queryBuilder;

    if (error) {
      throw new BadRequestException(`Lỗi khi lấy danh sách bài viết: ${error.message}`);
    }

    return {
      data,
      meta: {
        total: count || 0,
        page,
        limit,
        totalPages: Math.ceil((count || 0) / limit),
      },
    };
  }

  /**
   * Get a single article by ID
   */
  async findOne(id: string) {
    const supabase = this.supabaseService.getClient();

    const { data, error } = await supabase
      .from('articles')
      .select('*, author:profiles!articles_author_id_fkey(id, full_name, avatar_url)')
      .eq('id', id)
      .single();

    if (error) {
      throw new NotFoundException(`Không tìm thấy bài viết với ID: ${id}`);
    }

    return data;
  }

  /**
   * Get a single article by slug
   */
  async findBySlug(slug: string) {
    const supabase = this.supabaseService.getClient();

    const { data, error } = await supabase
      .from('articles')
      .select('*, author:profiles!articles_author_id_fkey(id, full_name, avatar_url)')
      .eq('slug', slug)
      .single();

    if (error) {
      throw new NotFoundException(`Không tìm thấy bài viết với slug: ${slug}`);
    }

    // Increment view count
    await supabase
      .from('articles')
      .update({ view_count: (data.view_count || 0) + 1 })
      .eq('id', data.id);

    return data;
  }

  /**
   * Create a new article
   */
  async create(authorId: string, dto: CreateArticleDto) {
    const supabase = this.supabaseService.getClient();

    // Generate slug if not provided
    if (!dto.slug) {
      dto.slug = this.generateSlug(dto.title);
    }

    // Check slug uniqueness
    const { data: existing } = await supabase
      .from('articles')
      .select('id')
      .eq('slug', dto.slug)
      .single();

    if (existing) {
      dto.slug = `${dto.slug}-${Date.now()}`;
    }

    const articleData = {
      ...dto,
      author_id: authorId,
      published_at: dto.status === 'published' ? new Date().toISOString() : null,
    };

    const { data, error } = await supabase
      .from('articles')
      .insert(articleData)
      .select('*, author:profiles!articles_author_id_fkey(id, full_name, avatar_url)')
      .single();

    if (error) {
      throw new BadRequestException(`Lỗi khi tạo bài viết: ${error.message}`);
    }

    return data;
  }

  /**
   * Update an article
   */
  async update(id: string, dto: UpdateArticleDto) {
    const supabase = this.supabaseService.getClient();

    // Check article exists
    const { data: existing, error: findError } = await supabase
      .from('articles')
      .select('id, status')
      .eq('id', id)
      .single();

    if (findError || !existing) {
      throw new NotFoundException(`Không tìm thấy bài viết với ID: ${id}`);
    }

    // Set published_at when status changes to published
    const updateData: Record<string, unknown> = { ...dto, updated_at: new Date().toISOString() };
    if (dto.status === 'published' && existing.status !== 'published') {
      updateData.published_at = new Date().toISOString();
    }

    const { data, error } = await supabase
      .from('articles')
      .update(updateData)
      .eq('id', id)
      .select('*, author:profiles!articles_author_id_fkey(id, full_name, avatar_url)')
      .single();

    if (error) {
      throw new BadRequestException(`Lỗi khi cập nhật bài viết: ${error.message}`);
    }

    return data;
  }

  /**
   * Delete an article
   */
  async delete(id: string) {
    const supabase = this.supabaseService.getClient();

    const { error } = await supabase.from('articles').delete().eq('id', id);

    if (error) {
      throw new BadRequestException(`Lỗi khi xóa bài viết: ${error.message}`);
    }

    return { message: 'Xóa bài viết thành công' };
  }

  // ============================================================================
  // AI Content Generation (OpenRouter)
  // ============================================================================

  /**
   * Generate article content using OpenRouter AI API
   */
  async generateContent(userId: string, dto: GenerateArticleDto): Promise<any> {
    const supabase = this.supabaseService.getClient();

    // Rate limiting check
    const rateLimitKey = userId;
    this.checkRateLimit(rateLimitKey);

    // Validate and sanitize keyword
    const keyword = this.sanitizeKeyword(dto.keyword);
    if (!keyword || keyword.length > 200) {
      throw new BadRequestException('Từ khóa không hợp lệ hoặc quá dài (tối đa 200 ký tự)');
    }

    // Get AI settings from api_settings table
    const { data: apiSettings, error: settingsError } = await supabase
      .from('api_settings')
      .select('*')
      .eq('name', 'article')
      .single();

    if (settingsError || !apiSettings) {
      throw new BadRequestException('Cài đặt API chưa được cấu hình. Vui lòng thiết lập trong phần Cài đặt > API.');
    }

    // Get OpenRouter API key from admin_settings or environment
    const apiKey = await this.getOpenRouterApiKey(supabase);
    if (!apiKey) {
      throw new BadRequestException('OpenRouter API key chưa được cấu hình. Vui lòng thiết lập trong phần Cài đặt > API Keys.');
    }

    // Build the full prompt
    // If customPrompt is provided as JSONB object, use it; otherwise convert from db
    let promptTemplate: string;
    
    if (dto.customPrompt) {
      // Custom prompt can be either JSONB object or text string
      if (typeof dto.customPrompt === 'object') {
        promptTemplate = this.convertPromptJsonbToText(dto.customPrompt);
      } else {
        promptTemplate = dto.customPrompt;
      }
    } else {
      // Use default from database (convert JSONB to text)
      promptTemplate = this.convertPromptJsonbToText(apiSettings.default_prompt);
    }

    const fullPrompt = HARD_PROMPT_PREFIX.replace('{keyword}', keyword) + promptTemplate;

    // Build topic context if provided
    const topicContext = dto.topic ? `\n\nChủ đề liên quan: ${dto.topic}` : '';
    const finalPrompt = fullPrompt + topicContext;

    const apiEndpoint = apiSettings.api_endpoint || DEFAULT_OPENROUTER_ENDPOINT;
    const modelName = apiSettings.model_name || DEFAULT_MODEL_NAME;

    try {
      // Call OpenRouter API
      const response = await fetch(apiEndpoint, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${apiKey}`,
          'HTTP-Referer': process.env.OPENROUTER_SITE_URL || 'http://localhost:3000',
          'X-Title': process.env.OPENROUTER_APP_NAME || 'ShopIn CMS',
        },
        body: JSON.stringify({
          model: modelName,
          messages: [
            {
              role: 'system',
              content: 'Bạn là một nhà báo và content writer chuyên nghiệp người Việt Nam. Bạn viết bài viết tin tức chất lượng cao, tối ưu SEO, với văn phong tự nhiên và chính xác.',
            },
            {
              role: 'user',
              content: finalPrompt,
            },
          ],
          temperature: 0.7,
          max_tokens: 3000,
        }),
      });

      // Handle API errors
      if (!response.ok) {
        const errorBody = await response.text();
        let errorMessage = 'OpenRouter API request failed';
        
        try {
          const errorJson = JSON.parse(errorBody);
          errorMessage = errorJson.error?.message || errorJson.message || errorMessage;
        } catch {
          errorMessage = errorBody.substring(0, 200) || errorMessage;
        }

        if (response.status === 401) {
          throw new BadRequestException('API key không hợp lệ. Vui lòng kiểm tra lại cấu hình.');
        } else if (response.status === 429) {
          throw new ForbiddenException('Đã vượt quá giới hạn API. Vui lòng thử lại sau.');
        } else if (response.status >= 500) {
          throw new BadRequestException('OpenRouter API tạm thời không khả dụng. Vui lòng thử lại sau.');
        }
        
        throw new BadRequestException(`Lỗi từ OpenRouter: ${errorMessage}`);
      }

      const result = await response.json();
      const content = result.choices?.[0]?.message?.content || '';

      if (!content) {
        throw new BadRequestException('AI không trả về nội dung. Vui lòng thử lại.');
      }

      // Parse the AI response
      const parsed = this.parseAIResponse(content);

      // Validate the parsed content
      const validation = this.validateParsedContent(parsed);
      if (!validation.valid && validation.errors.length > 0) {
        console.error('AI response validation failed:', validation.errors);
        throw new BadRequestException(
          `Nội dung AI không đạt yêu cầu: ${validation.errors.join(', ')}. Vui lòng thử lại.`
        );
      }

      // Log usage for monitoring
      await this.logAIUsage(supabase, {
        userId,
        keyword,
        modelName,
        usage: result.usage,
        success: true,
      });

      // Increment rate limit counter
      this.incrementRateLimit(rateLimitKey);

      return {
        success: true,
        data: parsed,
        warnings: validation.warnings,
      };
    } catch (error) {
      // Log failed usage
      await this.logAIUsage(supabase, {
        userId,
        keyword,
        modelName: apiSettings.model_name,
        success: false,
        errorMessage: error.message,
      });

      if (error instanceof BadRequestException || error instanceof ForbiddenException) {
        throw error;
      }
      throw new BadRequestException(`Lỗi khi tạo nội dung AI: ${error.message}`);
    }
  }

  // ============================================================================
  // Helper Methods
  // ============================================================================

  /**
   * Get OpenRouter API key from admin_settings or environment
   */
  private async getOpenRouterApiKey(supabase: ReturnType<SupabaseService['getClient']>): Promise<string> {
    const { data: adminSettings } = await supabase
      .from('admin_settings')
      .select('value')
      .eq('key', 'api_keys')
      .single();

    const dbKey = adminSettings?.value?.openrouter_key;
    if (dbKey && dbKey.trim()) {
      return dbKey.trim();
    }

    return process.env.OPENROUTER_API_KEY || '';
  }

  /**
   * Sanitize keyword input
   */
  private sanitizeKeyword(keyword: string): string {
    if (!keyword) return '';
    
    return keyword
      .replace(/<script[^>]*>.*?<\/script>/gi, '')
      .replace(/<[^>]+>/g, '')
      .replace(/[<>]/g, '')
      .trim();
  }

  /**
   * Parse AI response into structured content
   */
  parseAIResponse(content: string): ParsedArticleContent {
    const cleanText = (text: string): string => {
      return text
        .replace(/^\*\*\s*/g, '')
        .replace(/\s*\*\*$/g, '')
        .replace(/^#+\s*/g, '')
        .replace(/^\*\s*/g, '')
        .replace(/\*\*/g, '')
        .replace(/##/g, '')
        .trim();
    };

    const extractField = (pattern: RegExp, defaultValue = ''): string => {
      const match = content.match(pattern);
      return match ? cleanText(match[1]) : defaultValue;
    };

    // Patterns now handle both "followed by next field" and "end of string" cases
    const title = extractField(/TITLE:\s*(.+?)(?=\n(?:DESCRIPTION:|TAGS:|SEO_KEYWORD:|META_)|$)/s);
    const description = extractField(/DESCRIPTION:\s*(.+?)(?=\n(?:TAGS:|SEO_KEYWORD:|META_)|$)/s);
    const tags = extractField(/TAGS:\s*(.+?)(?=\n(?:SEO_KEYWORD:|META_)|$)/s);
    const seoKeyword = extractField(/SEO_KEYWORD:\s*(.+?)(?=\n(?:META_)|$)/s);
    const metaTitle = extractField(/META_TITLE:\s*(.+?)(?=\n(?:META_DESCRIPTION:|META_KEYWORDS:)|$)/s);
    const metaDescription = extractField(/META_DESCRIPTION:\s*(.+?)(?=\n(?:META_KEYWORDS:)|$)/s);
    const metaKeywords = extractField(/META_KEYWORDS:\s*(.+?)$/s);

    let slug = seoKeyword.toLowerCase();
    if (!slug && title) {
      slug = this.generateSeoUrl(title);
    }

    const tagsArray = tags
      .split(',')
      .map(t => t.trim())
      .filter(t => t.length > 0);

    return {
      title,
      body: description,
      slug,
      tags: tagsArray,
      meta: {
        meta_title: metaTitle || title.substring(0, 60),
        meta_description: metaDescription || description.substring(0, 150),
        seo_keywords: metaKeywords,
      },
    };
  }

  /**
   * Validate parsed AI content
   */
  validateParsedContent(parsed: ParsedArticleContent): ValidationResult {
    const errors: string[] = [];
    const warnings: string[] = [];

    if (!parsed.title || parsed.title.length === 0) {
      errors.push('Thiếu tiêu đề bài viết');
    }
    if (!parsed.body || parsed.body.length < 100) {
      errors.push('Nội dung bài viết quá ngắn hoặc thiếu');
    }

    if (parsed.title && parsed.title.length > 200) {
      warnings.push('Tiêu đề dài hơn 200 ký tự');
    }

    if (parsed.body) {
      const wordCount = parsed.body.split(/\s+/).length;
      if (wordCount < 300) {
        warnings.push(`Nội dung có ${wordCount} từ (khuyến nghị >= 500)`);
      }

      if (parsed.body.includes('**') || parsed.body.includes('##')) {
        warnings.push('Nội dung còn chứa ký tự markdown');
      }

      if (!parsed.body.includes('<h3>') || !parsed.body.includes('<p>')) {
        warnings.push('Nội dung thiếu cấu trúc HTML (h3, p)');
      }
    }

    if (parsed.tags.length < 3) {
      warnings.push('Ít hơn 3 tags');
    } else if (parsed.tags.length > 10) {
      warnings.push('Nhiều hơn 10 tags');
    }

    if (parsed.slug && !/^[a-z0-9-]+$/.test(parsed.slug)) {
      warnings.push('Slug chứa ký tự không hợp lệ');
    }
    if (parsed.slug && parsed.slug.length > 100) {
      warnings.push('Slug dài hơn 100 ký tự');
    }

    if (parsed.meta.meta_title && (parsed.meta.meta_title.length < 30 || parsed.meta.meta_title.length > 70)) {
      warnings.push('Meta title không tối ưu (khuyến nghị 50-60 ký tự)');
    }

    if (parsed.meta.meta_description && (parsed.meta.meta_description.length < 100 || parsed.meta.meta_description.length > 160)) {
      warnings.push('Meta description không tối ưu (khuyến nghị 120-150 ký tự)');
    }

    return {
      valid: errors.length === 0,
      warnings,
      errors,
    };
  }

  /**
   * Generate SEO-friendly URL slug
   */
  generateSeoUrl(text: string): string {
    return text
      .toLowerCase()
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '')
      .replace(/đ/g, 'd')
      .replace(/Đ/g, 'd')
      .replace(/[^a-z0-9\s-]/g, '')
      .replace(/\s+/g, '-')
      .replace(/-+/g, '-')
      .replace(/^-|-$/g, '')
      .substring(0, 100);
  }

  // ============================================================================
  // Rate Limiting
  // ============================================================================

  /**
   * Check if user has exceeded rate limit
   */
  private checkRateLimit(key: string): void {
    const now = Date.now();
    const entry = this.rateLimitMap.get(key);

    if (entry) {
      if (now > entry.resetAt) {
        this.rateLimitMap.delete(key);
        return;
      }

      if (entry.count >= RATE_LIMIT_MAX_REQUESTS) {
        const minutesRemaining = Math.ceil((entry.resetAt - now) / 60000);
        throw new ForbiddenException(
          `Đã vượt quá giới hạn ${RATE_LIMIT_MAX_REQUESTS} lần tạo bài viết/giờ. Vui lòng thử lại sau ${minutesRemaining} phút.`
        );
      }
    }
  }

  /**
   * Increment rate limit counter
   */
  private incrementRateLimit(key: string): void {
    const now = Date.now();
    const entry = this.rateLimitMap.get(key);

    if (entry && now <= entry.resetAt) {
      entry.count++;
    } else {
      this.rateLimitMap.set(key, {
        count: 1,
        resetAt: now + RATE_LIMIT_WINDOW_MS,
      });
    }
  }

  // ============================================================================
  // Usage Logging
  // ============================================================================

  /**
   * Log AI usage for monitoring and cost tracking
   */
  private async logAIUsage(
    supabase: ReturnType<SupabaseService['getClient']>,
    data: {
      userId?: string;
      keyword: string;
      modelName: string;
      usage?: { prompt_tokens?: number; completion_tokens?: number; total_tokens?: number };
      success: boolean;
      errorMessage?: string;
    }
  ): Promise<void> {
    try {
      const promptTokens = data.usage?.prompt_tokens || 0;
      const completionTokens = data.usage?.completion_tokens || 0;
      const totalTokens = data.usage?.total_tokens || promptTokens + completionTokens;

      const estimatedCost = totalTokens * 0.000001;

      await supabase.from('ai_usage_logs').insert({
        user_id: data.userId || null,
        feature: 'article_generation',
        keyword: data.keyword.substring(0, 200),
        model_name: data.modelName,
        tokens_used: totalTokens,
        prompt_tokens: promptTokens,
        completion_tokens: completionTokens,
        estimated_cost: estimatedCost,
        success: data.success,
        error_message: data.errorMessage?.substring(0, 500) || null,
      });
    } catch (error) {
      console.error('Failed to log AI usage:', error);
    }
  }

  // ============================================================================
  // Image Upload
  // ============================================================================

  /**
   * Upload article image
   */
  async uploadImage(file: Express.Multer.File) {
    const supabase = this.supabaseService.getClient();
    
    const fileName = `article_images/${Date.now()}-${file.originalname}`;
    
    const { data, error } = await supabase.storage
      .from('shopin_storage')
      .upload(fileName, file.buffer, {
        contentType: file.mimetype,
        upsert: false,
      });

    if (error) {
      throw new BadRequestException(`Lỗi khi upload hình ảnh: ${error.message}`);
    }

    const { data: urlData } = supabase.storage
      .from('shopin_storage')
      .getPublicUrl(data.path);

    return { url: urlData.publicUrl };
  }

  /**
   * Generate slug from title
   */
  private generateSlug(title: string): string {
    return this.generateSeoUrl(title);
  }
}
