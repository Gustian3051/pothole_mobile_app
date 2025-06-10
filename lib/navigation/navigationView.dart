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
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final pages = const [MapView(), CameraView(), SettingView()];

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24), // Rounded corners
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).bottomNavigationBarTheme.backgroundColor ?? Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) => ref.read(bottomNavIndexProvider.notifier).state = index,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: Colors.grey.shade500,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.map_outlined, size: 28),
                  activeIcon: Icon(Icons.map, size: 30),
                  label: 'bottomNavBar.map'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.camera_alt_outlined, size: 28),
                  activeIcon: Icon(Icons.camera_alt, size: 30),
                  label: 'bottomNavBar.camera'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined, size: 28),
                  activeIcon: Icon(Icons.settings, size: 30),
                  label: 'bottomNavBar.settings'.tr(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
