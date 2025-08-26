import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProChatPage extends StatelessWidget {
  final String professionalId;

  const ProChatPage({Key? key, required this.professionalId}) : super(key: key);

  Future<Map<String, dynamic>?> fetchUserData(String id) async {
    try {
      final docSnap = await FirebaseFirestore.instance
          .collection('promed')
          .doc(id)
          .get();
      if (docSnap.exists) {
        return docSnap.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: fetchUserData(professionalId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Chat'),
              backgroundColor: Colors.cyan,
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
              backgroundColor: Colors.cyan,
            ),
            body: Center(
              child: Text("Error fetching user data: ${snapshot.error}"),
            ),
          );
        }

        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
              backgroundColor: Colors.cyan,
            ),
            body: Center(
              child: Text("No data found."),
            ),
          );
        }

        final userData = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: Text('Chat with ${userData['fullName']}'),
            backgroundColor: Colors.cyan,
          ),
          body: Center(
            child: Text(
              'Chat page for ${userData['fullName']} (ID: ${userData['id']})',
              style: const TextStyle(fontSize: 18),
            ),
          ),
        );
      },
    );
  }
}
