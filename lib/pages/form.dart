import 'package:flutter/material.dart';
import 'package:my_test_app/pages/home.dart'; // Import HomePage

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  // Controllers to handle text field data
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();

  // Variables to hold selected image file paths (if using image_picker)
  String? _motorcycleImage;
  String? _selfieImage;

  // Method to pick image from gallery or camera
  Future<void> _pickImage(String type) async {
    // Logic for picking image (this can use the image_picker package)
    setState(() {
      if (type == 'motorcycle') {
        _motorcycleImage = "path/to/motorcycle/image"; // Dummy path
      } else {
        _selfieImage = "path/to/selfie/image"; // Dummy path
      }
    });
  }

  // Submit the form data
  void _submitForm() {
    if (_nameController.text.isEmpty || _nikController.text.isEmpty || _motorcycleImage == null || _selfieImage == null) {
      // Show error if any field is empty
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Error"),
          content: Text("Please fill in all fields and upload images."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    } else {
      // Handle form submission (e.g., send data to backend)
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Form Submitted"),
          content: Text("Your form has been submitted successfully."),
          actions: [
            TextButton(
              onPressed: () {
                // Navigate to the HomePage after submission
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Text("Go to Home"),
            ),
          ],
        ),
      );
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
              Text("B3337PJV - Not Returned", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Text("Honda Beat Sporty CBS ISS 2021", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              SizedBox(height: 16),

              // Name field
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  hintText: "Enter your full name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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

              // Motorcycle Image picker
              GestureDetector(
                onTap: () => _pickImage('motorcycle'),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.camera_alt, color: Colors.red),
                      SizedBox(width: 10),
                      Text(
                        _motorcycleImage == null ? "Attach Motorcycle's Picture" : "Motorcycle's Picture Attached",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),

              // Guide note for Motorcycle Picture
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Please upload a photo of the motorcycle with the license plate clearly visible.",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),
              SizedBox(height: 16),

              // Selfie Image picker
              GestureDetector(
                onTap: () => _pickImage('selfie'),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.camera_alt, color: Colors.red),
                      SizedBox(width: 10),
                      Text(
                        _selfieImage == null ? "Attach Selfie" : "Selfie Attached",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),

              // Guide note for Selfie Picture
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Please upload a selfie with the motorcycle, making sure the surrounding environment is visible.",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),
              SizedBox(height: 16),

              // Instruction text
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Please upload a selfie with the motorcycle, ensuring that both you and the motorcycle are clearly visible in the photo. The surrounding environment should also be included so that the location context can be verified. In addition, you are required to upload a separate photo of the motorcycle where the license plate is fully visible and easy to read. These photos will help the system confirm that the motorcycle has been returned to the correct place.",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),
              SizedBox(height: 16),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text("Submit", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
