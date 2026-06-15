import 'package:flutter/material.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:uuid/uuid.dart';

class PaymentService {
  // Replace with your actual Flutterwave Test/Live Public Key
  static const String publicKey = "FLWPUBK_TEST-YOUR_TEST_KEY_HERE-X";

  static Future<void> processUnlockFee({
    required BuildContext context,
    required String moduleId,
    required String amount,
    required String userId,
  }) async {
    final String txRef = "${moduleId}_${const Uuid().v1()}";

    final Customer customer = Customer(
      name: "Student", // In production, fetch from user profile
      phoneNumber: "254700000000",
      email: "student@example.com",
    );

    final Flutterwave flutterwave = Flutterwave(
      context: context,
      publicKey: publicKey,
      currency: "KES", 
      redirectUrl: "https://your-app.com/callback",
      txRef: txRef,
      amount: amount,
      customer: customer,
      paymentOptions: "card, mpesa",
      customization: Customization(
        title: "Unlock $moduleId",
        description: "Registration fee for German $moduleId",
      ),
      isTestMode: true, // Set to false in production
    );

    try {
      final ChargeResponse response = await flutterwave.charge();
      if (response != null && response.success == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment processing! Unlocking soon...')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment failed or cancelled.')),
        );
      }
    } catch (error) {
      debugPrint("Payment Error: $error");
    }
  }
}

