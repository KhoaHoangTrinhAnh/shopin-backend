import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { SupabaseService } from '../supabase/supabase.service';
import { CreateArticleDto, UpdateArticleDto, GenerateArticleDto, PaginationQueryDto } from './dto/admin.dto';

@Injectable()
export class ArticlesService {
  constructor(private readonly supabaseService: SupabaseService) {}

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
      queryBuilder = queryBuilder.or(`title.ilike.%${search}%,excerpt.ilike.%${search}%`);
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

  /**
   * Generate article content using AI
   */
  async generateContent(dto: GenerateArticleDto) {
    const supabase = this.supabaseService.getClient();

    // Get AI settings
    const { data: settings, error } = await supabase
      .from('admin_settings')
      .select('value')
      .eq('key', 'ai_content_generation')
      .single();

    if (error || !settings) {
      throw new BadRequestException('Chưa cấu hình AI settings');
    }

    const aiSettings = settings.value as {
      api_key: string;
      model: string;
      api_url: string;
      prompt: string;
    };

    if (!aiSettings.api_key) {
      throw new BadRequestException('Chưa cấu hình API Key cho AI');
    }

    // Prepare prompt with keyword
    const fullPrompt = `${aiSettings.prompt}\n\nDựa trên từ khóa: '${dto.keyword}'${dto.topic ? `\nChủ đề: ${dto.topic}` : ''}`;

    try {
      // Call OpenAI API
      const response = await fetch(aiSettings.api_url, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${aiSettings.api_key}`,
        },
        body: JSON.stringify({
          model: aiSettings.model,
          messages: [
            {
              role: 'system',
              content: 'Bạn là một chuyên gia viết content SEO. Hãy viết bài theo yêu cầu và trả về JSON với cấu trúc: { "title": "...", "excerpt": "...", "content_blocks": [...], "meta_title": "...", "meta_description": "...", "seo_keywords": "..." }',
            },
            {
              role: 'user',
              content: fullPrompt,
            },
          ],
          temperature: 0.7,
        }),
      });

      if (!response.ok) {
        throw new Error('AI API request failed');
      }

      const result = await response.json();
      const content = result.choices?.[0]?.message?.content;

      // Parse JSON from response
      let parsedContent;
      try {
        // Try to extract JSON from the response
        const jsonMatch = content.match(/\{[\s\S]*\}/);
        if (jsonMatch) {
          parsedContent = JSON.parse(jsonMatch[0]);
        } else {
          throw new Error('Invalid JSON response');
        }
      } catch {
        // Fallback: create content blocks from plain text
        parsedContent = {
          title: dto.keyword,
          excerpt: content.substring(0, 200),
          content_blocks: [
            { type: 'text', content: content, level: 'p' },
          ],
          meta_title: dto.keyword,
          meta_description: content.substring(0, 160),
          seo_keywords: dto.keyword,
        };
      }

      return parsedContent;
    } catch (error) {
      throw new BadRequestException(`Lỗi khi tạo nội dung AI: ${error.message}`);
    }
  }

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
    return title
      .toLowerCase()
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '') // Remove diacritics
      .replace(/đ/g, 'd')
      .replace(/Đ/g, 'D')
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-|-$/g, '');
  }
}
