# German Learning App

A progression-based A1 German app with module unlocking and integrated payments.

## Getting Started

1. Run `flutter pub get` to install dependencies.
2. Initialize Firebase using the FlutterFire CLI: `flutterfire configure`.
3. Update `lib/services/payment_service.dart` with your Flutterwave Test Key.
4. Deploy your backend webhooks: `cd functions && firebase deploy --only functions`.
5. Run the app: `flutter run`.
