import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

class ObjectDetectorPainter extends CustomPainter {
  ObjectDetectorPainter({
    required this.absoluteImageSize,
    this.detectedObjects,
  });
  final Size absoluteImageSize;
  final List<DetectedObject>? detectedObjects;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    final Paint paint = Paint()
      ..strokeWidth = 2
      ..color = Colors.pinkAccent
      ..style = PaintingStyle.stroke;

    if (detectedObjects != null) {
      for (final DetectedObject object in detectedObjects!) {
        canvas.drawRect(
          Rect.fromLTRB(
            object.boundingBox.left * scaleX,
            object.boundingBox.top * scaleY,
            object.boundingBox.right * scaleX,
            object.boundingBox.bottom * scaleY,
          ),
          paint,
        );
        final List<Label> objectLabels = object.labels;
        for (final Label objectLabel in objectLabels) {
          final TextSpan textSpan = TextSpan(
            text: objectLabel.text,
            style: const TextStyle(fontSize: 25, color: Colors.blue),
          );
          final TextPainter textPainter = TextPainter(
            text: textSpan,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
          );
          textPainter.layout();
          textPainter.paint(
              canvas,
              Offset(
                object.boundingBox.left * scaleX,
                object.boundingBox.top * scaleY,
              ));
          break;
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant ObjectDetectorPainter oldDelegate) =>
      oldDelegate.detectedObjects != detectedObjects;
}
