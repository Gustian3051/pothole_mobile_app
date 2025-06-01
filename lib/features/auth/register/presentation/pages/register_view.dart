import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; 
import 'package:pothole_mobile_app/features/auth/register/presentation/widgets/form_register.dart';

class RegisterView extends ConsumerWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrasi')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: FormRegister(),
      ),
      bottomNavigationBar: TextButton(
        child: const Text('Sudah punya akun? Login'),
        onPressed: () {
          context.go('/login'); // ⬅️ Gunakan ini untuk GoRouter
        },
      ),
    );
  }
}
