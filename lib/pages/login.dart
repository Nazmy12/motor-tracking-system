import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gocheck/providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background image
            Container(
              alignment: Alignment.topCenter,
              child: Image.asset(
                "assets/image/login_bg.png", // Replace with your image asset
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
              ),
            ),

            // Foreground content
            SingleChildScrollView(
              
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 150),

                    // Logo + Name
                    Column(
                      children: [
                    Image.asset(
                      "assets/image/gocheck_logo.png", // Replace with your logo asset
                      height: 80,
                    ),
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

                    const SizedBox(height: 150),

                    // Login form
                    Column(
                      children: [
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
                        const SizedBox(height: 30),

                        // Login button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          onPressed: _isLoading ? null : () async {
                            // Validation
                            if (_emailController.text.trim().isEmpty ||
                                _passwordController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please enter email and password')),
                              );
                              return;
                            }

                            setState(() {
                              _isLoading = true;
                            });
                            final authProvider = Provider.of<AuthProvider>(context, listen: false);
                            String? error = await authProvider.signIn(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                            setState(() {
                              _isLoading = false;
                            });
                            if (error == null) {
                              Navigator.pushReplacementNamed(context, '/home');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(error)),
                              );
                            }
                          },
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  "Log In",
                                  style: TextStyle(fontSize: 18, color: Colors.white),
                                ),
                        ),

                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {},
                          child: const Text("Forgot password?"),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don’t have an account?",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: () {
                                // Navigate to the Sign Up Page
                                Navigator.pushNamed(context, '/signup');
                              },
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(136, 10, 90, 238),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20), // Add bottom padding
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
