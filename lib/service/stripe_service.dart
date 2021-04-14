import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
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

Future<StripeTransactionResponse> payViaNewCard() async {
  try {
    // initialize stripe
    const publishableKey =
        'pk_test_51IflCeLOGgN8A203ILklq6uYJPxz2bB2gH1IavQ9C1SEg9sU1cCCYJRlJzt3ZbIF6jJ6zvFwebYNvHvwz4BZVOs400iX7GJNBn';
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: publishableKey,
        merchantId: 'Test',
        androidPayMode: 'test',
      ),
    );

    // create payment method
    final paymentMethod = await StripePayment.paymentRequestWithCardForm(
        CardFormPaymentRequest());

    // create payment intent
    final paymentEndpoint = Uri.https('api.stripe.com', 'v1/payments_intent');
    final body = <String, dynamic>{
      'amount': 1,
      'currency': 'JPY',
      'payment_method_types[]': 'card'
    };
    const secretKey =
        'sk_test_51IflCeLOGgN8A203RTe6H6aYhGl5drdcPpZJ9B936U3QRHCDuUUWtjQdi4Kud3HWXXpg3YJjdRrVpNem9aNYOacr00uWaWRM6p';
    final headers = {
      'Authorization': 'Bearer $secretKey',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    final response = await http.post(
      paymentEndpoint,
      headers: headers,
      body: body,
    );
    final paymentIntent = jsonDecode(response.body);

    // confirm payment intent
    final confirmResult = await StripePayment.confirmPaymentIntent(
      PaymentIntent(
        clientSecret: paymentIntent['client_secret'],
        paymentMethodId: paymentMethod.id,
      ),
    );

    // handle confirm result
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
  } on PlatformException catch (e) {
    print(e);
    return StripeTransactionResponse(
      message: 'Transaction failed: $e',
      success: true,
    );
  }
}

Future<void> payWithExistingCard() async {}
