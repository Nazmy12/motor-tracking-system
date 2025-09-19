import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:gocheck/pages/form.dart';
import 'package:gocheck/services/firestore_service.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Initialize the camera
  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();  // Get available cameras
    _cameraController = CameraController(_cameras[0], ResolutionPreset.medium);  // Use the first camera
    await _cameraController.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  // Capture Image
  Future<void> _captureImage() async {
    try {
      final image = await _cameraController.takePicture();  // Capture image

      // Call the license plate validation logic here
      _validateLicensePlate(image.path);
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  // Validate License Plate using OCR
  Future<void> _validateLicensePlate(String imagePath) async {
    try {
      // Extract text from image using OCR
      String extractedText = await FlutterTesseractOcr.extractText(imagePath);

      // Parse license plate (simple regex for Indonesian plates like B1234ABC)
      RegExp plateRegex = RegExp(r'\b[A-Z]\d{4}[A-Z]{3}\b');
      Match? match = plateRegex.firstMatch(extractedText.toUpperCase());
      if (match != null) {
        String plate = match.group(0)!;
        // Check if scooter exists and is in use
        final scooter = await FirestoreService().getScooterByPlate(plate);
        if (scooter != null && scooter.status == 'In Use') {
          _showValidationDialog(true, scooter.id);
        } else {
          _showValidationDialog(false);
        }
      } else {
        _showValidationDialog(false);
      }
    } catch (e) {
      print('OCR Error: $e');
      _showValidationDialog(false);
    }
  }

  // Show validation result
  void _showValidationDialog(bool isValid, [String? scooterId]) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('License Plate Validation'),
        content: Text(isValid ? 'The license plate is valid!' : 'The license plate is invalid.'),
        actions: [
          TextButton(
            onPressed: () {
              if (isValid && scooterId != null) {
                Navigator.pushNamed(context, '/form', arguments: scooterId);
              } else {
                Navigator.pop(context);
              }
            },
            child: Text(isValid ? 'Next' : 'OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan License Plate')),
      body: Column(
        children: [
          _isCameraInitialized
              ? Expanded(child: CameraPreview(_cameraController))
              : Center(child: CircularProgressIndicator()),

          // Capture button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: _captureImage,
              child: Text('Capture Image'),
            ),
          ),
        ],
      ),
    );
  }
}
