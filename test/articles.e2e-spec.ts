import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../app.module';

describe('Articles API (e2e)', () => {
  let app: INestApplication;
  let authToken: string;
  let adminToken: string;
  let createdArticleId: string;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    app.useGlobalPipes(new ValidationPipe({ whitelist: true, transform: true }));
    await app.init();

    // Note: In a real test, you would authenticate and get real tokens
    // For this example, we'll mock the authentication
    // You should replace these with actual test user tokens
    authToken = 'mock-user-token';
    adminToken = 'mock-admin-token';
  });

  afterAll(async () => {
    await app.close();
  });

  describe('/admin/articles (GET)', () => {
    it('should return paginated articles list', () => {
      return request(app.getHttpServer())
        .get('/admin/articles')
        .set('Authorization', `Bearer ${adminToken}`)
        .query({ page: 1, limit: 10 })
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('data');
          expect(res.body).toHaveProperty('meta');
          expect(Array.isArray(res.body.data)).toBe(true);
          expect(res.body.meta).toHaveProperty('total');
          expect(res.body.meta).toHaveProperty('page');
          expect(res.body.meta).toHaveProperty('limit');
        });
    });

    it('should filter articles by status', () => {
      return request(app.getHttpServer())
        .get('/admin/articles')
        .set('Authorization', `Bearer ${adminToken}`)
        .query({ status: 'published' })
        .expect(200)
        .expect((res) => {
          const articles = res.body.data;
          if (articles.length > 0) {
            articles.forEach((article: any) => {
              expect(article.status).toBe('published');
            });
          }
        });
    });

    it('should search articles by title', () => {
      return request(app.getHttpServer())
        .get('/admin/articles')
        .set('Authorization', `Bearer ${adminToken}`)
        .query({ search: 'test' })
        .expect(200);
    });

    it('should reject unauthorized access', () => {
      return request(app.getHttpServer())
        .get('/admin/articles')
        .expect(401);
    });
  });

  describe('/admin/articles (POST)', () => {
    it('should create a draft article', async () => {
      const createDto = {
        title: 'Test Draft Article',
        slug: 'test-draft-article',
        excerpt: 'This is a test draft article',
        content_blocks: [
          { type: 'text', content: 'Test content', level: 'p' },
        ],
        status: 'draft',
      };

      const response = await request(app.getHttpServer())
        .post('/admin/articles')
        .set('Authorization', `Bearer ${adminToken}`)
        .send(createDto)
        .expect(201);

      expect(response.body).toHaveProperty('id');
      expect(response.body.title).toBe(createDto.title);
      expect(response.body.status).toBe('draft');
      expect(response.body).not.toHaveProperty('published_at');

      createdArticleId = response.body.id;
    });

    it('should create a published article with all required fields', async () => {
      const createDto = {
        title: 'Test Published Article',
        slug: 'test-published-article',
        excerpt: 'This is a test published article',
        featured_image: 'https://example.com/image.jpg',
        content_blocks: [
          { type: 'text', content: '<h3>Test</h3><p>Content</p>', level: 'p' },
        ],
        meta_title: 'Test Meta Title',
        meta_description: 'Test meta description for SEO',
        seo_keywords: 'test, article, seo',
        status: 'published',
      };

      const response = await request(app.getHttpServer())
        .post('/admin/articles')
        .set('Authorization', `Bearer ${adminToken}`)
        .send(createDto)
        .expect(201);

      expect(response.body).toHaveProperty('id');
      expect(response.body.status).toBe('published');
      expect(response.body).toHaveProperty('published_at');
      expect(response.body.published_at).not.toBeNull();
    });

    it('should reject published article without required fields', async () => {
      const createDto = {
        title: 'Incomplete Published Article',
        slug: 'incomplete-published',
        status: 'published',
        // Missing: excerpt, featured_image, meta_title, meta_description
      };

      return request(app.getHttpServer())
        .post('/admin/articles')
        .set('Authorization', `Bearer ${adminToken}`)
        .send(createDto)
        .expect(400);
    });

    it('should reject article with duplicate slug', async () => {
      const createDto = {
        title: 'Another Article',
        slug: 'test-draft-article', // Same slug as earlier test
        status: 'draft',
      };

      return request(app.getHttpServer())
        .post('/admin/articles')
        .set('Authorization', `Bearer ${adminToken}`)
        .send(createDto)
        .expect(400);
    });

    it('should validate title is required', async () => {
      const createDto = {
        slug: 'no-title-article',
        status: 'draft',
      };

      return request(app.getHttpServer())
        .post('/admin/articles')
        .set('Authorization', `Bearer ${adminToken}`)
        .send(createDto)
        .expect(400);
    });
  });

  describe('/admin/articles/:id (GET)', () => {
    it('should get a single article by ID', async () => {
      const response = await request(app.getHttpServer())
        .get(`/admin/articles/${createdArticleId}`)
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200);

      expect(response.body).toHaveProperty('id', createdArticleId);
      expect(response.body).toHaveProperty('title');
      expect(response.body).toHaveProperty('content_blocks');
    });

    it('should return 404 for non-existent article', () => {
      return request(app.getHttpServer())
        .get('/admin/articles/00000000-0000-0000-0000-000000000000')
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(404);
    });
  });

  describe('/admin/articles/:id (PUT)', () => {
    it('should update an article', async () => {
      const updateDto = {
        title: 'Updated Title',
        excerpt: 'Updated excerpt',
      };

      const response = await request(app.getHttpServer())
        .put(`/admin/articles/${createdArticleId}`)
        .set('Authorization', `Bearer ${adminToken}`)
        .send(updateDto)
        .expect(200);

      expect(response.body.title).toBe(updateDto.title);
      expect(response.body.excerpt).toBe(updateDto.excerpt);
      expect(response.body).toHaveProperty('updated_at');
    });

    it('should set published_at when changing to published status', async () => {
      const updateDto = {
        status: 'published',
        featured_image: 'https://example.com/image.jpg',
        excerpt: 'Published excerpt',
        meta_title: 'Published Meta',
        meta_description: 'Published Description',
      };

      const response = await request(app.getHttpServer())
        .put(`/admin/articles/${createdArticleId}`)
        .set('Authorization', `Bearer ${adminToken}`)
        .send(updateDto)
        .expect(200);

      expect(response.body.status).toBe('published');
      expect(response.body.published_at).not.toBeNull();
    });
  });

  describe('/admin/articles/generate (POST)', () => {
    it('should generate article content using AI', async () => {
      const generateDto = {
        keyword: 'iPhone 15 Pro Max',
        topic: 'Điện thoại',
      };

      const response = await request(app.getHttpServer())
        .post('/admin/articles/generate')
        .set('Authorization', `Bearer ${adminToken}`)
        .send(generateDto)
        .expect(201);

      expect(response.body).toHaveProperty('title');
      expect(response.body).toHaveProperty('content_blocks');
      expect(response.body).toHaveProperty('meta_title');
      expect(response.body).toHaveProperty('meta_description');
      expect(Array.isArray(response.body.content_blocks)).toBe(true);
    }, 30000); // 30 second timeout for AI generation

    it('should reject generation without keyword', async () => {
      const generateDto = {
        topic: 'Điện thoại',
        // Missing keyword
      };

      return request(app.getHttpServer())
        .post('/admin/articles/generate')
        .set('Authorization', `Bearer ${adminToken}`)
        .send(generateDto)
        .expect(400);
    });
  });

  describe('/admin/articles/upload-image (POST)', () => {
    it('should upload an image file', async () => {
      const response = await request(app.getHttpServer())
        .post('/admin/articles/upload-image')
        .set('Authorization', `Bearer ${adminToken}`)
        .attach('file', Buffer.from('test-image-data'), 'test.jpg')
        .expect(201);

      expect(response.body).toHaveProperty('url');
      expect(response.body.url).toContain('http');
    });

    it('should reject upload without file', () => {
      return request(app.getHttpServer())
        .post('/admin/articles/upload-image')
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(400);
    });
  });

  describe('/admin/articles/:id (DELETE)', () => {
    it('should delete an article', async () => {
      await request(app.getHttpServer())
        .delete(`/admin/articles/${createdArticleId}`)
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200);

      // Verify it's deleted
      await request(app.getHttpServer())
        .get(`/admin/articles/${createdArticleId}`)
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(404);
    });
  });

  describe('Public Articles API', () => {
    it('should get published articles for public', () => {
      return request(app.getHttpServer())
        .get('/articles')
        .query({ page: 1, limit: 10 })
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('data');
          expect(res.body).toHaveProperty('meta');
          // All returned articles should be published
          res.body.data.forEach((article: any) => {
            expect(article.status).toBe('published');
          });
        });
    });

    it('should get single published article by slug', async () => {
      // First create a published article
      const createDto = {
        title: 'Public Test Article',
        slug: 'public-test-article',
        excerpt: 'Public excerpt',
        featured_image: 'https://example.com/image.jpg',
        content_blocks: [
          { type: 'text', content: '<p>Public content</p>', level: 'p' },
        ],
        meta_title: 'Public Meta',
        meta_description: 'Public Description',
        status: 'published',
      };

      await request(app.getHttpServer())
        .post('/admin/articles')
        .set('Authorization', `Bearer ${adminToken}`)
        .send(createDto)
        .expect(201);

      // Now fetch it publicly
      const response = await request(app.getHttpServer())
        .get('/articles/public-test-article')
        .expect(200);

      expect(response.body.slug).toBe('public-test-article');
      expect(response.body.status).toBe('published');
    });

    it('should not expose draft articles to public', async () => {
      return request(app.getHttpServer())
        .get('/articles/test-draft-article')
        .expect(404);
    });
  });
});
