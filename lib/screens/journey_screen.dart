import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/module_model.dart';
import '../services/payment_service.dart';

class JourneyScreen extends StatelessWidget {
  // Hardcoded for testing. In production, get from FirebaseAuth.
  final String currentUserId = "test_user_123"; 

  final List<GermanModule> curriculum = [
    GermanModule(id: "A1.1", title: "German A1.1", description: "The Basics", price: 100),
    GermanModule(id: "A1.2", title: "German A1.2", description: "Daily Life", price: 100),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("German A1 Course")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('Users').doc(currentUserId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          List<dynamic> unlockedModules = [];
          if (snapshot.hasData && snapshot.data!.exists) {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            unlockedModules = data['unlocked_modules'] ?? [];
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: curriculum.length,
            itemBuilder: (context, index) {
              final module = curriculum[index];
              final isUnlocked = unlockedModules.contains(module.id);
              return _buildModuleCard(context, module, isUnlocked);
            },
          );
        },
      ),
    );
  }

  Widget _buildModuleCard(BuildContext context, GermanModule module, bool isUnlocked) {
    return Card(
      elevation: isUnlocked ? 4 : 0,
      color: isUnlocked ? Colors.white : Colors.grey[200],
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        title: Text(
          module.title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isUnlocked ? Colors.black : Colors.grey),
        ),
        subtitle: Text(module.description),
        trailing: Icon(isUnlocked ? Icons.play_circle_fill : Icons.lock, color: isUnlocked ? Colors.green : Colors.grey, size: 32),
        onTap: () {
          if (isUnlocked) {
            // Navigate to chapter list
            print("Navigate to ${module.id} chapters");
          } else {
            _showPaymentPrompt(context, module);
          }
        },
      ),
    );
  }

  void _showPaymentPrompt(BuildContext context, GermanModule module) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Unlock ${module.title}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text("Unlock all grammar, vocabulary, and quizzes for ${module.price} KES."),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size.infinity, padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: () {
                  Navigator.pop(context);
                  PaymentService.processUnlockFee(
                    context: context,
                    moduleId: module.id,
                    amount: module.price.toString(),
                    userId: currentUserId,
                  );
                },
                child: Text("Pay ${module.price} to Unlock"),
              )
            ],
          ),
        );
      },
    );
  }
}
