
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pothole_mobile_app/features/camera/presentation/pages/camera_view.dart';
import 'package:pothole_mobile_app/features/map/presentation/pages/map_view.dart';
import 'package:pothole_mobile_app/features/setting/presentation/pages/setting_view.dart';
import 'package:pothole_mobile_app/navigation/aplication/navigation_provider.dart';
import 'package:easy_localization/easy_localization.dart';

class NavigationView extends ConsumerWidget {
  const NavigationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(
      bottomNavIndexProvider,
    ); // Menggunakan ref.watch untuk mengambil nilai bottomNavIndex
    final pages = const [MapView(), CameraView(), SettingView()];

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => ref.read(bottomNavIndexProvider.notifier).state = index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'bottomNavBar.map'.tr()), 
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'bottomNavBar.camera'.tr()),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'bottomNavBar.settings'.tr()),
        ],
      ),
    );
  }
}
