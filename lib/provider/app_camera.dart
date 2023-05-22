import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

class AppCamera extends InheritedWidget {
  AppCamera({required this.cameras, required Widget child})
      : super(child: child);
  final List<CameraDescription> cameras;

  static List<CameraDescription> of(BuildContext context) {
    final appCamera = context.dependOnInheritedWidgetOfExactType<AppCamera>();
    if (appCamera != null) {
      return appCamera.cameras;
    } else {
      throw StateError('Could not find ancestor widget of type AppCamera');
    }
  }

  @override
  bool updateShouldNotify(covariant AppCamera oldWidget) => true;
}
