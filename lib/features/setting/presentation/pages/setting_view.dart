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
    final isDarkMode = ref.watch(themeModeProvider) == ThemeMode.dark;
    final isIndonesian = context.locale.languageCode == 'id';

    return Scaffold(
      appBar: AppBar(
        title: Text('settings.title'.tr()),
        centerTitle: true,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.only(bottom: 16),
            child: SwitchListTile.adaptive(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              title: Text('settings.darkMode'.tr(),
                  style: Theme.of(context).textTheme.titleMedium),
              secondary: const Icon(Icons.dark_mode),
              value: isDarkMode,
              onChanged: (isDark) {
                ref.read(themeModeProvider.notifier).state =
                    isDark ? ThemeMode.dark : ThemeMode.light;
              },
            ),
          ),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.only(bottom: 16),
            child: SwitchListTile.adaptive(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              title: Text('settings.language'.tr(),
                  style: Theme.of(context).textTheme.titleMedium),
              secondary: const Icon(Icons.language),
              value: isIndonesian,
              onChanged: (value) {
                context.setLocale(Locale(value ? 'id' : 'en'));
              },
            ),
          ),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text('settings.profile'.tr(),
                  style: Theme.of(context).textTheme.titleMedium),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                context.push('/profile');
              },
            ),
          ),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text('settings.about'.tr(),
                  style: Theme.of(context).textTheme.titleMedium),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                context.push('/about');
              },
            ),
          ),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: Text('settings.logout'.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.redAccent)),
              trailing: const Icon(Icons.chevron_right, color: Colors.redAccent),
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
                  ),
                );

                if (confirm == true) {
                  await ref.read(authControllerProvider).logout();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
