import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:object_realtime_detection_practice_first/interfaces/home_page.dart';
import 'package:object_realtime_detection_practice_first/interfaces/provider_page.dart';
import 'package:object_realtime_detection_practice_first/provider/app_camera.dart';

late List<CameraDescription> cameras;
Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AppCamera(
        cameras: cameras,
        child: const ProviderPage(),
      ),
    );
  }
}
