import 'package:flutter/material.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:uuid/uuid.dart';

class PaymentService {
  // Replace with your actual Flutterwave Public Key from your dashboard
  static const String publicKey = "FLWPUBK_TEST-YOUR_TEST_KEY_HERE-X";

  static Future<void> processUnlockFee({
    required BuildContext context,
    required String moduleId,
    required String amount,
    required String userId,
  }) async {
    // Generate a unique transaction reference prefixed with the module name
    final String txRef = "${moduleId}_${const Uuid().v1()}";

    final Customer customer = Customer(
      name: "German Student", 
      phoneNumber: "254700000000",
      email: "student@somatext.com",
    );

    final Flutterwave flutterwave = Flutterwave(
      context: context,
      publicKey: publicKey,
      currency: "KES", 
      redirectUrl: "https://your-app-callback.com",
      txRef: txRef,
      amount: amount,
      customer: customer,
      paymentOptions: "card, mpesa",
      customization: Customization(
        title: "Unlock $moduleId",
        description: "Registration fee for German $moduleId",
      ),
      isTestMode: true, // Switch to false when moving to production
    );

    try {
      final ChargeResponse response = await flutterwave.charge();
      if (response != null && response.success == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment transaction initiated successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment was not completed.')),
        );
      }
    } catch (error) {
      debugPrint("Flutterwave Integration Error: $error");
    }
  }
}
