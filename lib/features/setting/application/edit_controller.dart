import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

// Controller class
class EditProfileController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isInitialized = false;

  Future<void> loadUserData(WidgetRef ref, Future<Map<String, dynamic>> future) async {
    final userData = await future;
    nameController.text = userData['name'] ?? '';
    phoneController.text = userData['phone'] ?? '';
    isInitialized = true;
  }

  Future<void> saveProfile(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': nameController.text,
        'phone': phoneController.text,
      });

      if (context.mounted) {
        Navigator.pop(context); // Remove loading
        Navigator.pop(context); // Back to previous screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('edit-profile.message-save-success'.tr())),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${'edit-profile.message-save-failed'.tr()}: $e')),
      );
    }
  }

  void dispose() {
    nameController.dispose();
    phoneController.dispose();
  }
}

// Riverpod provider untuk controller
final editProfileControllerProvider = Provider<EditProfileController>((ref) {
  final controller = EditProfileController();
  ref.onDispose(() => controller.dispose());
  return controller;
});
