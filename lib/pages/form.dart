import 'package:flutter/material.dart';
import 'package:gocheck/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:gocheck/providers/auth_provider.dart';
import 'package:gocheck/providers/navigation_provider.dart';
import 'package:gocheck/models/motorcycle.dart';
import 'package:gocheck/models/user.dart';
import 'package:gocheck/models/return.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'dart:typed_data';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  // Controllers to handle text field data
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();

  String? _scooterId;

  Motorcycle? _motorcycle;
  User? _user;
  bool _isLoading = false;
  File? _selfieFile;
  File? _motorcyclePictureFile;

  Uint8List? _selfieBytes;
  Uint8List? _motorcyclePictureBytes;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _scooterId = args['scooterId'];
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final email = authProvider.user?.email;
    if (email != null) {
      _user = await FirestoreService().getUserByEmail(email);
      if (_user != null) {
        _nameController.text = _user!.name;
        _nikController.text = _user!.id;
      }
    }
    if (_scooterId != null) {
      _motorcycle = await FirestoreService().getMotorcycleBySerial(_scooterId!);
    }
    setState(() {});
  }

  Future<void> _pickSelfie() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _selfieBytes = bytes;
          _selfieFile = null;
        });
      } else {
        setState(() {
          _selfieFile = File(pickedFile.path);
          _selfieBytes = null;
        });
      }
    }
  }

  Future<void> _pickMotorcyclePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _motorcyclePictureBytes = bytes;
          _motorcyclePictureFile = null;
        });
      } else {
        setState(() {
          _motorcyclePictureFile = File(pickedFile.path);
          _motorcyclePictureBytes = null;
        });
      }
    }
  }

  // Submit the form data
  void _submitForm() async {
    print("Submit button pressed");
    if (_nameController.text.trim().isEmpty || _nikController.text.trim().isEmpty || (_selfieFile == null && _selfieBytes == null) || (_motorcyclePictureFile == null && _motorcyclePictureBytes == null)) {
      print("Validation failed: missing fields or images");
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: const Text("Please fill in all fields and upload both motorcycle picture and selfie."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK") ,
            ),
          ],
        ),
      );
      return;
    }

    if (_scooterId == null || _motorcycle == null || _user == null) {
      print("Validation failed: missing data - scooterId: $_scooterId, motorcycle: $_motorcycle, user: $_user");
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: const Text("Missing data."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    print("Validation passed, starting submission");
    setState(() {
      _isLoading = true;
    });

    try {
      print("Starting uploads");
      // Upload motorcycle picture
      String motorcyclePictureUrl;
      if (kIsWeb && _motorcyclePictureBytes != null) {
        motorcyclePictureUrl = await _uploadImageBytesToStorage(_motorcyclePictureBytes!, 'returns/motorcycle');
      } else if (_motorcyclePictureFile != null) {
        motorcyclePictureUrl = await _uploadImageToStorage(_motorcyclePictureFile!, 'returns/motorcycle');
      } else {
        throw Exception('Motorcycle picture not available');
      }
      print("Motorcycle picture uploaded: $motorcyclePictureUrl");

      // Upload selfie
      String selfieUrl;
      if (kIsWeb && _selfieBytes != null) {
        selfieUrl = await _uploadImageBytesToStorage(_selfieBytes!, 'returns/selfie');
      } else if (_selfieFile != null) {
        selfieUrl = await _uploadImageToStorage(_selfieFile!, 'returns/selfie');
      } else {
        throw Exception('Selfie not available');
      }
      print("Selfie uploaded: $selfieUrl");

      // Get location if enabled
      Map<String, double>? location;
      final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
      if (navigationProvider.isNavigationEnabled) {
        await navigationProvider.getCurrentLocation();
        location = navigationProvider.currentLocation;
      }
      print("Location obtained: $location");

      // Create Return object
      final returnObj = Return(
        returnID: const Uuid().v4(),
        userID: _user!.id,
        motorcycleID: _scooterId!,
        returnTimestamp: DateTime.now(),
        motorcycleImageUrl: motorcyclePictureUrl,
        selfieImageUrl: selfieUrl,
        location: location,
      );
      print("Return object created");

      // Save to Firestore
      await FirestoreService().createReturn(returnObj);
      print("Return saved to Firestore");

      // Update motorcycle status
      await FirestoreService().updateMotorcycleStatus(_scooterId!, 'available', 'returned');
      print("Motorcycle status updated");

      setState(() {
        _isLoading = false;
      });
      print("Loading set to false, showing success dialog");

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Form Submitted"),
          content: const Text("Your return has been submitted successfully."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              },
              child: const Text("Go to Home"),
            ),
          ],
        ),
      );
    } catch (e) {
      print("Error occurred: $e");
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: Text("Failed to submit: $e"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  Future<String> _uploadImageToStorage(File imageFile, String path) async {
    try {
      String fileName = '$path/${const Uuid().v4()}.jpg';
      Reference ref = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  Future<String> _uploadImageBytesToStorage(Uint8List imageBytes, String path) async {
    try {
      String fileName = '$path/${const Uuid().v4()}.jpg';
      Reference ref = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = ref.putData(imageBytes);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image bytes: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Motorcycle Return Form"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // License Plate and Bike Info
              if (_motorcycle != null)
                Text("${_motorcycle!.serialNumber} - ${_motorcycle!.returnStatus}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              if (_motorcycle != null)
                Text(_motorcycle!.model, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),

              SizedBox(height: 16),

              // Name field
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  hintText: "Enter your full name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),// next no need to fill up the  do the same thing like status page
                ),
              ),
              SizedBox(height: 16),

              // NIK field
              TextField(
                controller: _nikController,
                decoration: InputDecoration(
                  labelText: "NIK",
                  hintText: "Enter your NIK",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              SizedBox(height: 16),

              // Motorcycle Picture Upload
              Text("Motorcycle Picture", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: _pickMotorcyclePicture,
                child: Text("Take Motorcycle Picture"),
              ),
               if (_motorcyclePictureFile != null || _motorcyclePictureBytes != null)
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: kIsWeb && _motorcyclePictureBytes != null
                      ? Image.memory(_motorcyclePictureBytes!, fit: BoxFit.cover)
                      : Image.file(_motorcyclePictureFile!, fit: BoxFit.cover),
                ),
              SizedBox(height: 16),

              // Selfie Upload
              Text("Selfie", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: _pickSelfie,
                child: Text("Take Selfie"),
              ),
              if (_selfieFile != null || _selfieBytes != null)
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: kIsWeb && _selfieBytes != null
                      ? Image.memory(_selfieBytes!, fit: BoxFit.cover)
                      : Image.file(_selfieFile!, fit: BoxFit.cover),
                ),
              SizedBox(height: 16),

              // Submit Button
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text("Submit", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
