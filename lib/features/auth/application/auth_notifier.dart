import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pothole_mobile_app/features/auth/application/auth_controller.dart';


class AuthNotifier extends ChangeNotifier {
  final Ref ref;
  User? user;
  late final Stream<User?> _authStream;
  late final StreamSubscription<User?> _authSubscription;

  AuthNotifier(this.ref) {
    _authStream = ref.read(firebaseAuthProvider).authStateChanges();
    _authSubscription = _authStream.listen((firebaseUser) {
      user = firebaseUser;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}
