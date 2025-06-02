import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pothole_mobile_app/features/camera/application/camera_controller.dart';

final cameraNotifierProvider =
    StateNotifierProvider<CameraNotifier, CameraState>((ref) {
      final notifier = CameraNotifier();
      notifier.initCamera();
      return notifier;
    });
