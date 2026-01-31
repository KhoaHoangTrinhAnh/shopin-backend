import { IsNotEmpty, IsNumber, IsUUID, IsOptional, IsString, IsUrl, Min } from 'class-validator';

export class CreateSepayPaymentDto {
  @IsUUID()
  @IsNotEmpty()
  orderId: string;

  @IsNumber()
  @Min(1000, { message: 'Minimum payment amount is 1000 VND' })
  amount: number;

  @IsOptional()
  @IsUrl({ protocols: ['http', 'https'], require_protocol: true })
  returnUrl?: string;

  @IsOptional()
  @IsUrl({ protocols: ['http', 'https'], require_protocol: true })
  cancelUrl?: string;
}

export class SepayWebhookDto {
  @IsString()
  transactionId: string;

  @IsString()
  orderNumber: string;

  @IsString()
  status: string;

  @IsNumber()
  amount: number;

  @IsOptional()
  @IsString()
  paymentMethod?: string;

  @IsOptional()
  @IsString()
  message?: string;
}

export class VerifyPaymentDto {
  @IsString()
  @IsNotEmpty()
  transactionId: string;

  @IsUUID()
  @IsNotEmpty()
  orderId: string;
}

export class CreatePaymentResponseDto {
  checkoutUrl: string;
  paymentId: string;
  orderNumber: string;
  formFields?: any; // SePay form fields for auto-submit
}

export class PaymentStatusResponseDto {
  status: 'pending' | 'success' | 'failed' | 'cancelled';
  orderId: string;
  transactionId?: string;
  message?: string;
}
