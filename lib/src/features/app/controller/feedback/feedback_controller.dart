import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final CollectionReference _messagesCollection =
  FirebaseFirestore.instance.collection('messages');

  // Track the sending state
  var isSending = false.obs;

  void sendMessage() async {
    final name = nameController.text.trim();
    final message = messageController.text.trim();
    final email = emailController.text.trim();

    if (name.isNotEmpty && message.isNotEmpty) {
      if (email.isEmpty) {
        print('Email is required if not logged in');
        return;
      }

      isSending.value = true; // Set sending state to true

      try {
        await _messagesCollection.add({
          'name': name,
          'email': email,
          'text': message,
          'timestamp': FieldValue.serverTimestamp(),
        });
        print('Message sent: $message');
        clearFields(); // Clear fields after sending the message
        Get.back(); // Close the page using GetX
      } catch (e) {
        print('Error sending message: $e');
        // Optionally, show an error message to the user
      } finally {
        isSending.value = false; // Reset sending state
      }
    } else {
      print('Name and message are required');
    }
  }

  void clearFields() {
    nameController.clear();
    messageController.clear();
    emailController.clear();
  }
}
