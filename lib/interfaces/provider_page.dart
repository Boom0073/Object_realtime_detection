import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:object_realtime_detection_practice_first/interfaces/home_page.dart';
import 'package:object_realtime_detection_practice_first/provider/app_camera.dart';

class ProviderPage extends StatelessWidget {
  const ProviderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CameraDescription> cameras = AppCamera.of(context);
    return HomePage(
      cameras: cameras,
    );
  }
}
