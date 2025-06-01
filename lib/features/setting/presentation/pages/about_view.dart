import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pothole_mobile_app/features/setting/application/about_notifier.dart'; // sesuaikan dengan path kamu
import 'package:easy_localization/easy_localization.dart';

class AboutView extends ConsumerWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final about = ref.watch(aboutProvider);

    return Scaffold(
      appBar: AppBar(title: Text('about.title'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(Icons.info_outline, size: 80, color: Colors.blue),
            const SizedBox(height: 16),
            Text(
              about.appName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'about.version'.tr(args: [about.version, about.buildNumber]),
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Text(
              'about.description'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            const Divider(),
            Text(
              'about.contact'.tr(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('support@example.com'),
              onTap: () {
                // TODO: Buka email app
              },
            ),
            ListTile(
              leading: const Icon(Icons.link),
              title: Text('about.website'.tr()),
              subtitle: const Text('https://pothole.app'),
              onTap: () {
                // TODO: Buka link dengan url_launcher
              },
            ),
          ],
        ),
      ),
    );
  }
}
