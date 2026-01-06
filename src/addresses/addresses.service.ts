import { Injectable, NotFoundException, BadRequestException, ForbiddenException } from '@nestjs/common';
import { SupabaseService } from '../supabase/supabase.service';
import { CreateAddressDto, UpdateAddressDto, AddressResponse, AddressesResponse } from './dto/addresses.dto';

@Injectable()
export class AddressesService {
  constructor(private readonly supabaseService: SupabaseService) {}

  /**
   * Get all addresses for a profile
   */
  async getAddresses(profileId: string): Promise<AddressesResponse> {
    const supabase = this.supabaseService.getClient();

    const { data: addresses, error } = await supabase
      .from('addresses')
      .select('*')
      .eq('profile_id', profileId)
      .order('is_default', { ascending: false })
      .order('created_at', { ascending: false });

    if (error) {
      throw new BadRequestException('Failed to fetch addresses');
    }

    const items = addresses || [];
    const defaultAddress = items.find((a) => a.is_default) || items[0] || null;

    return {
      items,
      default_address: defaultAddress,
      total: items.length,
    };
  }

  /**
   * Get default or most recent address
   */
  async getDefaultAddress(profileId: string): Promise<AddressResponse | null> {
    const supabase = this.supabaseService.getClient();

    // First try to get default address
    const { data: defaultAddr } = await supabase
      .from('addresses')
      .select('*')
      .eq('profile_id', profileId)
      .eq('is_default', true)
      .single();

    if (defaultAddr) {
      return defaultAddr;
    }

    // Fallback to most recent address
    const { data: recentAddr } = await supabase
      .from('addresses')
      .select('*')
      .eq('profile_id', profileId)
      .order('created_at', { ascending: false })
      .limit(1)
      .single();

    return recentAddr || null;
  }

  /**
   * Get address by ID and verify ownership
   */
  async getAddressById(profileId: string, addressId: string): Promise<AddressResponse> {
    const supabase = this.supabaseService.getClient();

    // First, fetch the address
    const { data: address, error } = await supabase
      .from('addresses')
      .select('*')
      .eq('id', addressId)
      .single();

    if (error || !address) {
      throw new NotFoundException('Address not found');
    }

    // Verify ownership
    if (address.profile_id !== profileId) {
      throw new ForbiddenException('You do not have permission to access this address');
    }

    return address;
  }

  /**
   * Create a new address
   */
  async createAddress(profileId: string, dto: CreateAddressDto): Promise<AddressResponse> {
    const supabase = this.supabaseService.getClient();

    // Check if this is the first address (make it default automatically)
    const { count, error: countError } = await supabase
      .from('addresses')
      .select('id', { count: 'exact', head: true })
      .eq('profile_id', profileId);

    if (countError) {
      throw new BadRequestException('Failed to check existing addresses');
    }

    const isFirstAddress = count === 0;
    const shouldBeDefault = dto.is_default || isFirstAddress;

    // If this should be default, unset other defaults first
    if (shouldBeDefault) {
      const { error: updateError } = await supabase
        .from('addresses')
        .update({ is_default: false })
        .eq('profile_id', profileId);

      if (updateError) {
        throw new BadRequestException('Failed to update existing default address');
      }
    }

    const { data: address, error } = await supabase
      .from('addresses')
      .insert({
        profile_id: profileId,
        full_name: dto.full_name,
        phone: dto.phone,
        address_line: dto.address_line,
        ward: dto.ward || null,
        district: dto.district || null,
        city: dto.city || null,
        is_default: shouldBeDefault,
      })
      .select('*')
      .single();

    if (error || !address) {
      throw new BadRequestException('Failed to create address');
    }

    return address;
  }

  /**
   * Update an address
   */
  async updateAddress(profileId: string, addressId: string, dto: UpdateAddressDto): Promise<AddressResponse> {
    const supabase = this.supabaseService.getClient();

    // Verify ownership
    await this.getAddressById(profileId, addressId);

    // If setting as default, unset other defaults
    if (dto.is_default) {
      await supabase
        .from('addresses')
        .update({ is_default: false })
        .eq('profile_id', profileId)
        .neq('id', addressId);
    }

    const updateData: Record<string, unknown> = { updated_at: new Date().toISOString() };
    if (dto.full_name !== undefined) updateData.full_name = dto.full_name;
    if (dto.phone !== undefined) updateData.phone = dto.phone;
    if (dto.address_line !== undefined) updateData.address_line = dto.address_line;
    if (dto.ward !== undefined) updateData.ward = dto.ward;
    if (dto.district !== undefined) updateData.district = dto.district;
    if (dto.city !== undefined) updateData.city = dto.city;
    if (dto.is_default !== undefined) updateData.is_default = dto.is_default;

    const { data: address, error } = await supabase
      .from('addresses')
      .update(updateData)
      .eq('id', addressId)
      .select('*')
      .single();

    if (error || !address) {
      throw new BadRequestException('Failed to update address');
    }

    return address;
  }

  /**
   * Delete an address
   */
  async deleteAddress(profileId: string, addressId: string): Promise<{ message: string }> {
    const supabase = this.supabaseService.getClient();

    // Verify ownership
    const address = await this.getAddressById(profileId, addressId);

    const { error } = await supabase
      .from('addresses')
      .delete()
      .eq('id', addressId);

    if (error) {
      throw new BadRequestException('Failed to delete address');
    }

    // If deleted address was default, set the most recent as new default
    if (address.is_default) {
      const { data: nextDefault } = await supabase
        .from('addresses')
        .select('id')
        .eq('profile_id', profileId)
        .order('created_at', { ascending: false })
        .limit(1)
        .single();

      if (nextDefault) {
        const { error: updateError } = await supabase
          .from('addresses')
          .update({ is_default: true })
          .eq('id', nextDefault.id);

        if (updateError) {
          throw new BadRequestException('Failed to reassign default address');
        }
      }
    }

    return { message: 'Address deleted successfully' };
  }

  /**
   * Set an address as default
   */
  async setDefaultAddress(profileId: string, addressId: string): Promise<AddressResponse> {
    const supabase = this.supabaseService.getClient();

    // Verify ownership
    await this.getAddressById(profileId, addressId);

    // Unset all other defaults
    const { error: updateError } = await supabase
      .from('addresses')
      .update({ is_default: false })
      .eq('profile_id', profileId);

    if (updateError) {
      throw new BadRequestException('Failed to unset existing default addresses');
    }

    // Set this as default
    const { data: address, error } = await supabase
      .from('addresses')
      .update({ is_default: true, updated_at: new Date().toISOString() })
      .eq('id', addressId)
      .select('*')
      .single();

    if (error || !address) {
      throw new BadRequestException('Failed to set default address');
    }

    return address;
  }
}
