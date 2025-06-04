import 'dart:math';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../utils/pose_detector.dart';
import '../utils/pose_painter.dart';
import '../utils/user_data.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;
  final double userHeight;
  final double userWeight;

  const CameraScreen({
    super.key,
    required this.camera,
    required this.userHeight,
    required this.userWeight,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final _poseDetector = PoseDetector();
  Pose? detectedPose;
  bool isProcessing = false;
  Map<String, Map<String, String>> clothingSizes = {};
  double conversionFactor = 0.0;
  String? errorMessage;
  Size? imageSize;
  Map<String, double>? measurements;
  bool _showInstructions = false;

  @override
  void initState() {
    super.initState();
    _initializeDetector();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    _initializeControllerFuture = _controller.initialize().then((_) {
      if (mounted) setState(() {});
    });
  }

  Future<void> _initializeDetector() async {
    try {
      await _poseDetector.initialize();
    } catch (e) {
      setState(() {
        errorMessage = 'خطأ في تهيئة نظام كشف الأشخاص: $e';
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _poseDetector.close();
    super.dispose();
  }

  Future<void> _processImage(XFile imageFile) async {
    if (isProcessing) return;
    setState(() {
      isProcessing = true;
      errorMessage = null;
      measurements = null;
    });

    try {
      final poseResults = await _poseDetector.detectPose(imageFile.path);
      if (poseResults.isEmpty) {
        setState(() {
          errorMessage = 'Image not accurate';
          detectedPose = null;
        });
        return;
      }

      final pose = Pose.fromJson(poseResults[0]);
      setState(() {
        detectedPose = pose;
      });

      try {
        final newMeasurements = _calculateBodyMeasurements(pose);
        _determineClothingSizes(newMeasurements);
        setState(() {
          measurements = newMeasurements;
        });
      } catch (e) {
        setState(() {
          errorMessage = 'Image not accurate';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Image not accurate';
      });
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  void _resetMeasurements() {
    setState(() {
      detectedPose = null;
      clothingSizes.clear();
      errorMessage = null;
      measurements = null;
    });
  }

  void _navigateToHome() {
    if (measurements != null && clothingSizes.isNotEmpty) {
      // Save measurements before navigating
      UserData.saveMeasurements(measurements!, clothingSizes);
    }
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(child: CameraPreview(_controller));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),

          // Top Bar
          SafeArea(
            child: Column(
              children: [
                // Back and Info Buttons
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: _navigateToHome,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.info_outline,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _showInstructions = !_showInstructions;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                // Sliding Instructions Panel
                if (_showInstructions)
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, -50 * (1 - value)),
                        child: Opacity(
                          opacity: value,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 24),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'How to Take the Photo',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '• Stand straight facing the camera\n'
                                  '• Keep your arms slightly away from your body\n'
                                  '• Make sure your whole body is visible\n'
                                  '• Wear fitted clothing for accurate measurements',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),

          // Error Message Dialog
          if (errorMessage != null)
            Center(
              child: Container(
                margin: const EdgeInsets.all(32),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No Person Detected',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Make sure your full body is visible in the frame',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            errorMessage = null;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Try Again',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Results Dialog
          if (measurements != null)
            Center(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.blue[400],
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Key Measurements',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'You can save info or make new scan',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Measurements
                    _buildMeasurementRow(
                      'Bust',
                      measurements!['chestCircumference'],
                    ),
                    _buildMeasurementRow(
                      'Waist',
                      measurements!['waistCircumference'],
                    ),
                    _buildMeasurementRow(
                      'Hips',
                      measurements!['hipCircumference'],
                    ),
                    _buildMeasurementRow('Inseam', measurements!['inseam']),
                    _buildMeasurementRow(
                      'Shoulders',
                      measurements!['shoulderWidth'],
                    ),
                    _buildMeasurementRow(
                      'Arm Length',
                      measurements!['armLength'],
                    ),
                    const SizedBox(height: 24),
                    // Size Results
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              _buildSizeCard(
                                'T-shirt',
                                clothingSizes['t_shirt']?['size'] ?? '',
                                clothingSizes['t_shirt']?['fit'] ?? '',
                              ),
                              const SizedBox(height: 8),
                              _buildSizeCard(
                                'Jacket',
                                clothingSizes['jacket']?['size'] ?? '',
                                clothingSizes['jacket']?['fit'] ?? '',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            children: [
                              _buildSizeCard(
                                'Shirt',
                                clothingSizes['shirt']?['size'] ?? '',
                                clothingSizes['shirt']?['fit'] ?? '',
                              ),
                              const SizedBox(height: 8),
                              _buildSizeCard(
                                'Pants',
                                clothingSizes['pants']?['size'] ?? '',
                                clothingSizes['pants']?['fit'] ?? '',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _resetMeasurements,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[50],
                              foregroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text('Rescan'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _navigateToHome,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        backgroundColor: Colors.white,
        child: const Icon(Icons.camera_alt, color: Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildMeasurementRow(String label, double? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value != null ? '${value.toStringAsFixed(1)} cm' : '[XX cm]',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeCard(String type, String size, String fit) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Text(type),
          Text(
            'Size: $size',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('Fit: $fit', style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      imageSize = await _getImageSize(image.path);
      await _processImage(image);
    } catch (e) {
      setState(() {
        errorMessage =
            'An error occurred while capturing the image. Please try again.';
      });
    }
  }

  IconData _getClothingIcon(String type) {
    switch (type) {
      case 't_shirt':
        return Icons.dry_cleaning;
      case 'shirt':
        return Icons.checkroom;
      case 'jacket':
        return Icons.style;
      case 'pants':
        return Icons.accessibility_new;
      default:
        return Icons.checkroom;
    }
  }

  Future<Size> _getImageSize(String imagePath) async {
    final file = File(imagePath);
    final bytes = await file.readAsBytes();
    final image = await decodeImageFromList(bytes);
    return Size(image.width.toDouble(), image.height.toDouble());
  }

  Map<String, double> _calculateBodyMeasurements(Pose pose) {
    // Basic landmarks
    final leftShoulder = pose.getLandmark(PoseLandmarkType.leftShoulder);
    final rightShoulder = pose.getLandmark(PoseLandmarkType.rightShoulder);
    final leftHip = pose.getLandmark(PoseLandmarkType.leftHip);
    final rightHip = pose.getLandmark(PoseLandmarkType.rightHip);
    final leftElbow = pose.getLandmark(PoseLandmarkType.leftElbow);
    final rightElbow = pose.getLandmark(PoseLandmarkType.rightElbow);
    final leftWrist = pose.getLandmark(PoseLandmarkType.leftWrist);
    final rightWrist = pose.getLandmark(PoseLandmarkType.rightWrist);
    final leftKnee = pose.getLandmark(PoseLandmarkType.leftKnee);
    final rightKnee = pose.getLandmark(PoseLandmarkType.rightKnee);
    final leftAnkle = pose.getLandmark(PoseLandmarkType.leftAnkle);
    final rightAnkle = pose.getLandmark(PoseLandmarkType.rightAnkle);
    final nose = pose.getLandmark(PoseLandmarkType.nose);
    final leftHeel = pose.getLandmark(PoseLandmarkType.leftHeel);
    final rightHeel = pose.getLandmark(PoseLandmarkType.rightHeel);

    // Additional landmarks for better accuracy
    final leftEar = pose.getLandmark(PoseLandmarkType.leftEar);
    final rightEar = pose.getLandmark(PoseLandmarkType.rightEar);
    final leftEye = pose.getLandmark(PoseLandmarkType.leftEye);
    final rightEye = pose.getLandmark(PoseLandmarkType.rightEye);
    final leftPinky = pose.getLandmark(PoseLandmarkType.leftPinky);
    final rightPinky = pose.getLandmark(PoseLandmarkType.rightPinky);
    final leftIndex = pose.getLandmark(PoseLandmarkType.leftIndex);
    final rightIndex = pose.getLandmark(PoseLandmarkType.rightIndex);

    // Null checks for all landmarks
    if (leftShoulder == null ||
        rightShoulder == null ||
        leftHip == null ||
        rightHip == null ||
        leftElbow == null ||
        rightElbow == null ||
        leftWrist == null ||
        rightWrist == null ||
        leftKnee == null ||
        rightKnee == null ||
        leftAnkle == null ||
        rightAnkle == null ||
        nose == null ||
        leftHeel == null ||
        rightHeel == null ||
        leftEar == null ||
        rightEar == null ||
        leftEye == null ||
        rightEye == null ||
        leftPinky == null ||
        rightPinky == null ||
        leftIndex == null ||
        rightIndex == null) {
      throw Exception('Missing required landmarks');
    }

    // New waist-specific landmarks (after null checks)
    final leftWaistPoint = _interpolatePoint(
      leftShoulder,
      leftHip,
      0.6,
      PoseLandmarkType.leftHip,
    );
    final rightWaistPoint = _interpolatePoint(
      rightShoulder,
      rightHip,
      0.6,
      PoseLandmarkType.rightHip,
    );
    final frontWaistPoint = _interpolatePoint(
      leftWaistPoint,
      rightWaistPoint,
      0.5,
      PoseLandmarkType.nose, // Using nose type as a generic center point
    );

    // Calculate mid-points for better waist estimation
    final midLeftTorso = _interpolatePoint(
      leftShoulder,
      leftHip,
      0.5,
      PoseLandmarkType.leftHip,
    );
    final midRightTorso = _interpolatePoint(
      rightShoulder,
      rightHip,
      0.5,
      PoseLandmarkType.rightHip,
    );

    // Calculate height and conversion factor first
    double heightPixels = _calculateEnhancedHeight(
      nose,
      leftEye,
      rightEye,
      leftEar,
      rightEar,
      leftHeel,
      rightHeel,
    );

    // Calculate raw measurements (in pixels)
    double shoulderWidth = _distanceBetween(leftShoulder, rightShoulder);
    double chestWidth = _calculateEnhancedChestWidth(
      leftShoulder,
      rightShoulder,
      leftHip,
      rightHip,
    );
    double waistWidth = _calculateEnhancedWaistWidth(
      leftHip,
      rightHip,
      leftWaistPoint,
      rightWaistPoint,
      midLeftTorso,
      midRightTorso,
      leftElbow,
      rightElbow,
    );

    // Enhanced hip width calculation
    double hipWidth = _calculateEnhancedHipWidth(leftHip, rightHip);
    print('Hip measurements (pixels):');
    print('Raw hip width: $hipWidth');
    print('Converted hip width: ${hipWidth * conversionFactor}');

    double armLength = _calculateArmLength(
      leftShoulder,
      leftElbow,
      leftWrist,
      leftPinky,
      rightShoulder,
      rightElbow,
      rightWrist,
      rightPinky,
    );
    double inseam = _calculateInseam(leftHip, leftKnee, leftAnkle);

    // Ensure hip circumference is larger than waist
    double waistCirc = _calculateEnhancedEllipticalCircumference(
      waistWidth * conversionFactor,
      (waistWidth * 0.6) * conversionFactor,
    );

    double hipCirc = _calculateEnhancedEllipticalCircumference(
      hipWidth * conversionFactor,
      (hipWidth * 0.75) * conversionFactor, // Increased depth ratio for hips
    );

    // Adjust hip circumference if it's smaller than waist
    if (hipCirc <= waistCirc) {
      hipCirc = waistCirc * 1.15; // Make hips at least 15% larger than waist
    }

    return {
      'shoulderWidth': shoulderWidth * conversionFactor,
      'chestCircumference': _calculateEnhancedEllipticalCircumference(
        chestWidth * conversionFactor,
        (chestWidth * 0.7) * conversionFactor,
      ),
      'waistCircumference': waistCirc,
      'hipCircumference': hipCirc,
      'armLength': armLength * conversionFactor,
      'inseam': inseam * conversionFactor,
    };
  }

  // New enhanced calculation methods
  double _calculateEnhancedHeight(
    PoseLandmark nose,
    PoseLandmark leftEye,
    PoseLandmark rightEye,
    PoseLandmark leftEar,
    PoseLandmark rightEar,
    PoseLandmark leftHeel,
    PoseLandmark rightHeel,
  ) {
    // Use the highest point among head landmarks
    double topY = min(
      min(nose.y, min(leftEye.y, rightEye.y)),
      min(leftEar.y, rightEar.y),
    );
    // Use the lowest point among heel landmarks
    double bottomY = max(leftHeel.y, rightHeel.y);
    double heightPixels = bottomY - topY;

    // Print debug information
    print('Height calculation:');
    print('Top Y: $topY');
    print('Bottom Y: $bottomY');
    print('Height in pixels: $heightPixels');
    print('User height in cm: ${widget.userHeight}');

    // Calculate and store conversion factor
    if (heightPixels > 0) {
      conversionFactor = widget.userHeight / heightPixels;
      print('Conversion factor: $conversionFactor');
    } else {
      print('Error: Height in pixels is zero or negative');
      conversionFactor = 1.0;
    }

    return heightPixels;
  }

  double _calculateEnhancedShoulderWidth(
    PoseLandmark leftShoulder,
    PoseLandmark rightShoulder,
    PoseLandmark leftElbow,
    PoseLandmark rightElbow,
  ) {
    double directWidth = (rightShoulder.x - leftShoulder.x).abs();
    double elbowWidth = (rightElbow.x - leftElbow.x).abs();
    // Use weighted average favoring direct shoulder measurement
    return (directWidth * 0.7) + (elbowWidth * 0.3);
  }

  double _calculateArmLength(
    PoseLandmark leftShoulder,
    PoseLandmark leftElbow,
    PoseLandmark leftWrist,
    PoseLandmark leftPinky,
    PoseLandmark rightShoulder,
    PoseLandmark rightElbow,
    PoseLandmark rightWrist,
    PoseLandmark rightPinky,
  ) {
    double leftArmLength = _calculateLimbLength(
      leftShoulder,
      leftElbow,
      leftWrist,
      leftPinky,
    );
    double rightArmLength = _calculateLimbLength(
      rightShoulder,
      rightElbow,
      rightWrist,
      rightPinky,
    );
    return (leftArmLength + rightArmLength) / 2;
  }

  double _calculateLimbLength(
    PoseLandmark point1,
    PoseLandmark point2,
    PoseLandmark point3,
    PoseLandmark point4,
  ) {
    double length1 = _calculateDistance(point1, point2);
    double length2 = _calculateDistance(point2, point3);
    double length3 = _calculateDistance(point3, point4);
    return length1 + length2 + length3;
  }

  double _calculateDistance(PoseLandmark point1, PoseLandmark point2) {
    double dx = point2.x - point1.x;
    double dy = point2.y - point1.y;
    double dz = point2.z - point1.z;
    return sqrt(dx * dx + dy * dy + dz * dz);
  }

  double _calculateInseam(
    PoseLandmark hip,
    PoseLandmark knee,
    PoseLandmark ankle,
  ) {
    return _calculateLimbLength(hip, knee, ankle, ankle);
  }

  double _calculateOutseam(
    PoseLandmark hip,
    PoseLandmark knee,
    PoseLandmark ankle,
    PoseLandmark heel,
  ) {
    return _calculateLimbLength(hip, knee, ankle, heel);
  }

  double _calculateEnhancedEllipticalCircumference(double width, double depth) {
    // Using Ramanujan's approximation for ellipse circumference
    double a = width / 2;
    double b = depth / 2;
    double h = pow(a - b, 2) / pow(a + b, 2);
    return pi * (a + b) * (1 + (3 * h) / (10 + sqrt(4 - 3 * h)));
  }

  double _calculateEnhancedChestWidth(
    PoseLandmark leftShoulder,
    PoseLandmark rightShoulder,
    PoseLandmark leftHip,
    PoseLandmark rightHip,
  ) {
    final shoulderWidth = _distanceBetween(leftShoulder, rightShoulder);
    final hipWidth = _distanceBetween(leftHip, rightHip);
    final width = max(shoulderWidth, hipWidth);

    print('Chest calculation:');
    print('Raw shoulder width: $shoulderWidth');
    print('Raw hip width: $hipWidth');
    print('Selected width: $width');
    print('Converted chest width: ${width * conversionFactor}');

    return width; // Will be multiplied by conversionFactor later
  }

  double _calculateEnhancedChestDepth(
    double width,
    double weight,
    double height,
    double shoulderWidth,
  ) {
    final bmi = weight / pow(height / 100, 2);
    return width * (0.5 + (bmi - 21.75) * 0.01);
  }

  double _calculateEnhancedWaistWidth(
    PoseLandmark leftHip,
    PoseLandmark rightHip,
    PoseLandmark leftWaistPoint,
    PoseLandmark rightWaistPoint,
    PoseLandmark midLeftTorso,
    PoseLandmark midRightTorso,
    PoseLandmark leftElbow,
    PoseLandmark rightElbow,
  ) {
    // Calculate different width measurements
    double hipWidth = _distanceBetween(leftHip, rightHip);
    double waistPointWidth = _distanceBetween(leftWaistPoint, rightWaistPoint);
    double midTorsoWidth = _distanceBetween(midLeftTorso, midRightTorso);
    double elbowWidth = _distanceBetween(leftElbow, rightElbow);

    print('Waist width calculations (raw pixels):');
    print('Hip width: $hipWidth');
    print('Waist point width: $waistPointWidth');
    print('Mid torso width: $midTorsoWidth');
    print('Elbow width: $elbowWidth');

    // Use weighted average of different measurements
    double waistWidth =
        (hipWidth * 0.4 +
            waistPointWidth * 0.3 +
            midTorsoWidth * 0.2 +
            elbowWidth * 0.1);

    print('Calculated waist width (pixels): $waistWidth');
    print('Converted waist width (cm): ${waistWidth * conversionFactor}');

    return waistWidth; // Will be multiplied by conversionFactor later
  }

  double _calculateEnhancedWaistDepth(
    double width,
    double weight,
    double height,
    double chestWidth,
    double frontZ,
  ) {
    if (width <= 0 || weight <= 0 || height <= 0 || chestWidth <= 0) {
      print('Invalid input parameters for waist depth:');
      print('width: $width');
      print('weight: $weight');
      print('height: $height');
      print('chestWidth: $chestWidth');
      return 0.0;
    }

    final bmi = weight / pow(height / 100, 2);

    // Base depth calculation
    double baseDepth = width * (0.4 + (bmi - 21.75) * 0.015);

    // Adjust depth based on BMI categories
    if (bmi < 18.5) {
      // Underweight - slimmer profile
      baseDepth *= 0.9;
    } else if (bmi >= 25 && bmi < 30) {
      // Overweight - fuller profile
      baseDepth *= 1.1;
    } else if (bmi >= 30) {
      // Obese - fullest profile
      baseDepth *= 1.2;
    }

    // Consider the Z-coordinate for depth adjustment
    double zAdjustment = frontZ * 0.1;
    baseDepth += zAdjustment;

    // Ensure depth is proportional to chest
    double maxDepth = chestWidth * 0.8;
    double finalDepth = min(baseDepth, maxDepth);

    if (finalDepth <= 0) {
      print('Invalid calculated waist depth: $finalDepth');
      return 0.0;
    }

    return finalDepth;
  }

  double _calculateEnhancedHipWidth(
    PoseLandmark leftHip,
    PoseLandmark rightHip,
  ) {
    double hipWidth = _distanceBetween(leftHip, rightHip);

    // Add 10% to hip width to account for clothing and body shape
    hipWidth *= 1.1;

    print('Hip width calculation:');
    print('Original hip width: ${hipWidth / 1.1}');
    print('Adjusted hip width: $hipWidth');

    return hipWidth;
  }

  double _calculateEnhancedHipDepth(
    double width,
    double weight,
    double height,
    double waistWidth,
  ) {
    final bmi = weight / pow(height / 100, 2);
    return width * (0.45 + (bmi - 21.75) * 0.0125);
  }

  double _distanceBetween(PoseLandmark p1, PoseLandmark p2) {
    return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2));
  }

  String _determineFit(double bmi, double ratio) {
    if (bmi < 18.5 || ratio < 0.8) return 'Slim Fit';
    if (bmi < 25 || ratio < 0.9) return 'Regular Fit';
    return 'Relaxed Fit';
  }

  void _determineClothingSizes(Map<String, double> measurements) {
    final chest = measurements['chestCircumference'] ?? 0;
    final waist = measurements['waistCircumference'] ?? 0;
    final hip = measurements['hipCircumference'] ?? 0;
    final inseam = measurements['inseam'] ?? 0;
    final shoulder = measurements['shoulderWidth'] ?? 0;

    final bmi = widget.userWeight / pow(widget.userHeight / 100, 2);
    final chestToHeightRatio = chest / widget.userHeight;
    final waistToHipRatio = waist / hip;

    setState(() {
      clothingSizes = {
        't_shirt': {
          'size': _getTshirtSize(chest),
          'fit': _determineFit(bmi, chestToHeightRatio),
        },
        'shirt': {
          'size': _getShirtSize(chest, shoulder),
          'fit': _determineFit(bmi, chestToHeightRatio),
        },
        'jacket': {
          'size': _getJacketSize(chest, shoulder),
          'fit': _determineFit(bmi, chestToHeightRatio),
        },
        'pants': {
          'size': _getPantsSize(waist, hip, inseam),
          'fit': _determineFit(bmi, waistToHipRatio),
        },
      };
    });
  }

  String _getTshirtSize(double chest) {
    // Calculate BMI and other body metrics
    final bmi = widget.userWeight / pow(widget.userHeight / 100, 2);
    final heightFactor = widget.userHeight / 175.0; // Reference height of 175cm
    final weightFactor = widget.userWeight / 70.0; // Reference weight of 70kg

    // Adjust chest measurement based on height and weight proportions
    double adjustedChest = chest * (1 + (heightFactor - 1) * 0.5);

    // Base size from adjusted chest measurement
    String baseSize;
    if (adjustedChest < 86)
      baseSize = 'XS'; // < 86cm
    else if (adjustedChest < 94)
      baseSize = 'S'; // 86-94cm
    else if (adjustedChest < 102)
      baseSize = 'M'; // 94-102cm
    else if (adjustedChest < 110)
      baseSize = 'L'; // 102-110cm
    else if (adjustedChest < 118)
      baseSize = 'XL'; // 110-118cm
    else
      baseSize = '2XL'; // > 118cm

    // Fine-tune size based on BMI categories
    if (bmi < 18.5) {
      // Underweight
      return _getSmallerSize(baseSize);
    } else if (bmi >= 25 && bmi < 30) {
      // Overweight
      return _getLargerSize(baseSize);
    } else if (bmi >= 30) {
      // Obese
      return _getLargerSize(_getLargerSize(baseSize));
    }

    // Additional adjustment based on height-to-weight ratio
    double heightToWeightRatio = widget.userHeight / widget.userWeight;
    if (heightToWeightRatio > 3.0) {
      // Very tall and slim
      return _getSmallerSize(baseSize);
    } else if (heightToWeightRatio < 2.5) {
      // Shorter and broader
      return _getLargerSize(baseSize);
    }

    return baseSize;
  }

  String _getSmallerSize(String currentSize) {
    switch (currentSize) {
      case '2XL':
        return 'XL';
      case 'XL':
        return 'L';
      case 'L':
        return 'M';
      case 'M':
        return 'S';
      case 'S':
        return 'XS';
      default:
        return 'XS';
    }
  }

  String _getLargerSize(String currentSize) {
    switch (currentSize) {
      case 'XS':
        return 'S';
      case 'S':
        return 'M';
      case 'M':
        return 'L';
      case 'L':
        return 'XL';
      case 'XL':
        return '2XL';
      default:
        return '2XL';
    }
  }

  String _getShirtSize(double chest, double shoulder) {
    // Calculate body metrics
    final bmi = widget.userWeight / pow(widget.userHeight / 100, 2);
    final heightFactor = widget.userHeight / 175.0;

    // Adjust measurements based on height
    double adjustedChest = chest * (1 + (heightFactor - 1) * 0.5);
    double adjustedShoulder = shoulder * (1 + (heightFactor - 1) * 0.3);

    // Base size from chest and shoulder measurements
    String baseSize;
    if (adjustedChest < 86 || adjustedShoulder < 41)
      baseSize = 'XS (14)';
    else if (adjustedChest < 94 || adjustedShoulder < 43)
      baseSize = 'S (15)';
    else if (adjustedChest < 102 || adjustedShoulder < 45)
      baseSize = 'M (15.5)';
    else if (adjustedChest < 110 || adjustedShoulder < 47)
      baseSize = 'L (16)';
    else if (adjustedChest < 118 || adjustedShoulder < 49)
      baseSize = 'XL (17)';
    else
      baseSize = '2XL (18)';

    // Adjust based on BMI
    if (bmi < 18.5) return _getSmallerShirtSize(baseSize);
    if (bmi >= 25 && bmi < 30) return _getLargerShirtSize(baseSize);
    if (bmi >= 30) return _getLargerShirtSize(_getLargerShirtSize(baseSize));

    return baseSize;
  }

  String _getSmallerShirtSize(String currentSize) {
    switch (currentSize) {
      case '2XL (18)':
        return 'XL (17)';
      case 'XL (17)':
        return 'L (16)';
      case 'L (16)':
        return 'M (15.5)';
      case 'M (15.5)':
        return 'S (15)';
      case 'S (15)':
        return 'XS (14)';
      default:
        return 'XS (14)';
    }
  }

  String _getLargerShirtSize(String currentSize) {
    switch (currentSize) {
      case 'XS (14)':
        return 'S (15)';
      case 'S (15)':
        return 'M (15.5)';
      case 'M (15.5)':
        return 'L (16)';
      case 'L (16)':
        return 'XL (17)';
      case 'XL (17)':
        return '2XL (18)';
      default:
        return '2XL (18)';
    }
  }

  String _getPantsSize(double waist, double hip, double inseam) {
    // Calculate body metrics
    final bmi = widget.userWeight / pow(widget.userHeight / 100, 2);
    final heightFactor = widget.userHeight / 175.0;

    // Adjust waist based on height and BMI
    double adjustedWaist = waist * (1 + (heightFactor - 1) * 0.3);
    if (bmi < 18.5)
      adjustedWaist *= 0.95;
    else if (bmi >= 25)
      adjustedWaist *= 1.05;

    // Convert adjusted waist from cm to inches
    double waistInches = adjustedWaist / 2.54;

    // Calculate ideal waist based on height and weight
    double idealWaist = (widget.userHeight * 0.45) * (widget.userWeight / 70.0);
    double waistDiff = (adjustedWaist - idealWaist).abs();

    // Adjust size if there's a significant difference from ideal
    if (waistDiff > 10) {
      waistInches *= (1 + (waistDiff - 10) * 0.01);
    }

    // Standard pants sizes with more granular ranges
    if (waistInches < 28) return '28';
    if (waistInches < 29) return '29';
    if (waistInches < 30) return '30';
    if (waistInches < 31) return '31';
    if (waistInches < 32) return '32';
    if (waistInches < 33) return '33';
    if (waistInches < 34) return '34';
    if (waistInches < 36) return '36';
    if (waistInches < 38) return '38';
    if (waistInches < 40) return '40';
    if (waistInches < 42) return '42';
    if (waistInches < 44) return '44';
    if (waistInches < 46) return '46';
    return '48';
  }

  String _getJacketSize(double chest, double shoulder) {
    // Calculate body metrics
    final bmi = widget.userWeight / pow(widget.userHeight / 100, 2);
    final heightFactor = widget.userHeight / 175.0;

    // Adjust measurements based on height and build
    double adjustedChest = chest * (1 + (heightFactor - 1) * 0.5);
    double adjustedShoulder = shoulder * (1 + (heightFactor - 1) * 0.3);

    // Base size considering both chest and shoulder measurements
    String baseSize;
    if (adjustedChest < 86 || adjustedShoulder < 41)
      baseSize = '44 (XS)';
    else if (adjustedChest < 94 || adjustedShoulder < 43)
      baseSize = '46 (S)';
    else if (adjustedChest < 102 || adjustedShoulder < 45)
      baseSize = '48 (M)';
    else if (adjustedChest < 110 || adjustedShoulder < 47)
      baseSize = '50 (L)';
    else if (adjustedChest < 118 || adjustedShoulder < 49)
      baseSize = '52 (XL)';
    else
      baseSize = '54 (2XL)';

    // Adjust for BMI
    if (bmi < 18.5) return _getSmallerJacketSize(baseSize);
    if (bmi >= 25 && bmi < 30) return _getLargerJacketSize(baseSize);
    if (bmi >= 30) return _getLargerJacketSize(_getLargerJacketSize(baseSize));

    return baseSize;
  }

  String _getSmallerJacketSize(String currentSize) {
    switch (currentSize) {
      case '54 (2XL)':
        return '52 (XL)';
      case '52 (XL)':
        return '50 (L)';
      case '50 (L)':
        return '48 (M)';
      case '48 (M)':
        return '46 (S)';
      case '46 (S)':
        return '44 (XS)';
      default:
        return '44 (XS)';
    }
  }

  String _getLargerJacketSize(String currentSize) {
    switch (currentSize) {
      case '44 (XS)':
        return '46 (S)';
      case '46 (S)':
        return '48 (M)';
      case '48 (M)':
        return '50 (L)';
      case '50 (L)':
        return '52 (XL)';
      case '52 (XL)':
        return '54 (2XL)';
      default:
        return '54 (2XL)';
    }
  }

  // New helper method to interpolate between two points
  PoseLandmark _interpolatePoint(
    PoseLandmark p1,
    PoseLandmark p2,
    double t,
    PoseLandmarkType type,
  ) {
    return PoseLandmark(
      type: type,
      x: p1.x + (p2.x - p1.x) * t,
      y: p1.y + (p2.y - p1.y) * t,
      z: p1.z + (p2.z - p1.z) * t,
      visibility: min(p1.visibility, p2.visibility),
    );
  }
}
