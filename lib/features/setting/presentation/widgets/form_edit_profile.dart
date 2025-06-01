import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pothole_mobile_app/features/setting/application/edit_controller.dart';
import 'package:easy_localization/easy_localization.dart';

// Provider data user
final userDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) throw Exception("edit-profile.userDataProvider".tr());

  final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  return doc.data() ?? {};
});

class FormEditProfile extends ConsumerWidget {
  const FormEditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDataAsync = ref.watch(userDataProvider);
    final controller = ref.watch(editProfileControllerProvider);

    return userDataAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
      data: (userData) {
        if (!controller.isInitialized) {
          controller.nameController.text = userData['name'] ?? '';
          controller.phoneController.text = userData['phone'] ?? '';
          controller.isInitialized = true;
        }

        return Form(
          key: controller.formKey,
          child: Column(
            children: [
              TextFormField(
                controller: controller.nameController,
                decoration: InputDecoration(labelText: 'edit-profile.name'.tr()),
                validator: (value) =>
                    value == null || value.isEmpty ? 'edit-profile.name-validate'.tr() : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.phoneController,
                decoration: InputDecoration(labelText: 'edit-profile.phone'.tr()),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value == null || value.isEmpty ? 'edit-profile.phone-validate'.tr() : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => controller.saveProfile(context),
                child: Text('edit-profile.save'.tr()),
              ),
            ],
          ),
        );
      },
    );
  }
}
