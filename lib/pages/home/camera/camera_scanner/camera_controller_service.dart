import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraControllerService {
  CameraController? controller;

  Future<bool> initialize() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) return false;

    final cameras = await availableCameras();
    controller = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await controller!.initialize();
    return true;
  }

  Future<void> toggleFlash(bool enabled) async {
    if (controller == null) return;
    await controller!.setFlashMode(enabled ? FlashMode.torch : FlashMode.off);
  }

  void dispose() {
    controller?.dispose();
  }
}
