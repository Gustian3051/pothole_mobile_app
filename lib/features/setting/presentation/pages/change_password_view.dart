import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pothole_mobile_app/features/setting/presentation/widgets/form_change_password.dart';

class ChangePasswordView extends ConsumerWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change Password')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: FormChangePassword(),
      )
    );
  }
}