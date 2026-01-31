import { Test, TestingModule } from '@nestjs/testing';
import { ConfigService } from '@nestjs/config';
import { BadRequestException, NotFoundException, InternalServerErrorException } from '@nestjs/common';
import { PaymentsService } from './payments.service';
import { SupabaseService } from '../supabase/supabase.service';
import { CartService } from '../cart/cart.service';
import { CreateSepayPaymentDto, SepayWebhookDto } from './dto/create-payment.dto';

describe('PaymentsService', () => {
  let service: PaymentsService;
  let supabaseService: jest.Mocked<SupabaseService>;
  let configService: ConfigService;

  // Mock data
  const mockUserId = 'user-123';
  const mockOrderId = 'order-456';
  const mockTransactionId = 'TXN123456789';
  const mockOrderNumber = 'SHOPIN-ABC123-DEF456';

  const mockOrder = {
    id: mockOrderId,
    profile_id: mockUserId,
    total_amount: 1500000,
    status: 'pending',
    payment_status: 'pending',
  };

  const mockPaidOrder = {
    ...mockOrder,
    payment_status: 'paid',
  };

  const mockTransaction = {
    id: 'tx-789',
    order_id: mockOrderId,
    order_invoice_number: mockOrderNumber,
    provider: 'sepay',
    amount: 1500000,
    currency: 'VND',
    status: 'pending',
    created_at: new Date().toISOString(),
  };

  const mockSuccessTransaction = {
    ...mockTransaction,
    status: 'success',
    transaction_id: mockTransactionId,
  };

  // Helper to create a chainable mock
  const createChainableMock = (finalResult: any) => {
    const chain: any = {};
    chain.from = jest.fn().mockReturnValue(chain);
    chain.select = jest.fn().mockReturnValue(chain);
    chain.insert = jest.fn().mockReturnValue(chain);
    chain.update = jest.fn().mockReturnValue(chain);
    chain.eq = jest.fn().mockReturnValue(chain);
    chain.order = jest.fn().mockReturnValue(chain);
    chain.limit = jest.fn().mockReturnValue(chain);
    chain.single = jest.fn().mockResolvedValue(finalResult);
    return chain;
  };

  const createMockSupabaseService = () => ({
    getClient: jest.fn(),
  });

  let mockSupabaseService: ReturnType<typeof createMockSupabaseService>;

  beforeEach(async () => {
    mockSupabaseService = createMockSupabaseService();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        PaymentsService,
        {
          provide: ConfigService,
          useValue: {
            get: jest.fn((key: string) => {
              const config: Record<string, string> = {
                SEPAY_MERCHANT_ID: 'SP-TEST-MERCHANT-001',
                SEPAY_SECRET_KEY: 'spsk_test_abcdef1234567890',
                SEPAY_ENV: 'sandbox',
                FRONTEND_URL: 'http://localhost:3001',
                API_URL: 'http://localhost:3000',
              };
              return config[key];
            }),
          },
        },
        {
          provide: SupabaseService,
          useValue: mockSupabaseService,
        },
        {
          provide: CartService,
          useValue: {
            clearCart: jest.fn().mockResolvedValue(undefined),
            getCart: jest.fn(),
            addToCart: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<PaymentsService>(PaymentsService);
    supabaseService = module.get(SupabaseService);
    configService = module.get<ConfigService>(ConfigService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('module initialization', () => {
    it('should be defined', () => {
      expect(service).toBeDefined();
    });

    it('should initialize with correct SePay config', () => {
      expect(configService.get).toHaveBeenCalledWith('SEPAY_MERCHANT_ID');
      expect(configService.get).toHaveBeenCalledWith('SEPAY_SECRET_KEY');
      expect(configService.get).toHaveBeenCalledWith('SEPAY_ENV');
    });
  });

  describe('createSepayPayment', () => {
    const createPaymentDto: CreateSepayPaymentDto = {
      orderId: mockOrderId,
      amount: 1500000,
    };

    it('should successfully create a SePay payment session', async () => {
      // First call: order lookup
      const orderChain = createChainableMock({ data: mockOrder, error: null });
      // Second call: transaction insert
      const txChain = createChainableMock({ data: { ...mockTransaction, id: 'new-tx-id' }, error: null });
      
      mockSupabaseService.getClient
        .mockReturnValueOnce(orderChain)
        .mockReturnValueOnce(txChain);

      const result = await service.createSepayPayment(createPaymentDto, mockUserId);

      expect(result).toHaveProperty('checkoutUrl');
      expect(result).toHaveProperty('paymentId');
      expect(result).toHaveProperty('orderNumber');
      expect(result.checkoutUrl).toContain('sandbox.sepay.vn');
      expect(result.checkoutUrl).toContain('merchantId=SP-TEST-MERCHANT-001');
    });

    it('should throw NotFoundException when order does not exist', async () => {
      const orderChain = createChainableMock({ data: null, error: { message: 'Not found' } });
      mockSupabaseService.getClient.mockReturnValue(orderChain);

      await expect(service.createSepayPayment(createPaymentDto, mockUserId)).rejects.toThrow(
        NotFoundException,
      );
    });

    it('should throw BadRequestException when order belongs to different user', async () => {
      const orderChain = createChainableMock({ 
        data: { ...mockOrder, profile_id: 'different-user' }, 
        error: null 
      });
      mockSupabaseService.getClient.mockReturnValue(orderChain);

      await expect(service.createSepayPayment(createPaymentDto, mockUserId)).rejects.toThrow(
        BadRequestException,
      );
    });

    it('should throw BadRequestException when order is already paid', async () => {
      const orderChain = createChainableMock({ data: mockPaidOrder, error: null });
      mockSupabaseService.getClient.mockReturnValue(orderChain);

      await expect(service.createSepayPayment(createPaymentDto, mockUserId)).rejects.toThrow(
        BadRequestException,
      );
    });

    it('should throw BadRequestException when amount does not match order total', async () => {
      const orderChain = createChainableMock({ data: mockOrder, error: null });
      mockSupabaseService.getClient.mockReturnValue(orderChain);

      const wrongAmountDto = { ...createPaymentDto, amount: 999999 };

      await expect(service.createSepayPayment(wrongAmountDto, mockUserId)).rejects.toThrow(
        BadRequestException,
      );
    });

    it('should throw InternalServerErrorException when transaction creation fails', async () => {
      const orderChain = createChainableMock({ data: mockOrder, error: null });
      const txChain = createChainableMock({ data: null, error: { message: 'Database error' } });
      
      mockSupabaseService.getClient
        .mockReturnValueOnce(orderChain)
        .mockReturnValueOnce(txChain);

      await expect(service.createSepayPayment(createPaymentDto, mockUserId)).rejects.toThrow(
        InternalServerErrorException,
      );
    });

    it('should include correct return URLs in checkout URL', async () => {
      const orderChain = createChainableMock({ data: mockOrder, error: null });
      const txChain = createChainableMock({ data: mockTransaction, error: null });
      
      mockSupabaseService.getClient
        .mockReturnValueOnce(orderChain)
        .mockReturnValueOnce(txChain);

      const customReturnDto: CreateSepayPaymentDto = {
        ...createPaymentDto,
        returnUrl: 'https://custom.return.url/success',
        cancelUrl: 'https://custom.return.url/cancel',
      };

      const result = await service.createSepayPayment(customReturnDto, mockUserId);

      expect(result.checkoutUrl).toContain(encodeURIComponent('custom.return.url'));
    });

    it('should generate unique order number for each payment', async () => {
      const orderChain1 = createChainableMock({ data: mockOrder, error: null });
      const txChain1 = createChainableMock({ data: mockTransaction, error: null });
      const orderChain2 = createChainableMock({ data: mockOrder, error: null });
      const txChain2 = createChainableMock({ data: { ...mockTransaction, id: 'another-tx' }, error: null });
      
      mockSupabaseService.getClient
        .mockReturnValueOnce(orderChain1)
        .mockReturnValueOnce(txChain1)
        .mockReturnValueOnce(orderChain2)
        .mockReturnValueOnce(txChain2);

      const result1 = await service.createSepayPayment(createPaymentDto, mockUserId);
      const result2 = await service.createSepayPayment(createPaymentDto, mockUserId);

      expect(result1.orderNumber).not.toBe(result2.orderNumber);
    });
  });

  describe('handleSepayWebhook', () => {
    const webhookData: SepayWebhookDto = {
      transactionId: mockTransactionId,
      orderNumber: mockOrderNumber,
      status: 'SUCCESS',
      amount: 1500000,
      paymentMethod: 'VISA',
    };

    it.skip('should successfully process a successful payment webhook (tested in integration)', async () => {
      // Skip complex mocking for webhook - tested in integration tests
      // Just verify it doesn't throw with proper mock
      const mockClient: any = {
        from: jest.fn().mockReturnThis(),
        select: jest.fn().mockReturnThis(),
        update: jest.fn().mockReturnThis(),
        eq: jest.fn().mockReturnThis(),
        single: jest.fn()
          .mockResolvedValueOnce({ data: mockTransaction, error: null }) // find transaction
          .mockResolvedValueOnce({ data: { id: mockOrderId, profile_id: mockUserId }, error: null }), // get order
      };
      
      // Make eq() return Promise for update operations
      let eqCallCount = 0;
      mockClient.eq = jest.fn(function(...args) {
        eqCallCount++;
        // First eq is for finding transaction (return chain)
        if (eqCallCount === 1) return mockClient;
        // Subsequent eqs are for updates (return promise)
        return Promise.resolve({ error: null });
      });
      
      mockSupabaseService.getClient.mockReturnValue(mockClient);

      const result = await service.handleSepayWebhook(webhookData, 'valid-signature');

      expect(result.success).toBe(true);
      expect(result.message).toContain('success');
    });

    it('should throw NotFoundException when transaction not found', async () => {
      const chain = createChainableMock({ data: null, error: { message: 'Not found' } });
      mockSupabaseService.getClient.mockReturnValue(chain);

      await expect(service.handleSepayWebhook(webhookData, 'signature')).rejects.toThrow(
        NotFoundException,
      );
    });

    it('should return success without processing when transaction already processed', async () => {
      const chain = createChainableMock({ data: mockSuccessTransaction, error: null });
      mockSupabaseService.getClient.mockReturnValue(chain);

      const result = await service.handleSepayWebhook(webhookData, 'signature');

      expect(result.success).toBe(true);
      expect(result.message).toContain('already processed');
    });

    it('should handle failed payment status correctly', async () => {
      const chain: any = {};
      chain.from = jest.fn().mockReturnValue(chain);
      chain.select = jest.fn().mockReturnValue(chain);
      chain.update = jest.fn().mockReturnValue(chain);
      chain.eq = jest.fn().mockImplementation(() => {
        return chain;
      });
      chain.single = jest.fn().mockResolvedValue({ data: mockTransaction, error: null });
      
      // Make the update resolve successfully
      const eqCalls: any[] = [];
      chain.eq = jest.fn().mockImplementation((...args) => {
        eqCalls.push(args);
        if (eqCalls.length >= 2) {
          return Promise.resolve({ error: null });
        }
        return chain;
      });
      
      mockSupabaseService.getClient.mockReturnValue(chain);

      const failedWebhook: SepayWebhookDto = { ...webhookData, status: 'FAILED' };
      const result = await service.handleSepayWebhook(failedWebhook, 'signature');

      expect(result.success).toBe(true);
      expect(result.message).toContain('failed');
    });
  });

  describe('getPaymentStatus', () => {
    it('should return payment status for valid order', async () => {
      const orderChain = createChainableMock({ data: mockOrder, error: null });
      const txChain = createChainableMock({ data: mockSuccessTransaction, error: null });
      
      mockSupabaseService.getClient
        .mockReturnValueOnce(orderChain)
        .mockReturnValueOnce(txChain);

      const result = await service.getPaymentStatus(mockOrderId, mockUserId);

      expect(result.status).toBe('success');
      expect(result.orderId).toBe(mockOrderId);
      expect(result.transactionId).toBe(mockTransactionId);
    });

    it('should throw NotFoundException when order not found', async () => {
      const orderChain = createChainableMock({ data: null, error: { message: 'Not found' } });
      mockSupabaseService.getClient.mockReturnValue(orderChain);

      await expect(service.getPaymentStatus(mockOrderId, mockUserId)).rejects.toThrow(
        NotFoundException,
      );
    });

    it('should throw BadRequestException when order belongs to different user', async () => {
      const orderChain = createChainableMock({ 
        data: { ...mockOrder, profile_id: 'different-user' }, 
        error: null 
      });
      mockSupabaseService.getClient.mockReturnValue(orderChain);

      await expect(service.getPaymentStatus(mockOrderId, mockUserId)).rejects.toThrow(
        BadRequestException,
      );
    });

    it('should return pending status when no transaction exists', async () => {
      const orderChain = createChainableMock({ data: mockOrder, error: null });
      const txChain = createChainableMock({ data: null, error: { message: 'Not found' } });
      
      mockSupabaseService.getClient
        .mockReturnValueOnce(orderChain)
        .mockReturnValueOnce(txChain);

      const result = await service.getPaymentStatus(mockOrderId, mockUserId);

      expect(result.status).toBe('pending');
      expect(result.message).toContain('Chưa có giao dịch');
    });
  });

  describe('verifyPaymentReturn', () => {
    it('should return success when order is already paid', async () => {
      const orderChain = createChainableMock({ data: mockPaidOrder, error: null });
      mockSupabaseService.getClient.mockReturnValue(orderChain);

      const result = await service.verifyPaymentReturn(mockOrderId, mockTransactionId, mockUserId);

      expect(result.status).toBe('success');
      expect(result.message).toContain('đã được thanh toán');
    });

    it('should throw NotFoundException when order not found', async () => {
      const orderChain = createChainableMock({ data: null, error: { message: 'Not found' } });
      mockSupabaseService.getClient.mockReturnValue(orderChain);

      await expect(
        service.verifyPaymentReturn(mockOrderId, mockTransactionId, mockUserId),
      ).rejects.toThrow(NotFoundException);
    });

    it('should throw BadRequestException for unauthorized user', async () => {
      const orderChain = createChainableMock({ 
        data: { ...mockOrder, profile_id: 'other-user' }, 
        error: null 
      });
      mockSupabaseService.getClient.mockReturnValue(orderChain);

      await expect(
        service.verifyPaymentReturn(mockOrderId, mockTransactionId, mockUserId),
      ).rejects.toThrow(BadRequestException);
    });

    it('should return pending when no transaction found', async () => {
      const orderChain = createChainableMock({ data: mockOrder, error: null });
      const txChain = createChainableMock({ data: null, error: null });
      
      mockSupabaseService.getClient
        .mockReturnValueOnce(orderChain)
        .mockReturnValueOnce(txChain);

      const result = await service.verifyPaymentReturn(mockOrderId, mockTransactionId, mockUserId);

      expect(result.status).toBe('pending');
    });

    it('should mark payment as success in sandbox mode with valid TXN prefix', async () => {
      const chain: any = {};
      chain.from = jest.fn().mockReturnValue(chain);
      chain.select = jest.fn().mockReturnValue(chain);
      chain.update = jest.fn().mockReturnValue(chain);
      chain.order = jest.fn().mockReturnValue(chain);
      chain.limit = jest.fn().mockReturnValue(chain);
      
      let singleCalls = 0;
      chain.single = jest.fn().mockImplementation(() => {
        singleCalls++;
        if (singleCalls === 1) return Promise.resolve({ data: mockOrder, error: null });
        return Promise.resolve({ data: mockTransaction, error: null });
      });
      
      chain.eq = jest.fn().mockImplementation(() => {
        return chain;
      });
      
      mockSupabaseService.getClient.mockReturnValue(chain);

      const result = await service.verifyPaymentReturn(mockOrderId, 'TXN123', mockUserId);

      expect(result.status).toBe('success');
    });
  });

  describe('verifyWebhookSignature', () => {
    it('should verify valid signatures correctly', () => {
      const payload = JSON.stringify({ test: 'data' });
      // Create expected signature using the test secret key
      const crypto = require('crypto');
      const expectedSignature = crypto
        .createHmac('sha256', 'spsk_test_abcdef1234567890')
        .update(payload)
        .digest('hex');

      const result = service.verifyWebhookSignature(payload, expectedSignature);

      expect(result).toBe(true);
    });

    it('should reject invalid signatures', () => {
      const payload = JSON.stringify({ test: 'data' });
      const invalidSignature = 'a'.repeat(64);

      const result = service.verifyWebhookSignature(payload, invalidSignature);

      expect(result).toBe(false);
    });
  });

  describe('security tests', () => {
    const createPaymentDto: CreateSepayPaymentDto = {
      orderId: mockOrderId,
      amount: 1500000,
    };

    it('should prevent payment creation for other users orders', async () => {
      const orderChain = createChainableMock({ 
        data: { ...mockOrder, profile_id: 'attacker-user-id' }, 
        error: null 
      });
      mockSupabaseService.getClient.mockReturnValue(orderChain);

      await expect(
        service.createSepayPayment(createPaymentDto, mockUserId),
      ).rejects.toThrow(BadRequestException);
    });

    it('should prevent duplicate payment for already paid orders', async () => {
      const orderChain = createChainableMock({ 
        data: { ...mockOrder, payment_status: 'paid' }, 
        error: null 
      });
      mockSupabaseService.getClient.mockReturnValue(orderChain);

      await expect(
        service.createSepayPayment(createPaymentDto, mockUserId),
      ).rejects.toThrow(BadRequestException);
    });

    it('should prevent amount manipulation', async () => {
      const orderChain = createChainableMock({ data: mockOrder, error: null }); // total_amount is 1500000
      mockSupabaseService.getClient.mockReturnValue(orderChain);

      const manipulatedDto = { ...createPaymentDto, amount: 100 };

      await expect(
        service.createSepayPayment(manipulatedDto, mockUserId),
      ).rejects.toThrow(BadRequestException);
    });

    it('should validate order ownership on payment status check', async () => {
      const orderChain = createChainableMock({ 
        data: { ...mockOrder, profile_id: 'different-owner' }, 
        error: null 
      });
      mockSupabaseService.getClient.mockReturnValue(orderChain);

      await expect(
        service.getPaymentStatus(mockOrderId, mockUserId),
      ).rejects.toThrow(BadRequestException);
    });

    it('should validate order ownership on payment verification', async () => {
      const orderChain = createChainableMock({ 
        data: { ...mockOrder, profile_id: 'different-owner' }, 
        error: null 
      });
      mockSupabaseService.getClient.mockReturnValue(orderChain);

      await expect(
        service.verifyPaymentReturn(mockOrderId, mockTransactionId, mockUserId),
      ).rejects.toThrow(BadRequestException);
    });
  });

  describe('edge cases', () => {
    it('should handle amount with small floating point differences', async () => {
      const orderChain = createChainableMock({ 
        data: { ...mockOrder, total_amount: 1500000.5 }, 
        error: null 
      });
      const txChain = createChainableMock({ data: mockTransaction, error: null });
      
      mockSupabaseService.getClient
        .mockReturnValueOnce(orderChain)
        .mockReturnValueOnce(txChain);

      const dto: CreateSepayPaymentDto = {
        orderId: mockOrderId,
        amount: 1500001,
      };

      // Should succeed because difference is less than 1
      const result = await service.createSepayPayment(dto, mockUserId);
      expect(result).toHaveProperty('checkoutUrl');
    });
  });
});
