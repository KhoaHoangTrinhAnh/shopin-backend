import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  Query,
  UseGuards,
  UseInterceptors,
  UploadedFile,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';
import { AdminGuard } from './guards/admin.guard';
import { Profile } from '../decorators/profile.decorator';
import { ArticlesService } from './articles.service';
import {
  CreateArticleDto,
  UpdateArticleDto,
  GenerateArticleDto,
  PaginationQueryDto,
} from './dto/admin.dto';

@Controller('admin/articles')
@UseGuards(JwtAuthGuard, AdminGuard)
export class ArticlesController {
  constructor(private readonly articlesService: ArticlesService) {}

  /**
   * Get all articles with pagination
   */
  @Get()
  async findAll(@Query() query: PaginationQueryDto) {
    return this.articlesService.findAll(query);
  }

  /**
   * Get a single article by ID
   */
  @Get(':id')
  async findOne(@Param('id') id: string) {
    return this.articlesService.findOne(id);
  }

  /**
   * Create a new article
   */
  @Post()
  async create(@Profile() profile: { id: string }, @Body() dto: CreateArticleDto) {
    return this.articlesService.create(profile.id, dto);
  }

  /**
   * Update an article
   */
  @Put(':id')
  async update(@Param('id') id: string, @Body() dto: UpdateArticleDto) {
    return this.articlesService.update(id, dto);
  }

  /**
   * Delete an article
   */
  @Delete(':id')
  async delete(@Param('id') id: string) {
    return this.articlesService.delete(id);
  }

  /**
   * Generate article content using AI
   */
  @Post('generate')
  async generateContent(@Body() dto: GenerateArticleDto) {
    return this.articlesService.generateContent(dto);
  }

  /**
   * Upload article image
   */
  @Post('upload-image')
  @UseInterceptors(FileInterceptor('file'))
  async uploadImage(@UploadedFile() file: Express.Multer.File) {
    return this.articlesService.uploadImage(file);
  }
}

// ============================================================================
// PUBLIC ARTICLES CONTROLLER (for blog pages)
// ============================================================================

@Controller('articles')
export class PublicArticlesController {
  constructor(private readonly articlesService: ArticlesService) {}

  /**
   * Get all published articles with pagination
   */
  @Get()
  async findAll(@Query() query: PaginationQueryDto) {
    return this.articlesService.findAll({ ...query, status: 'published' });
  }

  /**
   * Get a single article by slug
   */
  @Get(':slug')
  async findBySlug(@Param('slug') slug: string) {
    return this.articlesService.findBySlug(slug);
  }
}
