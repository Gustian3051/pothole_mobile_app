import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pothole_mobile_app/features/auth/application/auth_controller.dart';
import 'package:pothole_mobile_app/features/setting/application/profile_controller.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  void _showImageSourceDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Galeri"),
                onTap: () {
                  Navigator.pop(context);
                  ref
                      .read(ProfileControllerProveder)
                      .updateProfileImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Kamera"),
                onTap: () {
                  Navigator.pop(context);
                  ref
                      .read(ProfileControllerProveder)
                      .updateProfileImageFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.folder),
                title: const Text("File Manager / Drive"),
                onTap: () {
                  Navigator.pop(context);
                  ref
                      .read(ProfileControllerProveder)
                      .updateProfileImageFromFileManager();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = FirebaseAuth.instance.currentUser;
    final isGoogleLogin = user?.providerData.first.providerId == 'google.com';

    return authState.when(
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(body: Center(child: Text('Error: $err'))),
      data: (_) {
        final controller = ref.watch(ProfileControllerProveder);

        return Scaffold(
          appBar: AppBar(
            title: Text('profile.title'.tr()),
            centerTitle: true,
            elevation: 1,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () => _showImageSourceDialog(context, ref),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          controller.photoUrl.isNotEmpty
                              ? NetworkImage(controller.photoUrl)
                              : const AssetImage(
                                    'assets/images/profile-default.png',
                                  )
                                  as ImageProvider,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.edit,
                            size: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  controller.displayName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  controller.email,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.edit),
                    title: Text(
                      'profile.edit-profile'.tr(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/edit_profile'),
                  ),
                ),
                const SizedBox(height: 12),
                if (!isGoogleLogin)
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.lock),
                      title: Text(
                        'profile.change-password'.tr(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/change_password'),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
