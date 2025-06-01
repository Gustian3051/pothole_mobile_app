import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pothole_mobile_app/features/auth/application/auth_controller.dart';
import 'package:pothole_mobile_app/features/setting/application/profile_controller.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    final user = FirebaseAuth.instance.currentUser;
    final isGoogleLogin = user?.providerData.first.providerId == 'google.com';

    return authState.when(
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
      data: (_) {
        final controller = ref.watch(ProfileControllerProveder);

        return Scaffold(
          appBar: AppBar(title: Text('profile.title'.tr())),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      // ignore: unnecessary_null_comparison
                      controller.photoUrl != null
                          ? NetworkImage(controller.photoUrl)
                          : const AssetImage(
                                'assets/images/profile-default.png',
                              )
                              as ImageProvider,
                ),
                const SizedBox(height: 16),
                Text(
                  controller.displayName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.email,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: Text('profile.edit-profile'.tr()),
                  onTap: () => context.push('/edit_profile'),
                ),
                if (!isGoogleLogin)
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: Text('profile.change-password'.tr()),
                    onTap: () {
                      context.push('/change_password');
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
