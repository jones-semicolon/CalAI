import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../api/food_api.dart';
import '../scanner_info/info_widget.dart';
import 'scan_mode.dart';
import 'camera_controller_service.dart';
import 'scan_processors.dart';
import 'image_cropper.dart';

import 'controls/action_button.dart';
import 'controls/circle_button.dart';
import 'overlay/scan_frame_overlay.dart';
import 'utils/preview_rect_utils.dart';

class CameraScannerWidget extends StatefulWidget {
  final ValueChanged<XFile>? onImageCaptured;
  final ValueChanged<XFile>? onGalleryPicked;
  final ValueChanged<String>? onBarcodeCaptured;
  final ValueChanged<String>? onFoodLabelCaptured;

  const CameraScannerWidget({
    super.key,
    this.onImageCaptured,
    this.onGalleryPicked,
    this.onBarcodeCaptured,
    this.onFoodLabelCaptured,
  });

  @override
  State<CameraScannerWidget> createState() => _CameraScannerWidgetState();
}

class _CameraScannerWidgetState extends State<CameraScannerWidget> {
  final _cameraService = CameraControllerService();
  final _processors = ScanProcessors();

  bool _ready = false;
  bool _flashOn = false;

  ScanMode _mode = ScanMode.scanFood;
  Rect? _normalizedFrame;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final ok = await _cameraService.initialize();
    if (mounted && ok) {
      setState(() => _ready = true);
    }
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  Future<void> _toggleFlash() async {
    _flashOn = !_flashOn;
    await _cameraService.toggleFlash(_flashOn);
    setState(() {});
  }

  Future<void> _takePicture() async {
    final controller = _cameraService.controller;
    if (controller == null || !controller.value.isInitialized) return;

    final raw = await controller.takePicture();
    XFile image = raw;

    if (_mode != ScanMode.gallery && _normalizedFrame != null) {
      final cropped = await ImageCropper.cropToFrame(raw, _normalizedFrame!);
      if (cropped != null) image = cropped;
    }

    switch (_mode) {
      case ScanMode.barcode:
        final code = await _processors.scanBarcode(image);
        if (code != null && code.isNotEmpty) {
          // debugPrint('Barcode data: $code');
          widget.onBarcodeCaptured?.call(code);
        }
        break;

      case ScanMode.foodLabel:
        final rawText = await _processors.scanText(image);
        if (rawText != null && rawText.trim().isNotEmpty) {
          // 1. Split by lines
          List<String> lines = rawText.split('\n');

          // 2. Filter out generic "noise" words that mess up search results
          final noiseWords = ['natural', 'ingredients', 'organic', 'serving', 'suggestion'];

          String optimizedQuery = lines
              .map((l) => l.trim())
              .where((l) => l.length > 2) // Ignore tiny fragments
              .where((l) => !noiseWords.contains(l.toLowerCase())) // Filter noise
              .take(3) // Take the first 3 relevant lines (Brand, Type, Flavor)
              .join(' ');

          debugPrint('Optimized Query: $optimizedQuery');

          if (optimizedQuery.isNotEmpty) {
            widget.onFoodLabelCaptured?.call(optimizedQuery);
          }
        }
        break;

      case ScanMode.scanFood:
        // APIpost: send image only here.
        // await _postToApi(image: image);
        widget.onImageCaptured?.call(image);
        break;

      case ScanMode.gallery:
        break;
    }
  }

  // Sample API method (placeholder):
  // Future<void> _postToApi({
  //   required XFile image,
  //   String? barcode,
  //   String? label,
  // }) async {
  //   // APIpost: build multipart/form-data and POST to your endpoint.
  // }

  Future<void> _openGallery() async {
    final status = await Permission.photos.request();
    if (!(status.isGranted || status.isLimited)) return;

    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) widget.onGalleryPicked?.call(file);
  }

  void _showInfo() {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const BestScanningPracticesScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = _cameraService.controller;

    return Stack(
      children: [
        // CAMERA
        if (_ready && controller != null)
          Positioned.fill(child: CameraPreview(controller))
        else
          const Center(child: CircularProgressIndicator()),

        // FRAME OVERLAY
        LayoutBuilder(
          builder: (context, constraints) {
            final screen = constraints.biggest;

            final frame = PreviewRectUtils.calculateFrame(
              screen: screen,
              mode: _mode,
              safePadding: MediaQuery.of(context).padding,
            );
            final labelTop = (frame.top - 32).clamp(0.0, frame.top);

            final previewRect = PreviewRectUtils.previewRect(
              controller,
              screen,
            );

            if (previewRect != null) {
              _normalizedFrame = PreviewRectUtils.normalize(frame, previewRect);
            }

            return Stack(
              children: [
                ScanFrameOverlay(frame: frame, mode: _mode),
                if (_mode == ScanMode.barcode)
                  Positioned(
                    top: labelTop,
                    left: 0,
                    right: 0,
                    child: const IgnorePointer(
                      child: Center(
                        child: Text(
                          'Barcode Scanner',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),

        // TOP
        Positioned(
          top: 30,
          left: 16,
          child: CircleButton(
            icon: Icons.close,
            onTap: () => Navigator.pop(context),
          ),
        ),
        Positioned(
          top: 30,
          right: 16,
          child: CircleButton(icon: Icons.info_outline, onTap: _showInfo),
        ),

        // BOTTOM
        Positioned(
          bottom: 40,
          left: 12,
          right: 12,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ActionButton(
                      label: 'Scan Food',
                      icon: Icons.center_focus_strong,
                      selected: _mode == ScanMode.scanFood,
                      onTap: () => setState(() => _mode = ScanMode.scanFood),
                    ),
                  ),
                  Expanded(
                    child: ActionButton(
                      label: 'Barcode',
                      icon: Icons.qr_code,
                      selected: _mode == ScanMode.barcode,
                      onTap: () => setState(() => _mode = ScanMode.barcode),
                    ),
                  ),
                  Expanded(
                    child: ActionButton(
                      label: 'Food Label',
                      icon: Icons.local_offer,
                      selected: _mode == ScanMode.foodLabel,
                      onTap: () => setState(() => _mode = ScanMode.foodLabel),
                    ),
                  ),
                  Expanded(
                    child: ActionButton(
                      label: 'Gallery',
                      icon: Icons.image,
                      selected: _mode == ScanMode.gallery,
                      onTap: () {
                        setState(() => _mode = ScanMode.gallery);
                        _openGallery();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleButton(
                    icon: _flashOn ? Icons.flash_on : Icons.flash_off,
                    onTap: _toggleFlash,
                  ),
                  GestureDetector(
                    onTap: _takePicture,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
