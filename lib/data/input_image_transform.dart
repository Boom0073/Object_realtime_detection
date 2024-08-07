import 'package:camera/camera.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

InputImage getInputImage(CameraImage cameraImage, CameraDescription camera) {
  final WriteBuffer allBytes = WriteBuffer();
  for (final Plane plane in cameraImage.planes) {
    allBytes.putUint8List(plane.bytes);
  }
  final bytes = allBytes.done().buffer.asUint8List();
  final Size imageSize = Size(
    cameraImage.width.toDouble(),
    cameraImage.height.toDouble(),
  );
  final imageRotation =
      InputImageRotationValue.fromRawValue(camera.sensorOrientation);
  final inputImageFormat =
      InputImageFormatValue.fromRawValue(cameraImage.format.raw);
  final planeData = cameraImage.planes
      .map((Plane plane) => InputImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          ))
      .toList();

  final inputImageData = InputImageData(
    size: imageSize,
    imageRotation: imageRotation!,
    inputImageFormat: inputImageFormat!,
    planeData: planeData,
  );
  final inputImage = InputImage.fromBytes(
    bytes: bytes,
    inputImageData: inputImageData,
  );
  return inputImage;
}
