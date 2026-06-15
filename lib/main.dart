import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/journey_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Ensure you configure Firebase for your specific project before running
  await Firebase.initializeApp(); 
  runApp(const GermanLearningApp());
}

class GermanLearningApp extends StatelessWidget {
  const GermanLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'German Learner',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: JourneyScreen(),
    );
  }
}
