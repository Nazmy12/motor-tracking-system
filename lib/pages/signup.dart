import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gocheck/providers/auth_provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  String _selectedPosition = 'Teknisi B2C Malang'; // Default position
  bool _obscurePassword = true;
  bool _isLoading = false;

  // Position options
  final List<String> _positions = [
    'Head Of Service Area Klojen',
    'Korlap B2C Batu',
    'Korlap B2C Blimbing',
    'Korlap B2C Turen',
    'Officer 3 Assurance & Maintenance Malang',
    'Team Leader Assurance & Maintenance B2B Malang',
    'Team Leader Provisioning & Migration B2B Malang',
    'Technician On Site',
    'Teknisi B2C Batu',
    'Teknisi B2C Kepanjen',
    'Teknisi B2C Malang',
    'Teknisi B2C Singosari',
    'Teknisi B2C Turen',
    'Teknisi BGES Services',
    'Teknisi Corrective Maintenance & QE',
    'Teknisi FTM',
    'Teknisi Maintenance FO Lambda',
    'Teknisi MO SPBU',
    'Teknisi MS TIS',
    'Teknisi NE',
    'Teknisi OLO',
    'Teknisi Patroli Aset',
    'Teknisi Provisioning & Migrasi',
    'Teknisi Provisioning BGES',
    'Teknisi Provisioning WIBS',
    'Teknisi TSEL',
    'Teknisi Wifi',
    'Teknisi Wilsus',
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _nikController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            alignment: Alignment.topCenter,
            child: Image.asset(
              "assets/image/login_bg.png", // background image.
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
            ),
          ),

          // Foreground content
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 100),

                // Logo + Name
                Column(
                  children: [
                    Image.asset("assets/image/gocheck_logo.png", height: 100),
                    const SizedBox(height: 10),
                    const Text(
                      "GoCheck",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 110),

                // Sign-up form
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // Full Name
                      TextField(
                        controller: _fullNameController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_outline),
                          labelText: "Full Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Email Address
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined),
                          labelText: "Email Address",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Password
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          labelText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Phone Number
                      TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.phone),
                          labelText: "Phone Number",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // NIK
                      TextField(
                        controller: _nikController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined),
                          labelText: "NIK",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Position Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedPosition,
                        isExpanded: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.work_outline),
                          labelText: "Position",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        ),
                        items: _positions.map((String position) {
                          return DropdownMenuItem<String>(
                            value: position,
                            child: Text(
                              position,
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedPosition = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 30),

                      // Sign-up button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: _isLoading
                            ? null
                            : () async {
                                // Validation
                                if (_fullNameController.text.trim().isEmpty ||
                                    _emailController.text.trim().isEmpty ||
                                    _passwordController.text.trim().isEmpty ||
                                    _phoneController.text.trim().isEmpty ||
                                    _nikController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please fill in all fields',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                if (!_emailController.text.contains('@')) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please enter a valid email',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                if (_passwordController.text.length < 8) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Password must be at least 8 characters',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                setState(() {
                                  _isLoading = true;
                                });
                                final authProvider = Provider.of<AuthProvider>(
                                  context,
                                  listen: false,
                                );
                                String? error = await authProvider.signUp(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                  name: _fullNameController.text
                                      .trim()
                                      .toUpperCase(),
                                  phone: _phoneController.text.trim(),
                                  nik: _nikController.text.trim(),
                                  position: _selectedPosition,
                                );
                                setState(() {
                                  _isLoading = false;
                                });
                                if (error == null) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/login',
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(error)),
                                  );
                                }
                              },
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Aligns the row in the center
                        children: [
                          const Text(
                            "already have an account?",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ), // Adds space between the texts
                          GestureDetector(
                            onTap: () {
                              // Navigate to the Login Page
                              Navigator.pushNamed(context, '/login');
                            },
                            child: const Text(
                              "Log In",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(137, 15, 139, 255),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
