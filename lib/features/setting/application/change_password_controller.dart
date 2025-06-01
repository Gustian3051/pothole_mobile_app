import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final changePasswordControllerProvder = Provider((ref) {
  return ChangePassowordController();
});

class ChangePassowordController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw Exception('User not logged in');
    }

    if (user.providerData.first.providerId != 'password') {
      throw Exception(
        'Akun ini tidak bisa ubah password karena login pakai Google',
      );
    }

    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );
    try {
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw Exception('Current password is incorrect');
      } else {
        throw Exception('Failed to change password: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }
}
