# stripe_payment_sample

This is a sample of Stripe.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
# stripe_payment_sample

# memo

1. create payment intent
Hit `https://api.stripe.com/v1/payment_intents` and get `client_secret`

2. create payment method
payment method may be a way of payment. e.g. card, applePay, googlePay...

3. confirm payment
Confirm payment with `paymentIntent` and `paymentMethod`
