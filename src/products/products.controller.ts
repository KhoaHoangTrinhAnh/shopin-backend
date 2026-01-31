import { Controller, Get, Param, Query, ParseIntPipe } from '@nestjs/common';
import { ProductsService } from './products.service';
import { ProductFilterDto } from './dto/product-filter.dto';
import { Transform } from 'class-transformer';

// Helper to transform comma-separated string to array
const toArray = (value: string | string[]): string[] => {
  if (Array.isArray(value)) return value;
  if (typeof value === 'string') return value.split(',').filter(Boolean);
  return [];
};

export class ProductFilterQueryDto extends ProductFilterDto {
  @Transform(({ value }) => toArray(value))
  declare categories?: string[];

  @Transform(({ value }) => toArray(value))
  declare brands?: string[];
}

@Controller('products')
export class ProductsController {
  constructor(private readonly productsService: ProductsService) {}

  @Get()
  findAll(@Query() filterDto: ProductFilterQueryDto) {
    return this.productsService.findAll(filterDto);
  }

  @Get('featured')
  findFeatured(
    @Query('limit', new ParseIntPipe({ optional: true })) limit: number = 8,
  ) {
    return this.productsService.findFeatured(limit);
  }

  @Get('best-selling')
  findBestSelling(
    @Query('limit', new ParseIntPipe({ optional: true })) limit: number = 8,
  ) {
    return this.productsService.findBestSelling(limit);
  }

  @Get('variants/:variantId')
  findVariant(@Param('variantId') variantId: string) {
    return this.productsService.findVariant(variantId);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.productsService.findOne(id);
  }

  @Get(':id/variants')
  findVariants(@Param('id') id: string) {
    return this.productsService.findVariants(id);
  }

  @Get(':id/related')
  findRelated(
    @Param('id') id: string,
    @Query('limit', new ParseIntPipe({ optional: true })) limit: number = 5,
  ) {
    return this.productsService.findRelated(id, limit);
  }
}
