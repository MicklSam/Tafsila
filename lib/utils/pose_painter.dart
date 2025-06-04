import 'package:flutter/material.dart';
import 'pose_detector.dart';

class PosePainter extends CustomPainter {
  final Pose pose;
  final Size imageSize;
  final Size widgetSize;

  PosePainter({
    required this.pose,
    required this.imageSize,
    required this.widgetSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0
          ..color = Colors.blue;

    final dotPaint =
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.red;

    void drawLine(PoseLandmarkType type1, PoseLandmarkType type2) {
      final landmark1 = pose.getLandmark(type1);
      final landmark2 = pose.getLandmark(type2);

      if (landmark1 != null && landmark2 != null) {
        canvas.drawLine(
          _convertPoint(landmark1),
          _convertPoint(landmark2),
          paint,
        );
      }
    }

    // Draw body connections
    // Face
    drawLine(PoseLandmarkType.leftEar, PoseLandmarkType.leftEyeOuter);
    drawLine(PoseLandmarkType.leftEyeOuter, PoseLandmarkType.leftEye);
    drawLine(PoseLandmarkType.leftEye, PoseLandmarkType.leftEyeInner);
    drawLine(PoseLandmarkType.leftEyeInner, PoseLandmarkType.nose);
    drawLine(PoseLandmarkType.nose, PoseLandmarkType.rightEyeInner);
    drawLine(PoseLandmarkType.rightEyeInner, PoseLandmarkType.rightEye);
    drawLine(PoseLandmarkType.rightEye, PoseLandmarkType.rightEyeOuter);
    drawLine(PoseLandmarkType.rightEyeOuter, PoseLandmarkType.rightEar);
    drawLine(PoseLandmarkType.mouthLeft, PoseLandmarkType.mouthRight);

    // Body
    drawLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder);
    drawLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow);
    drawLine(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist);
    drawLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow);
    drawLine(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist);
    drawLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip);
    drawLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip);
    drawLine(PoseLandmarkType.leftHip, PoseLandmarkType.rightHip);
    drawLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee);
    drawLine(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle);
    drawLine(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee);
    drawLine(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle);

    // Draw landmarks
    for (final landmark in pose.landmarks) {
      canvas.drawCircle(_convertPoint(landmark), 3.0, dotPaint);
    }
  }

  Offset _convertPoint(PoseLandmark landmark) {
    return Offset(
      landmark.x * widgetSize.width,
      landmark.y * widgetSize.height,
    );
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.pose != pose;
  }
}
