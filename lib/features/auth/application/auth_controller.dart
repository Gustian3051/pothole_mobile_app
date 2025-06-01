import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);

final authStateProvider = StreamProvider<User?>(
  (ref) => ref.watch(firebaseAuthProvider).authStateChanges().map((user) {
    debugPrint("User login status: ${user?.email ?? 'Belum login'}");
    return user;
  }),
);

final authControllerProvider = Provider((ref) {
  return AuthController(ref);
});

class AuthController {
  final Ref ref;
  AuthController(this.ref);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signInWithEmail(String email, String password) async {
    await ref
        .read(firebaseAuthProvider)
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      debugPrint('Google Sign In failed');
      return;
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential = await ref
        .read(firebaseAuthProvider)
        .signInWithCredential(credential);
    final user = UserCredential.user;
    if (user == null) return;

    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    if (!userDoc.exists) {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': user.displayName,
        'email': user.email,
        'phone': '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Update method registerWithEmail agar menerima name dan phone
  Future<void> registerWithEmail({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final userCredential = await ref
        .read(firebaseAuthProvider)
        .createUserWithEmailAndPassword(email: email, password: password);

    // Update displayName Firebase Auth
    await userCredential.user!.updateDisplayName(name);

    // Simpan data tambahan ke Firestore
    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'uid': userCredential.user!.uid,
      'name': name,
      'email': email,
      'phone': phone,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> logout() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }
}
