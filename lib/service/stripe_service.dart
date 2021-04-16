import 'dart:convert';
import 'package:http/http.dart' as http;

// ignore: import_of_legacy_library_into_null_safe
import 'package:stripe_payment/stripe_payment.dart';

/// 決済の結果
class StripeTransactionResponse {
  StripeTransactionResponse({
    required this.message,
    required this.success,
  });

  String message;
  bool success;
}

class StripeService {
  /// pay via new card
  Future<StripeTransactionResponse> payViaNewCard() async {
    initialize();
    // create payment method
    final paymentMethod = await StripePayment.paymentRequestWithCardForm(
      CardFormPaymentRequest(),
    );
    // StripePayment.createSourceWithParams(options);
    final paymentIntent = await createPaymentIntent();
    final confirmResult =
        await confirmPaymentIntent(paymentIntent, paymentMethod);
    return handlePaymentResult(confirmResult);
  }

  /// pay via existing card
  Future<StripeTransactionResponse> payViaExistingCard(
      CreditCard creditCard) async {
    initialize();
    final paymentMethod = await StripePayment.createPaymentMethod(
      PaymentMethodRequest(card: creditCard),
    );
    final paymentIntent = await createPaymentIntent();
    final confirmResult =
        await confirmPaymentIntent(paymentIntent, paymentMethod);
    return handlePaymentResult(confirmResult);
  }

  /// initialize stripe
  void initialize() {
    const publishableKey =
        'pk_test_51IflCeLOGgN8A203ILklq6uYJPxz2bB2gH1IavQ9C1SEg9sU1cCCYJRlJzt3ZbIF6jJ6zvFwebYNvHvwz4BZVOs400iX7GJNBn';
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: publishableKey,
        merchantId: 'Test',
        androidPayMode: 'test',
      ),
    );
  }

  /// create payment intent
  Future<dynamic> createPaymentIntent() async {
    final paymentEndpoint = Uri.https('api.stripe.com', 'v1/payment_intents');
    const secretKey =
        'sk_test_51IflCeLOGgN8A203RTe6H6aYhGl5drdcPpZJ9B936U3QRHCDuUUWtjQdi4Kud3HWXXpg3YJjdRrVpNem9aNYOacr00uWaWRM6p';

    final headers = <String, String>{
      'Authorization': 'Bearer $secretKey',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final body = <String, dynamic>{
      'amount': '2000',
      'currency': 'jpy',
      'payment_method_types[]': 'card',
    };

    final response = await http.post(
      paymentEndpoint,
      headers: headers,
      body: body,
    );

    final paymentIntent = jsonDecode(response.body);
    return paymentIntent;
  }

  /// confirm payment intent
  Future<PaymentIntentResult> confirmPaymentIntent(
      dynamic paymentIntent, PaymentMethod paymentMethod) async {
    print(paymentIntent);
    final confirmResult = await StripePayment.confirmPaymentIntent(
      PaymentIntent(
        clientSecret: paymentIntent['client_secret'],
        paymentMethodId: paymentMethod.id,
      ),
    );
    return confirmResult;
  }

  /// handle payment intent result
  StripeTransactionResponse handlePaymentResult(
      PaymentIntentResult confirmResult) {
    print(confirmResult);
    if (confirmResult.status == 'succeeded') {
      return StripeTransactionResponse(
        message: 'Transaction successful',
        success: true,
      );
    } else {
      return StripeTransactionResponse(
        message: 'Transaction failed',
        success: true,
      );
    }
  }
}
