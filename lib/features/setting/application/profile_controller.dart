import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final ProfileControllerProveder = ChangeNotifierProvider<ProfileController>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  return ProfileController(user: user);
});

class ProfileController extends ChangeNotifier {
  final User? user;
  ProfileController({required this.user});

  String get displayName => user?.displayName ?? 'Anonymous';
  String get email => user?.email ?? 'email@example.com';
  String get photoUrl => user?.photoURL ?? '';

  Future<void> _uploadAndSaveImage(File file) async {
    final uid = user?.uid ?? '';
    final storageRef = FirebaseStorage.instance.ref().child('profile_images/$uid.jpg');
    await storageRef.putFile(file);
    final downloadUrl = await storageRef.getDownloadURL();

    // Update Auth & Firestore
    await user?.updatePhotoURL(downloadUrl);
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'photoUrl': downloadUrl,
      'email': user?.email,
      'displayName': user?.displayName,
    }, SetOptions(merge: true));

    await user?.reload();
    notifyListeners();
  }

  Future<void> updateProfileImageFromGallery() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) await _uploadAndSaveImage(File(picked.path));
  }

  Future<void> updateProfileImageFromCamera() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked != null) await _uploadAndSaveImage(File(picked.path));
  }

  Future<void> updateProfileImageFromFileManager() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      await _uploadAndSaveImage(File(result.files.single.path!));
    }
  }
}
