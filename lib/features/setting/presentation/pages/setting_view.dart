import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pothole_mobile_app/core/theme/theme_provider.dart';
import 'package:pothole_mobile_app/features/auth/application/auth_controller.dart';

class SettingView extends ConsumerWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('settings.title'.tr())),
      body: Column(
        children: [
          SwitchListTile(
            title: Text('settings.darkMode'.tr()),
            value: ref.watch(themeModeProvider) == ThemeMode.dark,
            onChanged: (isDark) {
              ref.read(themeModeProvider.notifier).state =
                  isDark ? ThemeMode.dark : ThemeMode.light;
            },
          ),
          SwitchListTile(
            title: Text('settings.language'.tr()),
            value: context.locale.languageCode == 'id',
            onChanged: (value) {
              context.setLocale(Locale(value ? 'id' : 'en'));
            },
          ),

          ListTile(
            // leading: const Icon(Icons.person),
            title: Text('settings.profile'.tr()),
            onTap: () {
              context.push('/profile');
            },
          ),
          ListTile(
            title: Text('settings.about'.tr()),
            onTap: () {
              context.push('/about');
            },
          ),
          ListTile(
            title: Text('settings.logout'.tr()),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('settings.logout'.tr()),
                  content: Text('settings.logoutConfirm'.tr()),
                  actions: [
                    TextButton(
                      child: Text('settings.logoutCancel'.tr()),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                    TextButton(
                      child: Text('settings.logout'.tr()),
                      onPressed: () => Navigator.pop(context, true),
                    ),
                  ],
                )
              );

              if (confirm == true) {
                await ref.read(authControllerProvider).logout();
              }
            },
          ),
        ],
      ),
    );
  }
}
