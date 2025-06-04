import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart'
    as mlkit;

enum PoseLandmarkType {
  nose,
  leftEyeInner,
  leftEye,
  leftEyeOuter,
  rightEyeInner,
  rightEye,
  rightEyeOuter,
  leftEar,
  rightEar,
  mouthLeft,
  mouthRight,
  leftShoulder,
  rightShoulder,
  leftElbow,
  rightElbow,
  leftWrist,
  rightWrist,
  leftPinky,
  rightPinky,
  leftIndex,
  rightIndex,
  leftThumb,
  rightThumb,
  leftHip,
  rightHip,
  leftKnee,
  rightKnee,
  leftAnkle,
  rightAnkle,
  leftHeel,
  rightHeel,
  leftFootIndex,
  rightFootIndex,
}

class PoseDetector {
  bool _isInitialized = false;
  late final mlkit.PoseDetector _mlkitPoseDetector;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final options = mlkit.PoseDetectorOptions();
      _mlkitPoseDetector = mlkit.PoseDetector(options: options);
      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize pose detector: $e');
    }
  }

  Future<List<Map<String, dynamic>>> detectPose(String imagePath) async {
    if (!_isInitialized) {
      throw Exception('Pose detector not initialized');
    }

    try {
      final inputImage = mlkit.InputImage.fromFile(File(imagePath));
      final poses = await _mlkitPoseDetector.processImage(inputImage);

      if (poses.isEmpty) {
        return [];
      }

      return poses.map((pose) {
        final landmarks = <Map<String, dynamic>>[];

        for (final landmark in pose.landmarks.entries) {
          landmarks.add({
            'type': _getPoseLandmarkTypeIndex(landmark.key),
            'x': landmark.value.x,
            'y': landmark.value.y,
            'z': landmark.value.z,
            'likelihood': landmark.value.likelihood,
          });
        }

        return {
          'landmarks': landmarks,
          'score': 1.0, // ML Kit doesn't provide an overall score
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to detect pose: $e');
    }
  }

  int _getPoseLandmarkTypeIndex(mlkit.PoseLandmarkType mlkitType) {
    switch (mlkitType) {
      case mlkit.PoseLandmarkType.nose:
        return PoseLandmarkType.nose.index;
      case mlkit.PoseLandmarkType.leftEyeInner:
        return PoseLandmarkType.leftEyeInner.index;
      case mlkit.PoseLandmarkType.leftEye:
        return PoseLandmarkType.leftEye.index;
      case mlkit.PoseLandmarkType.leftEyeOuter:
        return PoseLandmarkType.leftEyeOuter.index;
      case mlkit.PoseLandmarkType.rightEyeInner:
        return PoseLandmarkType.rightEyeInner.index;
      case mlkit.PoseLandmarkType.rightEye:
        return PoseLandmarkType.rightEye.index;
      case mlkit.PoseLandmarkType.rightEyeOuter:
        return PoseLandmarkType.rightEyeOuter.index;
      case mlkit.PoseLandmarkType.leftEar:
        return PoseLandmarkType.leftEar.index;
      case mlkit.PoseLandmarkType.rightEar:
        return PoseLandmarkType.rightEar.index;
      case mlkit.PoseLandmarkType.leftMouth:
        return PoseLandmarkType.mouthLeft.index;
      case mlkit.PoseLandmarkType.rightMouth:
        return PoseLandmarkType.mouthRight.index;
      case mlkit.PoseLandmarkType.leftShoulder:
        return PoseLandmarkType.leftShoulder.index;
      case mlkit.PoseLandmarkType.rightShoulder:
        return PoseLandmarkType.rightShoulder.index;
      case mlkit.PoseLandmarkType.leftElbow:
        return PoseLandmarkType.leftElbow.index;
      case mlkit.PoseLandmarkType.rightElbow:
        return PoseLandmarkType.rightElbow.index;
      case mlkit.PoseLandmarkType.leftWrist:
        return PoseLandmarkType.leftWrist.index;
      case mlkit.PoseLandmarkType.rightWrist:
        return PoseLandmarkType.rightWrist.index;
      case mlkit.PoseLandmarkType.leftPinky:
        return PoseLandmarkType.leftPinky.index;
      case mlkit.PoseLandmarkType.rightPinky:
        return PoseLandmarkType.rightPinky.index;
      case mlkit.PoseLandmarkType.leftIndex:
        return PoseLandmarkType.leftIndex.index;
      case mlkit.PoseLandmarkType.rightIndex:
        return PoseLandmarkType.rightIndex.index;
      case mlkit.PoseLandmarkType.leftThumb:
        return PoseLandmarkType.leftThumb.index;
      case mlkit.PoseLandmarkType.rightThumb:
        return PoseLandmarkType.rightThumb.index;
      case mlkit.PoseLandmarkType.leftHip:
        return PoseLandmarkType.leftHip.index;
      case mlkit.PoseLandmarkType.rightHip:
        return PoseLandmarkType.rightHip.index;
      case mlkit.PoseLandmarkType.leftKnee:
        return PoseLandmarkType.leftKnee.index;
      case mlkit.PoseLandmarkType.rightKnee:
        return PoseLandmarkType.rightKnee.index;
      case mlkit.PoseLandmarkType.leftAnkle:
        return PoseLandmarkType.leftAnkle.index;
      case mlkit.PoseLandmarkType.rightAnkle:
        return PoseLandmarkType.rightAnkle.index;
      case mlkit.PoseLandmarkType.leftHeel:
        return PoseLandmarkType.leftHeel.index;
      case mlkit.PoseLandmarkType.rightHeel:
        return PoseLandmarkType.rightHeel.index;
      case mlkit.PoseLandmarkType.leftFootIndex:
        return PoseLandmarkType.leftFootIndex.index;
      case mlkit.PoseLandmarkType.rightFootIndex:
        return PoseLandmarkType.rightFootIndex.index;
    }
  }

  void close() {
    if (_isInitialized) {
      _mlkitPoseDetector.close();
      _isInitialized = false;
    }
  }
}

class PoseLandmark {
  final PoseLandmarkType type;
  final double x;
  final double y;
  final double z;
  final double visibility;

  PoseLandmark({
    required this.type,
    required this.x,
    required this.y,
    required this.z,
    required this.visibility,
  });

  factory PoseLandmark.fromJson(Map<String, dynamic> json) {
    return PoseLandmark(
      type: PoseLandmarkType.values[json['type'] as int],
      x: json['x'] as double,
      y: json['y'] as double,
      z: json['z'] as double,
      visibility: json['likelihood'] as double,
    );
  }
}

class Pose {
  final List<PoseLandmark> landmarks;
  final double score;

  Pose({required this.landmarks, required this.score});

  factory Pose.fromJson(Map<String, dynamic> json) {
    return Pose(
      landmarks:
          (json['landmarks'] as List)
              .map((l) => PoseLandmark.fromJson(l))
              .toList(),
      score: json['score'] as double,
    );
  }

  PoseLandmark? getLandmark(PoseLandmarkType type) {
    try {
      return landmarks.firstWhere((l) => l.type == type);
    } catch (e) {
      return null;
    }
  }
}
