import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/analysis_results_widget.dart';
import './widgets/camera_controls_widget.dart';
import './widgets/camera_header_widget.dart';
import './widgets/camera_overlay_widget.dart';

class CropHealthScanner extends StatefulWidget {
  const CropHealthScanner({super.key});

  @override
  State<CropHealthScanner> createState() => _CropHealthScannerState();
}

class _CropHealthScannerState extends State<CropHealthScanner> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isFlashOn = false;
  bool _isProcessing = false;
  bool _showResults = false;
  XFile? _capturedImage;
  Map<String, dynamic>? _analysisResult;
  final ImagePicker _imagePicker = ImagePicker();

  // Mock analysis data for demonstration
  final List<Map<String, dynamic>> _mockAnalysisResults = [
    {
      "disease": "Late Blight (Phytophthora infestans)",
      "confidence": 0.87,
      "severity": "High",
      "symptoms": [
        "Dark brown to black lesions on leaves with white fuzzy growth on undersides",
        "Rapid spreading of lesions during humid conditions",
        "Yellowing and wilting of affected plant parts",
        "Distinctive musty odor from infected areas"
      ],
      "treatments": [
        "Apply copper-based fungicide immediately (Copper oxychloride 50% WP @ 3g/L)",
        "Remove and destroy all infected plant debris",
        "Improve air circulation by proper plant spacing",
        "Apply preventive sprays of Mancozeb 75% WP @ 2.5g/L every 10-15 days",
        "Avoid overhead irrigation to reduce leaf wetness"
      ]
    },
    {
      "disease": "Bacterial Leaf Spot (Xanthomonas campestris)",
      "confidence": 0.92,
      "severity": "Medium",
      "symptoms": [
        "Small, circular, water-soaked spots on leaves",
        "Spots turn brown to black with yellow halos",
        "Leaf yellowing and premature dropping",
        "Reduced fruit quality and yield"
      ],
      "treatments": [
        "Spray with Streptocyclin 300 ppm + Copper oxychloride 0.25%",
        "Ensure proper field sanitation and crop rotation",
        "Use drip irrigation instead of sprinkler irrigation",
        "Apply Bordeaux mixture (1%) as preventive measure",
        "Remove infected plants and burn them away from field"
      ]
    },
    {
      "disease": "Powdery Mildew (Erysiphe cichoracearum)",
      "confidence": 0.78,
      "severity": "Low",
      "symptoms": [
        "White powdery coating on upper leaf surfaces",
        "Yellowing and curling of affected leaves",
        "Stunted plant growth and reduced photosynthesis",
        "Premature leaf drop in severe cases"
      ],
      "treatments": [
        "Spray with Sulfur 80% WP @ 2-3g/L water",
        "Apply Potassium bicarbonate solution (5g/L) weekly",
        "Ensure adequate spacing for air circulation",
        "Use resistant varieties in future plantings",
        "Apply neem oil (5ml/L) as organic treatment option"
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<void> _initializeCamera() async {
    try {
      if (!await _requestCameraPermission()) {
        _showPermissionDeniedDialog();
        return;
      }

      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        _showNoCameraDialog();
        return;
      }

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first)
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first);

      _cameraController = CameraController(
        camera,
        kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
      _showCameraErrorDialog();
    }
  }

  Future<void> _applySettings() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
      await _cameraController!.setExposureMode(ExposureMode.auto);

      if (!kIsWeb) {
        await _cameraController!.setFlashMode(FlashMode.auto);
      }
    } catch (e) {
      debugPrint('Settings application error: $e');
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        _isProcessing) {
      return;
    }

    try {
      setState(() {
        _isProcessing = true;
      });

      final XFile photo = await _cameraController!.takePicture();
      setState(() {
        _capturedImage = photo;
      });

      await _analyzeImage();
    } catch (e) {
      debugPrint('Photo capture error: $e');
      Fluttertoast.showToast(
        msg: "Failed to capture photo. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _selectFromGallery() async {
    if (_isProcessing) return;

    try {
      setState(() {
        _isProcessing = true;
      });

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _capturedImage = image;
        });
        await _analyzeImage();
      }
    } catch (e) {
      debugPrint('Gallery selection error: $e');
      Fluttertoast.showToast(
        msg: "Failed to select image from gallery.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _analyzeImage() async {
    if (_capturedImage == null) return;

    // Simulate AI processing time
    await Future.delayed(const Duration(seconds: 2));

    // Mock analysis result
    final randomResult = _mockAnalysisResults[
        DateTime.now().millisecond % _mockAnalysisResults.length];

    if (mounted) {
      setState(() {
        _analysisResult = randomResult;
        _showResults = true;
      });
    }
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        kIsWeb) {
      return;
    }

    try {
      final newFlashMode = _isFlashOn ? FlashMode.off : FlashMode.torch;
      await _cameraController!.setFlashMode(newFlashMode);

      setState(() {
        _isFlashOn = !_isFlashOn;
      });
    } catch (e) {
      debugPrint('Flash toggle error: $e');
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2 || _isProcessing) return;

    try {
      setState(() {
        _isCameraInitialized = false;
      });

      final currentLensDirection = _cameraController!.description.lensDirection;
      final newCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection != currentLensDirection,
        orElse: () => _cameras.first,
      );

      await _cameraController!.dispose();

      _cameraController = CameraController(
        newCamera,
        kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
          _isFlashOn = false;
        });
      }
    } catch (e) {
      debugPrint('Camera switch error: $e');
      _initializeCamera();
    }
  }

  void _saveAnalysis() {
    if (_analysisResult == null) return;

    // Mock save functionality
    Fluttertoast.showToast(
      msg: "Analysis saved to crop history successfully!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      textColor: Colors.white,
    );

    _closeResults();
  }

  void _shareResults() {
    if (_analysisResult == null) return;

    // Mock share functionality
    Fluttertoast.showToast(
      msg: "Sharing analysis results with agricultural expert...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      textColor: Colors.white,
    );
  }

  void _closeResults() {
    setState(() {
      _showResults = false;
      _analysisResult = null;
      _capturedImage = null;
    });
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Camera Permission Required'),
        content: const Text(
            'Please grant camera permission to use the crop health scanner.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  void _showNoCameraDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No Camera Available'),
        content: const Text('No camera was found on this device.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showCameraErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Camera Error'),
        content: const Text('Failed to initialize camera. Please try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _initializeCamera();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview
          if (_isCameraInitialized && _cameraController != null)
            Positioned.fill(
              child: CameraPreview(_cameraController!),
            )
          else
            Positioned.fill(
              child: Container(
                color: Colors.black,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 12.w,
                        height: 12.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'Initializing camera...',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Camera overlay with guides
          if (_isCameraInitialized && !_showResults)
            const Positioned.fill(
              child: CameraOverlayWidget(),
            ),

          // Header controls
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CameraHeaderWidget(
              onClose: () => Navigator.pop(context),
              onFlashToggle: _toggleFlash,
              onCameraSwitch: _switchCamera,
              isFlashOn: _isFlashOn,
              hasMultipleCameras: _cameras.length > 1,
            ),
          ),

          // Bottom controls
          if (_isCameraInitialized && !_showResults)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CameraControlsWidget(
                onCapturePressed: _capturePhoto,
                onGalleryPressed: _selectFromGallery,
                onFlashToggle: _toggleFlash,
                isFlashOn: _isFlashOn,
                isProcessing: _isProcessing,
              ),
            ),

          // Analysis results
          if (_showResults && _analysisResult != null)
            Positioned.fill(
              child: AnalysisResultsWidget(
                analysisResult: _analysisResult!,
                onSave: _saveAnalysis,
                onShare: _shareResults,
                onClose: _closeResults,
              ),
            ),
        ],
      ),
    );
  }
}
