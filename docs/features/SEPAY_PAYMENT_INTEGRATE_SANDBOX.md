Tích hợp SePay
Môi trường sandbox

## Bước 1: đăng ký trên trang web SePay và lấy các giá trị: MERCHANT ID và SECRET KEY (đã có trong .env MERCHANT_ID=SP-TEST-...
SECRET_KEY=spsk_test_...)

## Bước 2: Tạo form thanh toán trên hệ thống của bạn
Cài đặt SDK (NodeJS)
NodeJS: npm i sepay-pg-node

Ghi chú
Xem chi tiết hơn tích hợp bằng SDK NodeJS tại đây: 

---

NodeJS SDK
Thư viện Node.js SDK chính thức của cổng thanh toán SePay. Hỗ trợ các hình thức tích hợp thanh toán quét mã chuyển khoản ngân hàng VietQr, quét mã chuyển khoản Napas, thanh toán qua thẻ quốc tế/nội địa Visa/Master Card/JCB.

Yêu cầu
Node 16 hoặc cao hơn

Cài đặt
Cài đặt
Copy
npm i sepay-pg-node
Khởi tạo Client
Khởi tạo client
Copy
import { SePayPgClient } from 'sepay-pg-node';

const client = new SePayPgClient({
  env: 'sandbox',
  merchant_id: 'YOUR_MERCHANT_ID',
  secret_key: 'YOUR_MERCHANT_SECRET_KEY'
});
Giải thích tham số
Tên	Loại	Bắt buộc	Mô tả
env

string	Bắt buộc	
Môi trường hiện tại, giá trị hỗ trợ: sandbox, production
merchant_id

string	Bắt buộc	
Mã đơn vị merchant
secret_key

string	Bắt buộc	
Khóa bảo mật merchant
Khởi tạo đối tượng cho biểu mẫu thanh toán (Đơn hàng thanh toán 1 lần)
Tạo URL thanh toán
Copy
const checkoutURL = client.checkout.initCheckoutUrl();
Khởi tạo thanh toán một lần
Copy
const checkoutFormfields = client.checkout.initOneTimePaymentFields({
  operation: 'PURCHASE',
  payment_method: 'CARD' | 'BANK_TRANSFER' | 'NAPAS_BANK_TRANSFER',
  order_invoice_number: string,
  order_amount: number,
  currency: string,
  order_description?: string,
  customer_id?: string,
  success_url?: string,
  error_url?: string,
  cancel_url?: string,
  custom_data?: string,
});
Giải thích tham số
Tên	Loại	Bắt buộc	Mô tả
operation

string	Bắt buộc	
Loại giao dịch, hiện chỉ hỗ trợ: PURCHASE
payment_method

string	Bắt buộc	
Phương thức thanh toán: CARD, BANK_TRANSFER, NAPAS_BANK_TRANSFER
order_invoice_number

string	Bắt buộc	
Mã đơn hàng/hoá đơn (duy nhất)
order_amount

string	Bắt buộc	
Số tiền giao dịch
currency

string	Bắt buộc	
Đơn vị tiền tệ (VD: VND, USD)
order_description

string	Không bắt buộc	
Mô tả đơn hàng
customer_id

string	Không bắt buộc	
Mã khách hàng (nếu có)
success_url

string	Không bắt buộc	
URL callback khi thanh toán thành công
error_url

string	Không bắt buộc	
URL callback khi xảy ra lỗi
cancel_url

string	Không bắt buộc	
URL callback khi người dùng hủy thanh toán
custom_data

string	Không bắt buộc	
Dữ liệu tuỳ chỉnh (merchant tự định nghĩa)
Json trả về
Copy
{
  "merchant": "string",
  "operation": "string",
  "payment_method": "string",
  "order_invoice_number": "string",
  "order_amount": "string",
  "currency": "string",
  "order_description": "string",
  "customer_id": "string",
  "success_url": "string",
  "error_url": "string",
  "cancel_url": "string",
  "custom_data": "string",
  "signature": "string"
}
Tạo form xử lý thanh toán
Lưu ý quan trọng về tạo form HTML và chữ ký
Nếu bạn tự dựng form HTML và xây dựng hàm tạo chữ ký không theo code mẫu thì cần phải đảm bảo thứ tự các trường giống như danh sách tham số ở trên để quá trình ký khớp tuyệt đối phía SePay; Nếu bạn hoán đổi vị trí các trường thì có thể dẫn đến chữ ký bị sai và SePay sẽ xem yêu cầu này là không hợp lệ

Form thanh toán
Copy
return (
  <form action={checkoutURL} method="POST">
    {Object.keys(checkoutFormfields).map(field => (
      <input type="hidden" name={field} value={checkoutFormfields[field]} />
    ))}
    <button type="submit">Thanh toán</button>
  </form>
);
API
SDK cung cấp các phương thức để gọi Open API cho cổng thanh toán SePay.

Tra cứu danh sách đơn hàng
Copy
const fetchOrders = async () => {
  try {
    const orders = await client.order.all({
      per_page: 20,
      q: 'search-keyword',
      order_status: 'COMPLETED',
      created_at: '2025-10-13',
      from_created_at: '2025-10-01',
      to_created_at: '2025-10-13',
      customer_id: null,
      sort: {
        created_at: 'desc'
      }
    });

    console.log('Orders:', orders.data);
  } catch (error) {
    console.error('Error fetching orders:', error);
  }
};
Xem chi tiết đơn hàng
Copy
const fetchOrderDetail = async (orderInvoiceNumber) => {
  try {
    const order = await client.order.retrieve(orderInvoiceNumber);
    console.log('Order detail:', order.data);
  } catch (error) {
    console.error('Error fetching order detail:', error);
  }
};
Hủy giao dịch đơn hàng (dành cho thanh toán bằng thẻ tín dụng)
Copy
const voidTransaction = async (orderInvoiceNumber) => {
  try {
    const response = await client.order.voidTransaction(orderInvoiceNumber);
    console.log('Transaction voided successfully:', response.data);
  } catch (error) {
    console.error('Error voiding transaction:', error);
  }
};
Hủy đơn hàng (dành cho thanh toán bằng quét mã QR)
Copy
const cancelOrder = async (orderInvoiceNumber) => {
  try {
    const response = await client.order.cancel(orderInvoiceNumber);
    console.log('Order cancelled successfully:', response.data);
  } catch (error) {
    console.error('Error cancelling order:', error);
  }
};

---


Khởi tạo form thanh toán với các thông tin đơn hàng và chữ ký bảo mật

YOUR_MERCHANT_ID: MERCHANT ID bạn đã sao chép trên thông tin tích hợp ở bước 1
YOUR_MERCHANT_SECRET_KEY: SECRET KEY bạn đã sao chép trên thông tin tích hợp ở bước 1

SDK NodeJS:
import { SePayPgClient } from 'sepay-pg-node-sdk';

const client = new SePayPgClient({
  env: 'sandbox',
  merchant_id: 'YOUR_MERCHANT_ID',
  secret_key: 'YOUR_MERCHANT_SECRET_KEY'
});

const checkoutURL = client.checkout.initCheckoutUrl();

const checkoutFormfields = client.checkout.initOneTimePaymentFields({
  operation: 'PURCHASE',
  payment_method: 'BANK_TRANSFER',
  order_invoice_number: 'DH123',
  order_amount: 10000,
  currency: 'VND',
  order_description: 'Thanh toan don hang DH123',
  success_url: 'https://example.com/order/DH123?payment=success',
  error_url: 'https://example.com/order/DH123?payment=error',
  cancel_url: 'https://example.com/order/DH123?payment=cancel',
});

return (
  <form action={checkoutURL} method="POST">
    {Object.keys(checkoutFormfields).map(field => (
      <input type="hidden" name={field} value={checkoutFormfields[field]} />
    ))}
    <button type="submit">Pay now</button>
  </form>
);

Kết quả nhận được form thanh toán (Tùy chỉnh giao diện phù hợp với hệ thống của bạn)

Payment Flow Diagram
Ví dụ form thanh toán được tạo
Khi submit form thanh toán sẽ chuyển sang cổng thanh toán của SePay

Payment Flow Diagram
Công thanh toán của SePay sau khi bạn submit form
Ghi chú
Khi kết thúc thanh toán SePay sẽ trả về các kết quả: Thành công (success_url), Thất bại (error_url) và Khách hàng hủy (cancel_url). Cần tạo các endpoint để xử lý callback từ SePay
Tạo các endpoint để nhận các callback từ SePay:
PHP
Copy
// success_url - Handle successful payment
Route::get('/payment/success', function() {
    // Show success page to customer
    return view('payment.success');
});

// error_url - Handle failed payment
Route::get('/payment/error', function() {
    // Show error page to customer
    return view('payment.error');
});

// cancel_url - Handle canceled payment
Route::get('/payment/cancel', function() {
    // Show cancel page to customer
    return view('payment.cancel');
});
Đưa các enpoint bạn đã tạo vào success_url, error_url, cancel_url lúc tạo form thanh toán

## Bước 3: Cấu hình IPN
IPN (Instant Payment Notification) là gì ?
IPN là một endpoint trên hệ thống của bạn dùng để nhận thông báo giao dịch theo thời gian thực từ cổng thanh toán SePay
Tìm hiểu thêm về IPN
Tại màn hình thông tin tích hợp đang giữ ở bước 1, điền vào endpoint IPN của bạn
Payment Flow Diagram
Tạo cấu hình IPN
Lưu cấu hình IPN
Ghi chú
Khi có giao dịch thành công SePay sẽ trả về JSON qua IPN của bạn:
IPN JSON
Copy
{
  "timestamp": 1759134682,
  "notification_type": "ORDER_PAID",
  "order": {
    "id": "e2c195be-c721-47eb-b323-99ab24e52d85",
    "order_id": "NQD-68DA43D73C1A5",
    "order_status": "CAPTURED",
    "order_currency": "VND",
    "order_amount": "100000.00",
    "order_invoice_number": "INV-1759134677",
    "custom_data": [],
    "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36",
    "ip_address": "14.186.39.212",
    "order_description": "Test payment"
  },
  "transaction": {
    "id": "384c66dd-41e6-4316-a544-b4141682595c",
    "payment_method": "BANK_TRANSFER",
    "transaction_id": "68da43da2d9de",
    "transaction_type": "PAYMENT",
    "transaction_date": "2025-09-29 15:31:22",
    "transaction_status": "APPROVED",
    "transaction_amount": "100000",
    "transaction_currency": "VND",
    "authentication_status": "AUTHENTICATION_SUCCESSFUL",
    "card_number": null,
    "card_holder_name": null,
    "card_expiry": null,
    "card_funding_method": null,
    "card_brand": null
  },
  "customer": null,
  "agreement": null
}
Tạo endpoint IPN để nhận JSON data từ SePay
Endpoint là endpoint bạn đã cấu hình trên IPN
PHP
Copy
Route::post('/payment/ipn', function(Request $request) {
    $data = $request->json()->all();

    if ($data['notification_type'] === 'ORDER_PAID') {
        $order = Order::where('invoice_number', $data['order']['order_invoice_number'])->first();
        $order->status = 'paid';
        $order->save();
    }

    // Return 200 to acknowledge receipt
    return response()->json(['success' => true], 200);
});
Bước 4: Kiểm thử
Bây giờ bạn có thể kiểm thử bằng cách tạo một đơn hàng trên form vừa tích hợp ở bước 2
Sau đó quay lại màn hình thông tin tích hợp và bấm tiếp tục để kiểm tra kết quả
Payment Flow Diagram
Kiểm tra kết quả
Kịch bản:
Khi người dùng gửi form thanh toán trên website của bạn, hệ thống sẽ chuyển hướng đến trang thanh toán của SePay.
Khi thanh toán thành công: SePay chuyển hướng về endpoint /payment/success của bạn và gửi dữ liệu cho endpoint IPN bạn đã cấu hình
Khi thanh toán thất bại: SePay chuyển hướng về endpoint /payment/error
Khi hủy thanh toán: SePay chuyển hướng về endpoint /payment/cancel