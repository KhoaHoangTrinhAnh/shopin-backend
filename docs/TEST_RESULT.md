PS D:\shopin-backend> npm test -- articles.service.spec                   

> shopin-backend@0.0.1 test
> jest articles.service.spec

 FAIL  src/admin/articles.service.spec.ts (27.602 s)
  ArticlesService - AI Response Parsing
    parseAIResponse
      √ should parse a well-formatted AI response (5 ms)
      √ should handle missing fields with fallbacks (1 ms)
      √ should clean markdown formatting from response (1 ms)
      √ should generate slug from title when SEO_KEYWORD is missing (1 ms)
      √ should handle empty response gracefully (1 ms)
    validateParsedContent
      √ should validate valid content without errors (1 ms)
      √ should return error for missing title (1 ms)
      √ should return error for content too short (1 ms)
      √ should return warning for title too long (1 ms)
      √ should return warning for markdown remnants in body (1 ms)        
      √ should return warning for missing HTML structure
      √ should return warning for too few tags
      √ should return warning for invalid slug characters (1 ms)
    generateSeoUrl
      √ should convert Vietnamese text to URL-safe slug
      √ should handle special characters
      √ should handle multiple spaces and hyphens (1 ms)
      √ should truncate to 100 characters
      √ should handle đ and Đ characters
    convertPromptJsonbToText
      × should convert a full JSONB prompt to text correctly (5 ms)       
      × should merge with default values for partial JSONB prompt (4 ms)  
      √ should return the default template if the input is a string       
      √ should return the default template if the input is null or undefined

  ● ArticlesService - AI Response Parsing › convertPromptJsonbToText › should convert a full JSONB prompt to text correctly

    expect(received).toBe(expected) // Object.is equality

    - Expected  - 1
    + Received  + 7

      TITLE: A captivating and SEO-friendly article title (tối đa 100 ký tự)
    +
      DESCRIPTION: Detailed article content, ít nhất 800 từ.
    +
      CẤU TRÚC BÀI VIẾT:
      - Introduction
      - Main points
      - Conclusion

      TAGS: 5-8 từ khóa liên quan, cách nhau bằng dấu phẩy, không có dấu ngoặc
    +
      SEO_KEYWORD: SEO-friendly URL slug (ví dụ: my-awesome-article), lowercase, hyphens, tối đa 80 ký tự
    +
      META_TITLE: Optimized meta title for search engines, dài 50-60 characters, tự nhiên, không trùng 100% với TITLE
    +
      META_DESCRIPTION: Compelling meta description 120-150 characters, tự nhiên
    +
      META_KEYWORDS: SEO keywords, cách nhau bằng dấu phẩy, ĐÚNG chính tả, đầy đủ chữ
    +
      Yêu cầu:
      - Nội dung đầy đủ, không bị cắt giữa chừng
      - DESCRIPTION phải có cấu trúc <h3>Tiêu đề</h3><p>Nội dung</p> rõ ràng
      - Mọi nội dung HTML phải hợp lệ
      - Tất cả field phải có nội dung hoàn chỉnh
      - Viết văn phong báo chí tự nhiên, đúng chính tả
      - Tập trung cung cấp thông tin hữu ích, có thể đăng ngay lên website tin tức
    -

      318 |       // Access the private method using bracket notation for 
testing
      319 |       const result = (service as any).convertPromptJsonbToText(fullJsonb);
    > 320 |       expect(result).toBe(expectedText);
          |                      ^
      321 |     });
      322 |
      323 |     it('should merge with default values for partial JSONB prompt', () => {

      at Object.<anonymous> (admin/articles.service.spec.ts:320:22)       

  ● ArticlesService - AI Response Parsing › convertPromptJsonbToText › should merge with default values for partial JSONB prompt

    expect(received).toBe(expected) // Object.is equality

    - Expected  - 6
    + Received  + 2

      TITLE: Partial Title Instruction
    +
      DESCRIPTION: Nội dung bài viết chi tiết.
    +
      CẤU TRÚC BÀI VIẾT:
      - Only this point

    - TAGS: 5-8 từ khóa liên quan, cách nhau bằng dấu phẩy
    - SEO_KEYWORD: URL slug thân thiện SEO
    - META_TITLE: Tiêu đề SEO tối ưu
    - META_DESCRIPTION: Mô tả SEO hấp dẫn
    - META_KEYWORDS: Từ khóa SEO, cách nhau bằng dấu phẩy
      Yêu cầu:
      - Nội dung đầy đủ, không bị cắt giữa chừng
      - DESCRIPTION phải có cấu trúc <h3>Tiêu đề</h3><p>Nội dung</p> rõ ràng
      - Mọi nội dung HTML phải hợp lệ
      - Tất cả field phải có nội dung hoàn chỉnh
      - Viết văn phong báo chí tự nhiên, đúng chính tả
      - Tập trung cung cấp thông tin hữu ích, có thể đăng ngay lên website tin tức
    -

      346 |
      347 |       const result = (service as any).convertPromptJsonbToText(partialJsonb);
    > 348 |       expect(result).toBe(expectedText);
          |                      ^
      349 |     });
      350 |
      351 |     it('should return the default template if the input is a s

Test Suites: 1 failed, 1 total
Tests:       2 failed, 20 passed, 22 total
Snapshots:   0 total