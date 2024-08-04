import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

late List<CameraDescription> _cameras;
final cameraProvider = Provider((ref) {
  if (_cameras.isEmpty) {
    throw Exception('No cameras available 1');
  }
  return CameraController(_cameras[0], ResolutionPreset.max);
});

final cameraInitializationProvider = FutureProvider((ref) async {
  _cameras = await availableCameras();
  if (_cameras.isEmpty) {
    throw Exception('No cameras available 2');
  }
  final controller = ref.watch(cameraProvider);
  await controller.initialize();
  return controller;
});
