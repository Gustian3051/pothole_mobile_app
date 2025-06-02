import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pothole_mobile_app/features/camera/application/camera_provider.dart';
import 'package:pothole_mobile_app/features/camera/presentation/pages/bounding_box_painter.dart';

class CameraView extends ConsumerWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cameraNotifierProvider);
    final controller = state.controller;

    if (controller == null || !controller.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final size = controller.value.previewSize!;
    final width = size.height;
    final height = size.width;

    return Scaffold(
      appBar: AppBar(title: const Text('Real-Time Detection')),
      body: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: width,
            height: height,
            child: Stack(
              children: [
                CameraPreview(controller),
                CustomPaint(size: Size(width, height), painter: BoundingBoxPainter(state.boxes)),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    color: Colors.black45,
                    padding: const EdgeInsets.all(6),
                    child: Text('Detected: ${state.count}', style: const TextStyle(color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(cameraNotifierProvider.notifier).toggleDetection(),
        child: Icon(state.isDetecting ? Icons.stop : Icons.play_arrow),
      ),
    );
  }
}
