import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:object_realtime_detection_practice_first/data/input_image_transform.dart';
import 'package:object_realtime_detection_practice_first/painter/object_detector_painter.dart';
import 'package:object_realtime_detection_practice_first/provider/app_camera.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.cameras});
  final List<CameraDescription> cameras;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final CameraController _cameraController;
  late final ObjectDetector _objectDetector;
  bool _isBusy = false;
  List<DetectedObject>? _detectedObjects;
  late Size size;

  @override
  void initState() {
    super.initState();
    const DetectionMode mode = DetectionMode.stream;
    final ObjectDetectorOptions options = ObjectDetectorOptions(
      mode: mode,
      classifyObjects: true,
      multipleObjects: true,
    );
    _objectDetector = ObjectDetector(options: options);
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    _cameraController =
        CameraController(widget.cameras[0], ResolutionPreset.high);
    await _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _cameraController.startImageStream((image) {
        if (!_isBusy) {
          _isBusy = true;
          _doObjectDetectionOnFrame(image, widget.cameras[0]);
        }
      });
    });
  }

  Future<void> _doObjectDetectionOnFrame(
    CameraImage cameraImage,
    CameraDescription camera,
  ) async {
    InputImage frameImage = getInputImage(cameraImage, camera);
    _detectedObjects = await _objectDetector.processImage(frameImage);
    setState(() {
      _detectedObjects;
      _isBusy = false;
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _objectDetector.close();
    super.dispose();
  }

  Widget buildResultLayer() {
    if (_detectedObjects == null || !_cameraController.value.isInitialized) {
      return const Text('');
    }
    final Size imageSize = Size(
      _cameraController.value.previewSize!.height,
      _cameraController.value.previewSize!.width,
    );
    return CustomPaint(
      painter: ObjectDetectorPainter(
        absoluteImageSize: imageSize,
        detectedObjects: _detectedObjects,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> stackChildren = [];
    final screenSize = MediaQuery.of(context).size;
    stackChildren.add(
      Positioned(
        top: 0.0,
        left: 0.0,
        width: screenSize.width,
        height: screenSize.height,
        child: Container(
          child: _cameraController.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _cameraController.value.aspectRatio,
                  child: CameraPreview(_cameraController),
                )
              : Container(),
        ),
      ),
    );
    stackChildren.add(
      Positioned(
        top: 0.0,
        left: 0.0,
        width: screenSize.width,
        height: screenSize.height,
        child: buildResultLayer(),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Object detector"),
        backgroundColor: Colors.pinkAccent,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          color: Colors.black,
          child: Stack(
            children: stackChildren,
          ),
        ),
      ),
    );
  }
}
