import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { SupabaseService } from '../supabase/supabase.service';
import { Category, Brand } from '../products/entities/product.entity';

export interface CreateCategoryDto {
  name: string;
  slug: string;
  description?: string;
  image_url?: string;
}

export interface UpdateCategoryDto {
  name?: string;
  slug?: string;
  description?: string;
  image_url?: string;
}

export interface CreateBrandDto {
  name: string;
  slug: string;
  description?: string;
  logo_url?: string;
}

export interface UpdateBrandDto {
  name?: string;
  slug?: string;
  description?: string;
  logo_url?: string;
}

@Injectable()
export class CategoriesService {
  constructor(private readonly supabaseService: SupabaseService) {}

  async findAll(): Promise<Category[]> {
    const supabase = this.supabaseService.getClient();
    
    const { data, error } = await supabase
      .from('categories')
      .select('*')
      .order('name', { ascending: true });

    if (error) {
      throw new Error(`Error fetching categories: ${error.message}`);
    }

    return data as Category[];
  }

  async findOne(id: number): Promise<Category> {
    const supabase = this.supabaseService.getClient();
    
    const { data, error } = await supabase
      .from('categories')
      .select('*')
      .eq('id', id)
      .maybeSingle();

    if (error) {
      throw new BadRequestException(`Error fetching category: ${error.message}`);
    }

    if (!data) {
      throw new NotFoundException(`Category with ID ${id} not found`);
    }

    return data as Category;
  }

  async create(dto: CreateCategoryDto): Promise<Category> {
    const supabase = this.supabaseService.getClient();
    
    const { data, error } = await supabase
      .from('categories')
      .insert(dto)
      .select()
      .single();

    if (error) {
      throw new BadRequestException(`Error creating category: ${error.message}`);
    }

    return data as Category;
  }

  async update(id: number, dto: UpdateCategoryDto): Promise<Category> {
    const supabase = this.supabaseService.getClient();
    
    const { data, error } = await supabase
      .from('categories')
      .update(dto)
      .eq('id', id)
      .select()
      .single();

    if (error) {
      throw new BadRequestException(`Error updating category: ${error.message}`);
    }

    if (!data) {
      throw new NotFoundException(`Category with ID ${id} not found`);
    }

    return data as Category;
  }

  async delete(id: number): Promise<{ success: boolean }> {
    const supabase = this.supabaseService.getClient();
    
    // Check if category has products
    const { count } = await supabase
      .from('products')
      .select('id', { count: 'exact', head: true })
      .eq('category_id', id);

    if (count && count > 0) {
      throw new BadRequestException(`Cannot delete category with ${count} products`);
    }

    const { error } = await supabase
      .from('categories')
      .delete()
      .eq('id', id);

    if (error) {
      throw new BadRequestException(`Error deleting category: ${error.message}`);
    }

    return { success: true };
  }

  async getProductCount(id: number): Promise<number> {
    const supabase = this.supabaseService.getClient();
    
    const { count } = await supabase
      .from('products')
      .select('id', { count: 'exact', head: true })
      .eq('category_id', id);

    return count || 0;
  }
}

@Injectable()
export class BrandsService {
  constructor(private readonly supabaseService: SupabaseService) {}

  async findAll(): Promise<Brand[]> {
    const supabase = this.supabaseService.getClient();
    
    const { data, error } = await supabase
      .from('brands')
      .select('*')
      .order('name', { ascending: true });

    if (error) {
      throw new Error(`Error fetching brands: ${error.message}`);
    }

    return data as Brand[];
  }

  async findOne(id: number): Promise<Brand> {
    const supabase = this.supabaseService.getClient();
    
    const { data, error } = await supabase
      .from('brands')
      .select('*')
      .eq('id', id)
      .maybeSingle();

    if (error) {
      throw new BadRequestException(`Error fetching brand: ${error.message}`);
    }

    if (!data) {
      throw new NotFoundException(`Brand with ID ${id} not found`);
    }

    return data as Brand;
  }

  async create(dto: CreateBrandDto): Promise<Brand> {
    const supabase = this.supabaseService.getClient();
    
    const { data, error } = await supabase
      .from('brands')
      .insert(dto)
      .select()
      .single();

    if (error) {
      throw new BadRequestException(`Error creating brand: ${error.message}`);
    }

    return data as Brand;
  }

  async update(id: number, dto: UpdateBrandDto): Promise<Brand> {
    const supabase = this.supabaseService.getClient();
    
    const { data, error } = await supabase
      .from('brands')
      .update(dto)
      .eq('id', id)
      .select()
      .single();

    if (error) {
      throw new BadRequestException(`Error updating brand: ${error.message}`);
    }

    if (!data) {
      throw new NotFoundException(`Brand with ID ${id} not found`);
    }

    return data as Brand;
  }

  async delete(id: number): Promise<{ success: boolean }> {
    const supabase = this.supabaseService.getClient();
    
    // Check if brand has products
    const { count } = await supabase
      .from('products')
      .select('id', { count: 'exact', head: true })
      .eq('brand_id', id);

    if (count && count > 0) {
      throw new BadRequestException(`Cannot delete brand with ${count} products`);
    }

    const { error } = await supabase
      .from('brands')
      .delete()
      .eq('id', id);

    if (error) {
      throw new BadRequestException(`Error deleting brand: ${error.message}`);
    }

    return { success: true };
  }

  async getProductCount(id: number): Promise<number> {
    const supabase = this.supabaseService.getClient();
    
    const { count } = await supabase
      .from('products')
      .select('id', { count: 'exact', head: true })
      .eq('brand_id', id);

    return count || 0;
  }
}
