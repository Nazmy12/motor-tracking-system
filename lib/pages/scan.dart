import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:my_test_app/pages/form.dart'; 

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

  // Validate License Plate using OCR or any other logic
  Future<void> _validateLicensePlate(String imagePath) async {
    // Simulate a license plate validation (e.g., using OCR)
    bool isValid = true;  // Replace with your actual validation logic
    if (isValid) {
      _showValidationDialog(true);
    } 
  }

  // Show validation result
  void _showValidationDialog(bool isValid) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('License Plate Validation'),
        content: Text(isValid ? 'The license plate is valid!' : 'The license plate is invalid.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FormPage()),
              );
            },
            child: Text('Next'),
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
