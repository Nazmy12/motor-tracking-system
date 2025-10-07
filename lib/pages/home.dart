import 'package:flutter/material.dart'; 
import 'package:gocheck/widgets/menu_card.dart';
import 'package:provider/provider.dart';
import 'package:gocheck/providers/navigation_provider.dart';

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
              children: [
                const Row(
                  children: [
                    Icon(Icons.navigation, color: Colors.redAccent),
                    SizedBox(width: 8),
                    Text("Navigation", style: TextStyle(fontSize: 16)),
                  ],
                ),
                Consumer<NavigationProvider>(
                  builder: (context, provider, child) {
                    return Switch(
                      value: provider.isNavigationEnabled,
                      onChanged: provider.toggleNavigation,
                      activeThumbColor: Colors.redAccent,
                      activeTrackColor: Colors.red.shade200,
                    );
                  },
                ),
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
              MenuCard(
                icon: Icons.pie_chart,
                title: "Status",
                onTap: () {
                  Navigator.pushNamed(context, '/status');
                },
              ),
              MenuCard(
                icon: Icons.motorcycle,
                title: "Borrow",
                onTap: () {
                  Navigator.pushNamed(context, '/borrow');
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
                  Navigator.pushNamed(context, '/profile');
                },
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to ScanPage when the camera icon is clicked
          Navigator.pushNamed(context, '/scan');
        },
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.camera_alt, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }


}
