import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiveJourneyScreen extends StatelessWidget {
  final String userId = "CURRENT_USER_ID"; // Get this from your Auth state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your German Progress")),
      // 1. Listen to the user's document in real-time
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('Users').doc(userId).snapshots(),
        builder: (context, snapshot) {
          // 2. Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 3. Handle errors
          if (snapshot.hasError) {
            return Center(child: Text("Error loading data: ${snapshot.error}"));
          }

          // 4. Extract the unlocked modules list from the database result
          List<dynamic> unlockedModules = [];
          if (snapshot.hasData && snapshot.data!.exists) {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            unlockedModules = data['unlocked_modules'] ?? [];
          }

          // 5. Build your module list based on actual live results
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildModuleRow(
                context,
                title: "German A1.1: The Basics",
                isUnlocked: unlockedModules.contains("A1.1"), // Checks if "A1.1" exists in the array
              ),
              const SizedBox(height: 16),
              _buildModuleRow(
                context,
                title: "German A1.2: Daily Life",
                isUnlocked: unlockedModules.contains("A1.2"), // Instantly turns true when webhook finishes
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildModuleRow(BuildContext context, {required String title, required bool isUnlocked}) {
    return ListTile(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isUnlocked ? Colors.black : Colors.grey)),
      trailing: Icon(
        isUnlocked ? Icons.check_circle : Icons.lock,
        color: isUnlocked ? Colors.green : Colors.grey,
      ),
      tileColor: isUnlocked ? Colors.white : Colors.grey[100],
      onTap: () {
        if (isUnlocked) {
          // Enter the module chapters
        } else {
          // Trigger payment prompt
        }
      },
    );
  }
}
