import { Test, TestingModule } from '@nestjs/testing';
import { ConfigModule } from '@nestjs/config';
import { PaymentsService } from './payments.service';
import { SupabaseService } from '../supabase/supabase.service';
import { CartService } from '../cart/cart.service';
import { OrdersService } from '../orders/orders.service';
import { AddressesService } from '../addresses/addresses.service';

/**
 * Integration tests for Order + Payment flow
 * Tests the complete user journey: create order → create payment → webhook → cart cleared
 */
describe('PaymentsService Integration Tests', () => {
  let paymentsService: PaymentsService;
  let ordersService: OrdersService;
  let cartService: CartService;
  let addressesService: AddressesService;
  let supabaseService: SupabaseService;
  let mockSupabaseClient: any;

  const mockUserId = 'test-user-123';
  const mockOrderId = 'test-order-456';
  const mockAddressId = 'test-address-789';

  beforeEach(async () => {
    // Mock Supabase client with comprehensive chain-able responses
    mockSupabaseClient = {
      from: jest.fn(function() {
        return this;
      }),
      select: jest.fn(function() {
        return this;
      }),
      insert: jest.fn(function() {
        return this;
      }),
      update: jest.fn(function() {
        return this;
      }),
      delete: jest.fn(function() {
        return this;
      }),
      eq: jest.fn(function() {
        return this;
      }),
      in: jest.fn(function() {
        return this;
      }),
      single: jest.fn(),
      maybeSingle: jest.fn(),
      order: jest.fn(function() {
        return this;
      }),
      range: jest.fn(function() {
        return this;
      }),
      limit: jest.fn(function() {
        return this;
      }),
    };

    const module: TestingModule = await Test.createTestingModule({
      imports: [
        ConfigModule.forRoot({
          isGlobal: true,
          envFilePath: '.env.test',
        }),
      ],
      providers: [
        PaymentsService,
        OrdersService,
        CartService,
        AddressesService,
        {
          provide: SupabaseService,
          useValue: {
            getClient: jest.fn(() => mockSupabaseClient),
          },
        },
      ],
    }).compile();

    paymentsService = module.get<PaymentsService>(PaymentsService);
    ordersService = module.get<OrdersService>(OrdersService);
    cartService = module.get<CartService>(CartService);
    addressesService = module.get<AddressesService>(AddressesService);
    supabaseService = module.get<SupabaseService>(SupabaseService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('Complete Order + Payment Flow for Card Payment', () => {
    it('should create order with status=pending and not clear cart for card payment', async () => {
      // Mock cart with items
      mockSupabaseClient.single.mockResolvedValueOnce({
        data: { items: [] },
        error: null,
      });

      const mockCartItems = [
        {
          id: 'cart-1',
          product_id: 'prod-1',
          variant_id: 'var-1',
          qty: 2,
          unit_price: 100000,
          product: { name: 'Test Product' },
          variant: { 
            attributes: { color: 'Red', size: 'M' },
            main_image: 'test.jpg',
          },
        },
      ];

      mockSupabaseClient.select.mockResolvedValueOnce({
        data: mockCartItems,
        error: null,
      });

      // Mock address
      mockSupabaseClient.single.mockResolvedValueOnce({
        data: {
          id: mockAddressId,
          full_name: 'Test User',
          phone: '0123456789',
          address_line: '123 Test St',
          city: 'Ho Chi Minh',
        },
        error: null,
      });

      // Mock order creation
      const mockOrder = {
        id: mockOrderId,
        order_number: 'SPN-250122-ABCD',
        profile_id: mockUserId,
        status: 'pending',
        payment_status: 'pending',
        subtotal: 200000,
        shipping_fee: 30000,
        total: 230000,
        payment_method: 'card',
        address: {
          full_name: 'Test User',
          phone: '0123456789',
          address_line: '123 Test St',
          city: 'Ho Chi Minh',
        },
      };

      mockSupabaseClient.single.mockResolvedValueOnce({
        data: mockOrder,
        error: null,
      });

      // Mock order items insertion
      mockSupabaseClient.insert.mockResolvedValueOnce({
        error: null,
      });

      // Mock getOrderById for final fetch
      mockSupabaseClient.single
        .mockResolvedValueOnce({ data: mockOrder, error: null })
        .mockResolvedValueOnce({ data: mockCartItems, error: null });

      // Create order with card payment
      const order = await ordersService.createOrder(mockUserId, {
        address_id: mockAddressId,
        payment_method: 'card',
      });

      // Verify order is created with pending status
      expect(order.status).toBe('pending');
      expect(order.payment_method).toBe('card');

      // Verify cart is NOT cleared (cart service delete should not be called)
      expect(mockSupabaseClient.delete).not.toHaveBeenCalled();
    });

    it('should create payment for pending order', async () => {
      // Mock order lookup
      mockSupabaseClient.single.mockResolvedValueOnce({
        data: {
          id: mockOrderId,
          profile_id: mockUserId,
          total: 230000,
          status: 'pending',
          payment_status: 'pending',
        },
        error: null,
      });

      // Mock payment transaction creation
      const mockTransaction = {
        id: 'txn-123',
        order_id: mockOrderId,
        order_invoice_number: 'SHOPIN-123-ABC',
        amount: 230000,
        status: 'pending',
      };

      mockSupabaseClient.single.mockResolvedValueOnce({
        data: mockTransaction,
        error: null,
      });

      // Create payment
      const payment = await paymentsService.createSepayPayment({
        orderId: mockOrderId,
        amount: 230000,
        returnUrl: 'http://localhost:3000/orders/success',
      }, mockUserId);

      // Verify payment is created
      expect(payment.checkoutUrl).toContain('sandbox.sepay.vn');
      expect(payment.paymentId).toBe('txn-123');
    });

    it('should update order status and clear cart when webhook confirms payment', async () => {
      const orderNumber = 'SHOPIN-123-ABC';

      // Mock transaction lookup
      mockSupabaseClient.single.mockResolvedValueOnce({
        data: {
          id: 'txn-123',
          order_id: mockOrderId,
          status: 'pending',
        },
        error: null,
      });

      // Mock transaction update
      mockSupabaseClient.update.mockResolvedValueOnce({
        error: null,
      });

      // Mock order data fetch for profile_id
      mockSupabaseClient.single.mockResolvedValueOnce({
        data: {
          id: mockOrderId,
          profile_id: mockUserId,
        },
        error: null,
      });

      // Mock order update
      mockSupabaseClient.update.mockResolvedValueOnce({
        error: null,
      });

      // Mock cart clear
      mockSupabaseClient.delete.mockResolvedValueOnce({
        error: null,
      });

      // Process webhook
      const result = await paymentsService.handleSepayWebhook({
        orderNumber,
        transactionId: 'sepay-txn-xyz',
        status: 'SUCCESS',
        amount: 230000,
        paymentMethod: 'VISA',
      }, 'test-signature');

      // Verify webhook processed successfully
      expect(result.success).toBe(true);

      // Verify order was updated (2 update calls: transaction + order)
      expect(mockSupabaseClient.update).toHaveBeenCalledTimes(2);

      // Verify cart was cleared
      expect(mockSupabaseClient.delete).toHaveBeenCalled();
    });
  });

  describe('COD Order Flow', () => {
    it('should create order with status=confirmed and clear cart immediately for COD', async () => {
      // Mock cart with items
      mockSupabaseClient.single.mockResolvedValueOnce({
        data: { items: [] },
        error: null,
      });

      const mockCartItems = [
        {
          id: 'cart-1',
          product_id: 'prod-1',
          variant_id: 'var-1',
          qty: 1,
          unit_price: 500000,
          product: { name: 'Test Product' },
          variant: { 
            attributes: { color: 'Blue' },
            main_image: 'test.jpg',
          },
        },
      ];

      mockSupabaseClient.select.mockResolvedValueOnce({
        data: mockCartItems,
        error: null,
      });

      // Mock address
      mockSupabaseClient.single.mockResolvedValueOnce({
        data: {
          id: mockAddressId,
          full_name: 'COD User',
          phone: '0987654321',
          address_line: '456 COD St',
        },
        error: null,
      });

      // Mock order creation
      const mockOrder = {
        id: 'cod-order-123',
        order_number: 'SPN-250122-COD1',
        profile_id: mockUserId,
        status: 'confirmed',
        payment_status: null,
        subtotal: 500000,
        shipping_fee: 0,
        total: 500000,
        payment_method: 'cod',
      };

      mockSupabaseClient.single.mockResolvedValueOnce({
        data: mockOrder,
        error: null,
      });

      // Mock order items insertion
      mockSupabaseClient.insert.mockResolvedValueOnce({
        error: null,
      });

      // Mock cart clear for COD
      mockSupabaseClient.delete.mockResolvedValueOnce({
        error: null,
      });

      // Mock getOrderById final fetch
      mockSupabaseClient.single
        .mockResolvedValueOnce({ data: mockOrder, error: null })
        .mockResolvedValueOnce({ data: [], error: null });

      // Create COD order
      const order = await ordersService.createOrder(mockUserId, {
        address_id: mockAddressId,
        payment_method: 'cod',
      });

      // Verify order is confirmed immediately
      expect(order.status).toBe('confirmed');
      expect(order.payment_method).toBe('cod');

      // Verify cart was cleared (delete called for COD)
      expect(mockSupabaseClient.delete).toHaveBeenCalled();
    });
  });

  describe('Error Scenarios', () => {
    it('should throw error when creating payment for non-existent order', async () => {
      // Mock order not found
      mockSupabaseClient.single.mockResolvedValueOnce({
        data: null,
        error: { message: 'Not found' },
      });

      await expect(
        paymentsService.createSepayPayment({
          orderId: 'invalid-order-id',
          amount: 100000,
        }, mockUserId)
      ).rejects.toThrow('Đơn hàng không tồn tại');
    });

    it('should throw error when user tries to pay for someone else\'s order', async () => {
      // Mock order belonging to different user
      mockSupabaseClient.single.mockResolvedValueOnce({
        data: {
          id: mockOrderId,
          profile_id: 'different-user-id',
          total: 230000,
        },
        error: null,
      });

      await expect(
        paymentsService.createSepayPayment({
          orderId: mockOrderId,
          amount: 230000,
        }, mockUserId)
      ).rejects.toThrow('Bạn không có quyền thanh toán đơn hàng này');
    });

    it('should handle webhook for already processed payment', async () => {
      const orderNumber = 'SHOPIN-ALREADY-PAID';

      // Mock transaction already success
      mockSupabaseClient.single.mockResolvedValueOnce({
        data: {
          id: 'txn-456',
          order_id: mockOrderId,
          status: 'success',
        },
        error: null,
      });

      const result = await paymentsService.handleSepayWebhook({
        orderNumber,
        transactionId: 'sepay-txn-duplicate',
        status: 'SUCCESS',
        amount: 230000,
        paymentMethod: 'VISA',
      }, 'test-signature');

      // Should return success without processing
      expect(result.success).toBe(true);
      expect(result.message).toBe('Transaction already processed');

      // Should not update anything
      expect(mockSupabaseClient.update).not.toHaveBeenCalled();
    });

    it('should not clear cart when payment fails', async () => {
      const orderNumber = 'SHOPIN-FAILED-PAYMENT';

      // Mock transaction lookup
      mockSupabaseClient.single.mockResolvedValueOnce({
        data: {
          id: 'txn-789',
          order_id: mockOrderId,
          status: 'pending',
        },
        error: null,
      });

      // Mock transaction update
      mockSupabaseClient.update.mockResolvedValueOnce({
        error: null,
      });

      // Process failed payment webhook
      await paymentsService.handleSepayWebhook({
        orderNumber,
        transactionId: 'sepay-txn-failed',
        status: 'FAILED',
        amount: 230000,
        paymentMethod: 'VISA',
      }, 'test-signature');

      // Verify cart was NOT cleared (only 1 update for transaction, no order update)
      expect(mockSupabaseClient.update).toHaveBeenCalledTimes(1);
      expect(mockSupabaseClient.delete).not.toHaveBeenCalled();
    });
  });

  describe('Amount Validation', () => {
    it('should reject payment when amount does not match order total', async () => {
      // Mock order with different total
      mockSupabaseClient.single.mockResolvedValueOnce({
        data: {
          id: mockOrderId,
          profile_id: mockUserId,
          total: 230000,
          status: 'pending',
        },
        error: null,
      });

      await expect(
        paymentsService.createSepayPayment({
          orderId: mockOrderId,
          amount: 100000, // Wrong amount
        }, mockUserId)
      ).rejects.toThrow('Số tiền không khớp với đơn hàng');
    });
  });
});
