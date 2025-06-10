import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:pothole_mobile_app/features/camera/domain/bounding_box.dart';


class CameraState {
  final CameraController? controller;
  final bool isDetecting;
  final List<BoundingBox> boxes;
  final int count;

  CameraState({
    this.controller,
    this.isDetecting = false,
    this.boxes = const [],
    this.count = 0,
  });

  CameraState copyWith({
    CameraController? controller,
    bool? isDetecting,
    List<BoundingBox>? boxes,
    int? count,
  }) {
    return CameraState(
      controller: controller ?? this.controller,
      isDetecting: isDetecting ?? this.isDetecting,
      boxes: boxes ?? this.boxes,
      count: count ?? this.count,
    );
  }
}

class CameraNotifier extends StateNotifier<CameraState> {
  CameraNotifier() : super(CameraState());

  Timer? _timer;
  bool _isSending = false;

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    final controller = CameraController(cameras.first, ResolutionPreset.medium);
    await controller.initialize();
    state = state.copyWith(controller: controller);
  }

  void toggleDetection() {
    if (state.isDetecting) {
      _timer?.cancel();
      state = state.copyWith(isDetecting: false, boxes: [], count: 0);
    } else {
      _timer = Timer.periodic(const Duration(seconds: 2), (_) => _captureAndSend());
      state = state.copyWith(isDetecting: true);
    }
  }

  Future<void> _captureAndSend() async {
    final controller = state.controller;
    if (controller == null || !controller.value.isInitialized || _isSending) return;

    try {
      _isSending = true;
      final file = await controller.takePicture();
      await _sendToServer(File(file.path));
    } catch (e) {
      print("Capture error: $e");
    } finally {
      _isSending = false;
    }
  }

  Future<void> _sendToServer(File image) async {
    final uri = Uri.parse('http://10.0.175.134:5000/api/pothole');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('image', image.path));

    try {
      final response = await request.send();
      final res = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final data = jsonDecode(res.body);
        final detection = data['detection'] as List?;
        if (detection != null) {
          final decoded = await decodeImageFromList(image.readAsBytesSync());
          final newBoxes = detection.map((e) => BoundingBox.fromRawJson(e['bbox'], decoded.width, decoded.height)).toList();
          state = state.copyWith(boxes: newBoxes, count: newBoxes.length);
        }
      }
    } catch (e) {
      print("Server error: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    state.controller?.dispose();
    super.dispose();
  }
}
