import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:gocheck/services/firestore_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import 'dart:typed_data';
import 'package:provider/provider.dart';
import 'package:gocheck/providers/navigation_provider.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  bool _isCameraInitialized = false;
  String? _capturedImagePath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Initialize the camera
  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();  // Get available cameras
    _cameraController = CameraController(_cameras[0], ResolutionPreset.high);  // Use the first camera
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
      setState(() {
        _isLoading = true;
      });
      final image = await _cameraController.takePicture();  // Capture image
      setState(() {
        _capturedImagePath = image.path;
      });

      // Call the license plate validation logic here
      await _validateLicensePlate(image.path);
    } catch (e) {
      print('Error capturing image: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Validate License Plate using OCR
  Future<void> _validateLicensePlate(String imagePath) async {
    try {
      // Preprocess image for better OCR accuracy
      File imageFile = File(imagePath);
      List<int> imageBytes = await imageFile.readAsBytes();
      img.Image? originalImage = img.decodeImage(Uint8List.fromList(imageBytes));
      if (originalImage == null) {
        print('Failed to decode image for preprocessing');
        _showValidationDialog(false);
        return;
      }
      // Convert to grayscale
      img.Image grayscaleImage = img.grayscale(originalImage);
      // Resize to width 800 while maintaining aspect ratio
      img.Image resizedImage = img.copyResize(grayscaleImage, width: 800);
      // Save preprocessed image to temp file
      String tempPath = '${imageFile.parent.path}/preprocessed_${imageFile.uri.pathSegments.last}';
      File tempFile = File(tempPath);
      await tempFile.writeAsBytes(img.encodeJpg(resizedImage));

      // Extract text from preprocessed image using ML Kit
      final textRecognizer = GoogleMlKit.vision.textRecognizer();
      final inputImage = InputImage.fromFilePath(tempPath);
      final recognizedText = await textRecognizer.processImage(inputImage);
      String extractedText = recognizedText.text;
      textRecognizer.close();

      print('Extracted Text: $extractedText'); // Logging for debugging

      // Parse license plate (regex for Indonesian plates: 1 letter, 4 digits, 3 letters)
      RegExp plateRegex = RegExp(r'\b[A-Z]\d{4}[A-Z]{3}\b');
      String normalizedText = extractedText.replaceAll(' ', '').toUpperCase().trim();   
      Match? match = plateRegex.firstMatch(normalizedText);
      if (match != null) {
        String plate = match.group(0)!;
        // Check if motorcycle exists and is in use
        final motorcycle = await FirestoreService().getMotorcycleBySerial(plate);
        if (motorcycle != null && motorcycle.borrowStatus == 'in use') {
          _showValidationDialog(true, motorcycle.serialNumber);
      } else {
        _showValidationDialog(false, null, extractedText);
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
  void _showValidationDialog(bool isValid, [String? scooterId, String? extractedText]) {
    TextEditingController manualEntryController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('License Plate Validation'),
        content: isValid
            ? Text('The license plate is valid!')
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('The license plate is invalid.'),
                  if (extractedText != null && extractedText.isNotEmpty)
                    Text('Extracted text: $extractedText'),
                  SizedBox(height: 10),
                  Text('Enter license plate manually:'),
                  TextField(
                    controller: manualEntryController,
                    decoration: InputDecoration(
                      hintText: 'e.g., B1234ABC',
                    ),
                  ),
                ],
              ),
        actions: [
          TextButton(
            onPressed: () async {
              if (isValid && scooterId != null && _capturedImagePath != null) {
                // Upload image to Firebase Storage
                String imageUrl = await _uploadImageToStorage(_capturedImagePath!);
                // Navigate with arguments
                Navigator.pushNamed(context, '/form', arguments: {
                  'scooterId': scooterId,
                  'motorcycleImageUrl': imageUrl,
                });
              } else if (!isValid && manualEntryController.text.isNotEmpty) {
                // Manual entry
                String manualPlate = manualEntryController.text.toUpperCase();
                final motorcycle = await FirestoreService().getMotorcycleBySerial(manualPlate);
                if (motorcycle != null && motorcycle.borrowStatus == 'in use') {
                  Navigator.pop(context); // Close current dialog
                  _showValidationDialog(true, motorcycle.serialNumber); // Show success
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Manual entry invalid or motorcycle not in use.')),
                  );
                }
              } else {
                Navigator.pop(context);
              }
            },
            child: Text(isValid ? 'Next' : (manualEntryController.text.isNotEmpty ? 'Submit' : 'OK')),
          ),
        ],
      ),
    );
  }

  // Upload image to Firebase Storage
  Future<String> _uploadImageToStorage(String imagePath) async {
    try {
      String fileName = 'returns/motorcycle/${const Uuid().v4()}.jpg';
      Reference ref = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(File(imagePath));
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
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

          // Capture button or loading indicator
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Consumer<NavigationProvider>(
              builder: (context, navigationProvider, child) {
                if (_isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                return ElevatedButton(
                  onPressed: navigationProvider.isNavigationEnabled ? _captureImage : null,
                  child: Text(navigationProvider.isNavigationEnabled ? 'Capture Image' : 'Enable Navigation to Scan'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
