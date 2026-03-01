/**
 * CORRECTED Example Tests - Direct Order Creation
 * This shows the proper pattern for fixing incomplete tests
 */

import { Test, TestingModule } from '@nestjs/testing';
import { NotFoundException, BadRequestException } from '@nestjs/common';
import { plainToInstance } from 'class-transformer';
import { validate } from 'class-validator';
import { OrdersService } from '../orders.service';
import { SupabaseService } from '../../supabase/supabase.service';
import { AddressesService } from '../../addresses/addresses.service';
import { CreateDirectOrderDto } from '../dto/create-direct-order.dto';

describe('OrdersService - Direct Checkout (FIXED)', () => {
  let service: OrdersService;
  let mockSupabaseClient: any;
  let mockAddressesService: any;

  const mockVariant = {
    id: '68c05a1e-ed24-431e-a70d-ef14fb16dc4b',
    product_id: 'prod-123',
    variant_slug: 'iphone-15-pro-128gb-black',
    price: 25000000,
    qty: 10,
    is_active: true,
    product: {
      id: 'prod-123',
      name: 'iPhone 15 Pro',
      slug: 'iphone-15-pro',
    },
  };

  beforeEach(async () => {
    mockSupabaseClient = {
      from: jest.fn(),
    };

    const mockSupabaseService = {
      getClient: jest.fn(() => mockSupabaseClient),
    };

    mockAddressesService = {
      getAddressById: jest.fn(),
      getDefaultAddress: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        OrdersService,
        { provide: SupabaseService, useValue: mockSupabaseService },
        { provide: AddressesService, useValue: mockAddressesService },
      ],
    }).compile();

    service = module.get<OrdersService>(OrdersService);
    jest.clearAllMocks();
  });

  describe('Error Handling - FIXED', () => {
    it('should throw NotFoundException when variant not found', async () => {
      // Mock variant lookup returning null
      mockSupabaseClient.from.mockReturnValue({
        select: jest.fn().mockReturnValue({
          eq: jest.fn().mockReturnValue({
            single: jest.fn().mockResolvedValue({
              data: null,
              error: { message: 'Not found' },
            }),
          }),
        }),
      });

      const dto: CreateDirectOrderDto = {
        variant_id: 'nonexistent-id',
        qty: 1,
        address_id: 'addr-123',
      };

      // FIXED: Actually call the service and assert exception
      await expect(service.createDirectOrder('user-123', dto))
        .rejects
        .toThrow(NotFoundException);
    });

    it('should throw BadRequestException for inactive variant', async () => {
      const inactiveVariant = { ...mockVariant, is_active: false };
      
      mockSupabaseClient.from.mockReturnValue({
        select: jest.fn().mockReturnValue({
          eq: jest.fn().mockReturnValue({
            single: jest.fn().mockResolvedValue({
              data: inactiveVariant,
              error: null,
            }),
          }),
        }),
      });

      const dto: CreateDirectOrderDto = {
        variant_id: mockVariant.id,
        qty: 1,
        address_id: 'addr-123',
      };

      // FIXED: Call service and assert error
      await expect(service.createDirectOrder('user-123', dto))
        .rejects
        .toThrow(BadRequestException);
      
      // Verify error message mentions "not available"
      await expect(service.createDirectOrder('user-123', dto))
        .rejects
        .toThrow(/not available/);
    });

    it('should throw BadRequestException for insufficient stock', async () => {
      const lowStockVariant = { ...mockVariant, qty: 0 };
      
      mockSupabaseClient.from.mockReturnValue({
        select: jest.fn().mockReturnValue({
          eq: jest.fn().mockReturnValue({
            single: jest.fn().mockResolvedValue({
              data: lowStockVariant,
              error: null,
            }),
          }),
        }),
      });

      const dto: CreateDirectOrderDto = {
        variant_id: mockVariant.id,
        qty: 5,
        address_id: 'addr-123',
      };

      // FIXED: Call and assert
      await expect(service.createDirectOrder('user-123', dto))
        .rejects
        .toThrow(BadRequestException);
      
      await expect(service.createDirectOrder('user-123', dto))
        .rejects
        .toThrow(/available in stock/);
    });
  });

  describe('DTO Validation - FIXED', () => {
    it('should require variant_id', async () => {
      // FIXED: Use class-transformer and class-validator
      const plainDto = { qty: 1, address_id: 'addr-123' };
      const dto = plainToInstance(CreateDirectOrderDto, plainDto);
      const errors = await validate(dto);
      
      expect(errors.length).toBeGreaterThan(0);
      const variantIdError = errors.find(e => e.property === 'variant_id');
      expect(variantIdError).toBeDefined();
    });

    it('should require positive qty', async () => {
      const plainDto = { 
        variant_id: 'some-id', 
        qty: 0, 
        address_id: 'addr-123' 
      };
      const dto = plainToInstance(CreateDirectOrderDto, plainDto);
      const errors = await validate(dto);
      
      expect(errors.length).toBeGreaterThan(0);
      const qtyError = errors.find(e => e.property === 'qty');
      expect(qtyError).toBeDefined();
      expect(qtyError?.constraints).toHaveProperty('min');
    });

    it('should require at least one address field', async () => {
      const plainDto = { 
        variant_id: 'some-id', 
        qty: 1 
        // Missing both address_id and address
      };
      const dto = plainToInstance(CreateDirectOrderDto, plainDto);
      const errors = await validate(dto);
      
      // Should have validation errors since neither address field provided
      expect(errors.length).toBeGreaterThan(0);
    });
  });
});
