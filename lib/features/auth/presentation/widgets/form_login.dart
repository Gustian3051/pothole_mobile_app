import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pothole_mobile_app/features/auth/application/auth_controller.dart';
import 'package:pothole_mobile_app/shared/widgets/button_widget.dart';
import 'package:pothole_mobile_app/shared/widgets/custom_textformFile.dart';

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
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        // padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFormField(
                label: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                onSaved: (val) => email = val!.trim(),
                validator:
                    (val) =>
                        val != null && val.contains('@')
                            ? null
                            : 'Email tidak valid',
              ),
              CustomTextFormField(
                label: 'Password',
                icon: Icons.lock,
                isPassword: true,
                onSaved: (val) => password = val!.trim(),
                validator:
                    (val) =>
                        val != null && val.length >= 6
                            ? null
                            : 'Minimal 6 karakter',
              ),
              const SizedBox(height: 16),
              CustomButtonWidget(
                text: 'Login',
                isLoading: isLoading,
                onPressed: _login,
              ),
              const SizedBox(height: 16),
              const Text('atau'),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.g_mobiledata),
                label: const Text('Login dengan Google'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onPressed: () async {
                  try {
                    await ref.read(authControllerProvider).signInWithGoogle();
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
          ),
        ),
      ),
    );
  }
}
