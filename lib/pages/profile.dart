import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gocheck/services/firestore_service.dart';
import 'package:gocheck/providers/auth_provider.dart';
import 'package:gocheck/pages/login.dart';

class ProfilePage extends StatefulWidget {
  final String? userId;

  const ProfilePage({super.key, this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirestoreService _firestoreService = FirestoreService();
  Map<String, dynamic>? userData;
  bool isLoading = true;
  bool isEditing = false;

  // Controllers for editing
  late TextEditingController nameController;
  late TextEditingController idController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadUserData();
  }

  void _initializeControllers() {
    nameController = TextEditingController();
    idController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    idController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final email = authProvider.user?.email;

      if (email != null) {
        final user = await _firestoreService.getUserByEmail(email);
        if (user != null) {
          setState(() {
            userData = user.toJson();
            nameController.text = user.name;
            idController.text = user.id;
            emailController.text = user.email ?? '';
            phoneController.text = user.phone ?? '';
          });
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveUserData() async {
    try {
      setState(() {
        isLoading = true;
      });

      final updatedData = {
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
      };

      // Use NIK as the document ID for updating
      await _firestoreService.updateUser(idController.text.trim(), updatedData);

      // Reload user data after update
      await _loadUserData();

      setState(() {
        isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      print('Error saving user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final name = userData?['name'] ?? 'Unknown';
    final id = userData?['id'] ?? 'Unknown';
    final email = userData?['email'] ?? 'Unknown';
    final phone = userData?['phone'] ?? 'Unknown';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔴 Header with gradient background
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  child: Container(
                    height: 250,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color.fromARGB(255, 245, 44, 44), Color.fromARGB(252, 255, 138, 138)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),

                // Top bar (back + title + logout)
                Positioned(
                  top: 50,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const Positioned(
                  top: 55,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 20,
                  child: GestureDetector(
                    onTap: () {
                      // Navigate back to login page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.logout, color: Colors.redAccent),
                    ),
                  ),
                ),

                // Avatar + Name
                Positioned(
                  bottom: 20,
                  left: 10,
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEditing ? nameController.text : name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            id,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (isEditing) {
                            _saveUserData();
                          } else {
                            setState(() {
                              isEditing = true;
                            });
                          }
                        },
                        icon: Icon(isEditing ? Icons.save : Icons.edit, size: 16),
                        label: Text(isEditing ? "Save" : "Edit"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.orange,
                          elevation: 2,
                          side: const BorderSide(color: Colors.orange),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 80),

            // Details Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isEditing)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isEditing = false;
                                // Reset controllers to original values
                                nameController.text = name;
                                idController.text = id;
                                emailController.text = email;
                                phoneController.text = phone;
                              });
                            },
                            child: const Text("Cancel"),
                          ),
                      ],
                    ),
                    const Divider(),
                    if (isEditing) ...[
                      _editableField("Name", nameController),
                      _detailField("NIK", id),
                      _detailField("Email", email),
                      _editableField("No. Telephone", phoneController),
                    ] else ...[
                      _detailField("Name", name),
                      _detailField("NIK", id),
                      _detailField("Email", email),
                      _detailField("No. Telephone", phone),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Reusable field widget
  static Widget _detailField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(value),
          ),
        ],
      ),
    );
  }

  // 🔹 Editable field widget
  Widget _editableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange, width: 1),
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                border: InputBorder.none,
                hintText: 'Enter $label',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
