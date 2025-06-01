import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pothole_mobile_app/features/auth/application/auth_controller.dart';

class FormLogin extends ConsumerStatefulWidget {
  const FormLogin({super.key});

  @override
  ConsumerState<FormLogin> createState() => _formLoginState();
}

class _formLoginState extends ConsumerState<FormLogin> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => isLoading = true);
    try {
      await ref.read(authControllerProvider).signInWithEmail(email, password);
      if (context.mounted) {
        context.go('/navigation');
      }
    } catch (error) {
      ScaffoldMessenger.of(
        context
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onSaved: (val) => email = val!.trim(),
                validator:
                    (val) => val!.contains('@') ? null : 'Email tidak valid',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onSaved: (val) => password = val!,
                validator:
                    (val) => val!.length >= 6 ? null : 'Minimal 6 karakter',
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    child: Text('Login'),
                    onPressed: () => _login(),
                  ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text('atau'),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          icon: const Icon(Icons.g_mobiledata),
          label: const Text('Login dengan Google'),
          onPressed: () async {
            try {
              await ref.read(authControllerProvider).signInWithGoogle();
              debugPrint('Google Sign-In Success');
              if (context.mounted) {
                context.go('/navigation');
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Google Sign-In gagal: $e')),
              );
            }
          },
        ),
      ],
    );
  }
}
