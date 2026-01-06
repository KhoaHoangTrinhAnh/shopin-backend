import { IsUUID, IsNotEmpty } from 'class-validator';

export class AddFavoriteDto {
  @IsUUID()
  @IsNotEmpty()
  product_id: string;
}

export class FavoriteItemResponse {
  product_id: string;
  added_at: string;
  product: {
    id: string;
    name: string;
    slug: string;
    category?: {
      id: number;
      name: string;
      slug: string | null;
    };
    default_variant?: {
      id: string;
      price: number;
      original_price: number | null;
      main_image: string | null;
    };
  };
}

export class FavoritesResponse {
  items: FavoriteItemResponse[];
  total: number;
}
