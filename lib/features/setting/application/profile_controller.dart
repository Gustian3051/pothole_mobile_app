import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pothole_mobile_app/features/auth/application/auth_controller.dart';

final ProfileControllerProveder = Provider<ProfileController>((ref) {
  final firebaseUser = ref.watch(authStateProvider).asData?.value;
  return ProfileController(user: firebaseUser);
});

class ProfileController {
  final User? user;
  ProfileController({required this.user});

  String get displayName => user?.displayName ?? 'Anonymous'; 
  String get email => user?.email ?? 'email@example.com';
  String get photoUrl => user?.photoURL ?? '';
}