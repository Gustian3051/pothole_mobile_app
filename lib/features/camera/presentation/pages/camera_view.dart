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
      return Scaffold(
        backgroundColor: Colors.black,
        body: const Center(
          child: CircularProgressIndicator(
            color: Colors.blueAccent,
            strokeWidth: 4,
          ),
        ),
      );
    }

    final size = controller.value.previewSize!;
    final deviceRatio = MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;
    final previewRatio = size.height / size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Real-Time Detection'),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: AspectRatio(
            aspectRatio: size.height / size.width,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(controller),
                CustomPaint(
                  painter: BoundingBoxPainter(state.boxes),
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.bug_report, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Detected: ${state.count}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: FloatingActionButton(
          key: ValueKey(state.isDetecting),
          onPressed: () => ref.read(cameraNotifierProvider.notifier).toggleDetection(),
          backgroundColor: state.isDetecting ? Colors.redAccent : Colors.blueAccent,
          child: Icon(state.isDetecting ? Icons.stop : Icons.play_arrow, size: 28),
          tooltip: state.isDetecting ? 'Stop Detection' : 'Start Detection',
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
