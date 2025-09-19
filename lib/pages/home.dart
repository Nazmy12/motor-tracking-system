import 'package:flutter/material.dart';
import 'package:my_test_app/pages/login.dart';
import 'package:my_test_app/pages/borrow.dart';
import 'package:my_test_app/pages/status.dart';
import 'package:my_test_app/pages/profile.dart'; // ✅ Import ProfilePage
import 'package:my_test_app/pages/scan.dart'; // ✅ Import ScanPage

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔴 Banner with GoCheck text + profile icon
          Stack(
            children: [
              // Banner background
              Container(
                height: 352.19,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 168, 168, 168),
                      blurRadius: 5,
                      spreadRadius: 1,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Image.asset(
                  "assets/image/home_banner.png",
                  fit: BoxFit.cover,

                  width: double.infinity,
                ),
              ),

              // Foreground (GoCheck text + profile avatar)
              Positioned(
                top: 100,
                left: 20,
                child: const Text(
                  "GoCheck",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                top: 100,
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Navigation toggle
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Row(
                  children: [
                    Icon(Icons.navigation, color: Colors.redAccent),
                    SizedBox(width: 8),
                    Text("Navigation", style: TextStyle(fontSize: 16)),
                  ],
                ),
                SwitchExample(),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Menu",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Menu items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _menuCard(
                icon: Icons.pie_chart,
                title: "Status",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const StatusPage()),
                  );
                },
              ),
              _menuCard(
                icon: Icons.pedal_bike,
                title: "Borrow",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BorrowPage()),
                  );
                },
              ),
            ],
          ),
        ],
      ),

      // Bottom nav
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 231, 231, 231),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 🏠 Home icon
              IconButton(
                icon: const Icon(Icons.home, color: Colors.redAccent),
                onPressed: () {
                  // Already on Home, do nothing
                },
              ),

              const SizedBox(width: 40), // space for FAB
              // 👤 Profile icon
              IconButton(
                icon: const Icon(Icons.person_outline, color: Colors.grey),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to ScanPage when the camera icon is clicked
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ScanPage()),
          );
        },
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.camera_alt, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // 🔹 Reusable MenuCard with onTap
  static Widget _menuCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 100,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.redAccent, size: 40),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isOn,
      onChanged: (val) {
        setState(() {
          isOn = val;
        });
      },
      activeThumbColor: Colors.redAccent,
      activeTrackColor: Colors.red.shade200,
    );
  }
}
