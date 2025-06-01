import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pothole_mobile_app/features/setting/presentation/widgets/about_state.dart';

class AboutNotifier extends StateNotifier<AboutState> {
  AboutNotifier() : super(AboutState()) {
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    state = AboutState(
      appName: info.appName,
      version: info.version,
      buildNumber: info.buildNumber,
    );
  }
}

final aboutProvider = StateNotifierProvider<AboutNotifier, AboutState>((ref) {
  return AboutNotifier();
});
