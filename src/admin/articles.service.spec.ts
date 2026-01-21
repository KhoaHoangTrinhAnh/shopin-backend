import { ArticlesService, ParsedArticleContent, ValidationResult } from './articles.service';

describe('ArticlesService - AI Response Parsing', () => {
  let service: ArticlesService;

  beforeEach(() => {
    // Create service with null supabaseService (we're only testing parsing)
    service = new ArticlesService(null as any);
  });

  describe('parseAIResponse', () => {
    it('should parse a well-formatted AI response', () => {
      const aiResponse = `TITLE: Ổi - Vua Vitamin C: Lợi Ích Tuyệt Vời Cho Sức Khỏe

DESCRIPTION: <h3>Giới thiệu về ổi</h3>
<p>Ổi là loại trái cây nhiệt đới được yêu thích bởi hương vị thơm ngon và giá trị dinh dưỡng cao.</p>
<h3>Hàm lượng vitamin C trong ổi</h3>
<p>Theo nghiên cứu, ổi chứa lượng vitamin C cao gấp 4 lần cam.</p>
<h3>Lợi ích sức khỏe</h3>
<p>Vitamin C trong ổi giúp tăng cường hệ miễn dịch và làm đẹp da.</p>

TAGS: ổi, vitamin C, trái cây, sức khỏe, dinh dưỡng, miễn dịch

SEO_KEYWORD: oi-vua-vitamin-c-loi-ich-tuyet-voi-cho-suc-khoe

META_TITLE: Ổi - Trái Cây Giàu Vitamin C Nhất | Lợi Ích Sức Khỏe

META_DESCRIPTION: Khám phá lợi ích tuyệt vời của ổi - loại trái cây có hàm lượng vitamin C cao nhất. Tìm hiểu cách ổi giúp tăng cường miễn dịch.

META_KEYWORDS: ổi, vitamin c, trái cây nhiệt đới, sức khỏe, dinh dưỡng`;

      const result = service.parseAIResponse(aiResponse);

      expect(result.title).toBe('Ổi - Vua Vitamin C: Lợi Ích Tuyệt Vời Cho Sức Khỏe');
      expect(result.body).toContain('<h3>Giới thiệu về ổi</h3>');
      expect(result.body).toContain('<p>');
      expect(result.slug).toBe('oi-vua-vitamin-c-loi-ich-tuyet-voi-cho-suc-khoe');
      expect(result.tags).toContain('ổi');
      expect(result.tags).toContain('vitamin C');
      expect(result.tags.length).toBeGreaterThanOrEqual(5);
      expect(result.meta.meta_title).toBe('Ổi - Trái Cây Giàu Vitamin C Nhất | Lợi Ích Sức Khỏe');
      expect(result.meta.meta_description).toContain('Khám phá lợi ích tuyệt vời');
      expect(result.meta.seo_keywords).toContain('vitamin c');
    });

    it('should handle missing fields with fallbacks', () => {
      const aiResponse = `TITLE: Test Article Title

DESCRIPTION: This is a test description with some content.

TAGS: tag1, tag2, tag3`;

      const result = service.parseAIResponse(aiResponse);

      expect(result.title).toBe('Test Article Title');
      expect(result.body).toBe('This is a test description with some content.');
      expect(result.tags).toEqual(['tag1', 'tag2', 'tag3']);
      // Slug should be generated from title
      expect(result.slug).toBe('test-article-title');
      // Meta fields should have fallbacks
      expect(result.meta.meta_title).toBe('Test Article Title'); // Fallback from title
    });

    it('should clean markdown formatting from response', () => {
      const aiResponse = `TITLE: **Bold Title** With ## Markdown

DESCRIPTION: **Bold text** and ## headers should be cleaned

TAGS: tag1, tag2

SEO_KEYWORD: test-slug

META_TITLE: Clean Title

META_DESCRIPTION: Clean description

META_KEYWORDS: keywords`;

      const result = service.parseAIResponse(aiResponse);

      expect(result.title).not.toContain('**');
      expect(result.title).not.toContain('##');
      expect(result.body).not.toContain('**');
    });

    it('should generate slug from title when SEO_KEYWORD is missing', () => {
      const aiResponse = `TITLE: Đây Là Tiêu Đề Tiếng Việt

DESCRIPTION: Nội dung bài viết

TAGS: tag1, tag2`;

      const result = service.parseAIResponse(aiResponse);

      expect(result.slug).toBe('day-la-tieu-de-tieng-viet');
    });

    it('should handle empty response gracefully', () => {
      const result = service.parseAIResponse('');

      expect(result.title).toBe('');
      expect(result.body).toBe('');
      expect(result.slug).toBe('');
      expect(result.tags).toEqual([]);
    });
  });

  describe('validateParsedContent', () => {
    it('should validate valid content without errors', () => {
      const validContent: ParsedArticleContent = {
        title: 'Valid Title for the Article',
        body: '<h3>Section 1</h3><p>This is a detailed description with enough content. '.repeat(20) + '</p>',
        slug: 'valid-title-for-the-article',
        tags: ['tag1', 'tag2', 'tag3', 'tag4', 'tag5'],
        meta: {
          meta_title: 'Valid Meta Title for SEO Optimization Here',
          meta_description: 'This is a valid meta description that is between 120 and 150 characters for good SEO optimization results.',
          seo_keywords: 'keyword1, keyword2, keyword3',
        },
      };

      const result = service.validateParsedContent(validContent);

      expect(result.valid).toBe(true);
      expect(result.errors).toHaveLength(0);
    });

    it('should return error for missing title', () => {
      const content: ParsedArticleContent = {
        title: '',
        body: 'Some content here',
        slug: 'test-slug',
        tags: ['tag1', 'tag2', 'tag3'],
        meta: {
          meta_title: 'Meta Title',
          meta_description: 'Meta description',
          seo_keywords: 'keywords',
        },
      };

      const result = service.validateParsedContent(content);

      expect(result.valid).toBe(false);
      expect(result.errors).toContain('Thiếu tiêu đề bài viết');
    });

    it('should return error for content too short', () => {
      const content: ParsedArticleContent = {
        title: 'Valid Title',
        body: 'Too short',
        slug: 'test-slug',
        tags: ['tag1', 'tag2', 'tag3'],
        meta: {
          meta_title: 'Meta Title',
          meta_description: 'Meta description',
          seo_keywords: 'keywords',
        },
      };

      const result = service.validateParsedContent(content);

      expect(result.valid).toBe(false);
      expect(result.errors).toContain('Nội dung bài viết quá ngắn hoặc thiếu');
    });

    it('should return warning for title too long', () => {
      const content: ParsedArticleContent = {
        title: 'A'.repeat(250),
        body: 'Valid content '.repeat(50),
        slug: 'test-slug',
        tags: ['tag1', 'tag2', 'tag3', 'tag4', 'tag5'],
        meta: {
          meta_title: 'Meta Title Here for SEO Optimization',
          meta_description: 'Valid meta description that is between 120 and 150 characters for good SEO results.',
          seo_keywords: 'keywords',
        },
      };

      const result = service.validateParsedContent(content);

      expect(result.valid).toBe(true); // Warnings don't make it invalid
      expect(result.warnings).toContain('Tiêu đề dài hơn 200 ký tự');
    });

    it('should return warning for markdown remnants in body', () => {
      const content: ParsedArticleContent = {
        title: 'Valid Title',
        body: 'Content with **bold** and ## heading '.repeat(20),
        slug: 'test-slug',
        tags: ['tag1', 'tag2', 'tag3', 'tag4', 'tag5'],
        meta: {
          meta_title: 'Meta Title for SEO Optimization Here',
          meta_description: 'Valid meta description that is long enough for proper SEO optimization results here.',
          seo_keywords: 'keywords',
        },
      };

      const result = service.validateParsedContent(content);

      expect(result.warnings).toContain('Nội dung còn chứa ký tự markdown');
    });

    it('should return warning for missing HTML structure', () => {
      const content: ParsedArticleContent = {
        title: 'Valid Title',
        body: 'Plain text content without any HTML tags. '.repeat(30),
        slug: 'test-slug',
        tags: ['tag1', 'tag2', 'tag3', 'tag4', 'tag5'],
        meta: {
          meta_title: 'Meta Title for SEO Optimization Here',
          meta_description: 'Valid meta description that is long enough for proper SEO optimization results here.',
          seo_keywords: 'keywords',
        },
      };

      const result = service.validateParsedContent(content);

      expect(result.warnings).toContain('Nội dung thiếu cấu trúc HTML (h3, p)');
    });

    it('should return warning for too few tags', () => {
      const content: ParsedArticleContent = {
        title: 'Valid Title',
        body: '<h3>Test</h3><p>Valid content '.repeat(30) + '</p>',
        slug: 'test-slug',
        tags: ['tag1', 'tag2'],
        meta: {
          meta_title: 'Meta Title for SEO Optimization Here',
          meta_description: 'Valid meta description that is long enough for proper SEO optimization results here.',
          seo_keywords: 'keywords',
        },
      };

      const result = service.validateParsedContent(content);

      expect(result.warnings).toContain('Ít hơn 3 tags');
    });

    it('should return warning for invalid slug characters', () => {
      const content: ParsedArticleContent = {
        title: 'Valid Title',
        body: '<h3>Test</h3><p>Valid content '.repeat(30) + '</p>',
        slug: 'invalid_slug_with_underscore',
        tags: ['tag1', 'tag2', 'tag3', 'tag4', 'tag5'],
        meta: {
          meta_title: 'Meta Title for SEO Optimization Here',
          meta_description: 'Valid meta description that is long enough for proper SEO optimization results here.',
          seo_keywords: 'keywords',
        },
      };

      const result = service.validateParsedContent(content);

      expect(result.warnings).toContain('Slug chứa ký tự không hợp lệ');
    });
  });

  describe('generateSeoUrl', () => {
    it('should convert Vietnamese text to URL-safe slug', () => {
      expect(service.generateSeoUrl('Đây là tiêu đề tiếng Việt')).toBe('day-la-tieu-de-tieng-viet');
    });

    it('should handle special characters', () => {
      expect(service.generateSeoUrl('Hello! World?')).toBe('hello-world');
    });

    it('should handle multiple spaces and hyphens', () => {
      expect(service.generateSeoUrl('Hello   World---Test')).toBe('hello-world-test');
    });

    it('should truncate to 100 characters', () => {
      const longText = 'A'.repeat(150);
      expect(service.generateSeoUrl(longText).length).toBeLessThanOrEqual(100);
    });

    it('should handle đ and Đ characters', () => {
      expect(service.generateSeoUrl('Đồng Đức')).toBe('dong-duc');
    });
  });

  describe('convertPromptJsonbToText', () => {
    it('should convert a full JSONB prompt to text correctly', () => {
      const fullJsonb = {
        title: { instruction: 'A captivating and SEO-friendly article title', max_length: 100, format: 'natural' },
        description: {
          instruction: 'Detailed article content',
          min_words: 800,
          structure: ['Introduction', 'Main points', 'Conclusion'],
          no_markdown: false,
        },
        tags: { instruction: 'Relevant keywords', quantity: '5-8', separator: ',', no_quotes: true },
        seo_keyword: { instruction: 'SEO-friendly URL slug', format: 'lowercase, hyphens', max_length: 80, example: 'my-awesome-article', no_diacritics: true },
        meta_title: { instruction: 'Optimized meta title for search engines', length: '50-60 characters', no_duplicate_with_title: true, natural: true },
        meta_description: { instruction: 'Compelling meta description', length: '120-150 characters', natural: true },
        meta_keywords: { instruction: 'SEO keywords', separator: ',', correct_spelling: true, complete_words: true },
      };
      const expectedText = [
        'TITLE: A captivating and SEO-friendly article title (tối đa 100 ký tự)\n\n',
        'DESCRIPTION: Detailed article content, ít nhất 800 từ.\n\n',
        'CẤU TRÚC BÀI VIẾT:\n',
        '- Introduction\n',
        '- Main points\n',
        '- Conclusion\n\n',
        'TAGS: 5-8 từ khóa liên quan, cách nhau bằng dấu phẩy, không có dấu ngoặc\n\n',
        'SEO_KEYWORD: SEO-friendly URL slug (ví dụ: my-awesome-article), lowercase, hyphens, tối đa 80 ký tự\n\n',
        'META_TITLE: Optimized meta title for search engines, dài 50-60 characters, tự nhiên, không trùng 100% với TITLE\n\n',
        'META_DESCRIPTION: Compelling meta description 120-150 characters, tự nhiên\n\n',
        'META_KEYWORDS: SEO keywords, cách nhau bằng dấu phẩy, ĐÚNG chính tả, đầy đủ chữ\n\n',
        'Yêu cầu:\n',
        '- Nội dung đầy đủ, không bị cắt giữa chừng\n',
        '- DESCRIPTION phải có cấu trúc <h3>Tiêu đề</h3><p>Nội dung</p> rõ ràng\n',
        '- Mọi nội dung HTML phải hợp lệ\n',
        '- Tất cả field phải có nội dung hoàn chỉnh\n',
        '- Viết văn phong báo chí tự nhiên, đúng chính tả\n',
        '- Tập trung cung cấp thông tin hữu ích, có thể đăng ngay lên website tin tức',
      ].join('');

      // Access the private method using bracket notation for testing
      const result = (service as any).convertPromptJsonbToText(fullJsonb);
      expect(result).toBe(expectedText);
    });

    it('should merge with default values for partial JSONB prompt', () => {
      const partialJsonb = {
        title: { instruction: 'Partial Title Instruction' },
        description: { structure: ['Only this point'] },
      };

      // Access the private method using bracket notation for testing
      const result = (service as any).convertPromptJsonbToText(partialJsonb);
      
      // Partial JSONB only has title and description.structure, so output should only contain those
      // plus the default "Yêu cầu" section at the end
      expect(result).toContain('TITLE: Partial Title Instruction');
      expect(result).toContain('CẤU TRÚC BÀI VIẾT:');
      expect(result).toContain('- Only this point');
      expect(result).toContain('Yêu cầu:');
      
      // Should NOT contain other sections since they weren't in the partial JSONB
      expect(result).not.toContain('TAGS:');
      expect(result).not.toContain('SEO_KEYWORD:');
      expect(result).not.toContain('META_TITLE:');
    });

    it('should return the default template if the input is a string', () => {
      const stringInput = 'This is a legacy string prompt.';
      // The actual DEFAULT_PROMPT_TEMPLATE is used by the service internally
      // We can assert against a known part of the default template.
      const result = (service as any).convertPromptJsonbToText(stringInput);
      expect(result).toContain('Yêu cầu:');
      expect(result).toContain('DESCRIPTION phải có cấu trúc <h3>Tiêu đề</h3><p>Nội dung</p> rõ ràng');
    });

    it('should return the default template if the input is null or undefined', () => {
      const resultNull = (service as any).convertPromptJsonbToText(null);
      const resultUndefined = (service as any).convertPromptJsonbToText(undefined);

      expect(resultNull).toContain('Yêu cầu:');
      expect(resultUndefined).toContain('Yêu cầu:');
    });
  });
});
