import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pothole_mobile_app/features/auth/application/auth_controller.dart';
import 'package:pothole_mobile_app/features/auth/login/presentation/widgets/form_login.dart';
import 'package:pothole_mobile_app/navigation/aplication/navigation_provider.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          Future.microtask(() {
            ref.read(bottomNavIndexProvider.notifier).state = 1;
            context.go('/navigation');
          });

          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Login View')),
          body: Column(
            children: [
              const FormLogin(),
              TextButton(
                child: const Text('Belum punya akun? Daftar'),
                onPressed: () {
                  context.go('/register');
                },
              ),
            ],
          ),
        );
      },
      error: (e, _) => Center(child: Text('Error: $e')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
