export interface Brand {
  id: number;
  name: string;
  slug: string;
}

export interface Category {
  id: number;
  name: string;
  slug: string;
}

export interface ProductVariant {
  id: string;
  product_id: string;
  sku: string;
  attributes: Record<string, any> | null;
  variant_slug: string;
  // Store prices in cents (integer) to avoid floating-point precision issues
  // Display: divide by 100 and format as currency
  price: number; // in cents, e.g., 1999900 = 19,999.00 VND
  original_price: number | null; // in cents
  qty: number;
  specifications: Array<Record<string, any>> | null;
  image_filenames: string[] | null;
  image_urls: string[] | null;
  main_image: string | null;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface Product {
  id: string;
  name: string;
  slug: string;
  brand_id: number | null;
  category_id: number | null;
  description: string | null;
  default_variant_id: string;
  meta: Record<string, any> | null;
  is_active: boolean;
  created_at: string;
  updated_at: string;
  
  // Relations
  brand?: Brand;
  category?: Category;
  default_variant?: ProductVariant;
  variants?: ProductVariant[];
}
