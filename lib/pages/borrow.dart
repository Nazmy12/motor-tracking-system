import 'package:flutter/material.dart';

class BorrowPage extends StatelessWidget {
  const BorrowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Malang, Batu, Jember
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context); // go back to HomePage
            },
          ),
          title: const Text(
            "Borrow",
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
          backgroundColor: Colors.white,
          elevation: 0,

          // 🔹 Tabs inside AppBar
          bottom: const TabBar(
            indicatorColor: Colors.redAccent,
            labelColor: Colors.redAccent,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "Malang"),
              Tab(text: "Batu"),
              Tab(text: "Jember"),
            ],
          ),
        ),

        // 🔹 Tab Views
        body: TabBarView(
          children: [
            // Malang
            ListView(
              padding: const EdgeInsets.all(12),
              children: [
                _buildBorrowCard(
                  image: "assets/image/red_scooter.png",
                  plate: "B3337PJV",
                  model: "HONDA BEAT SPORTY CBS ISS 2021",
                  owner: "MUHAMMAD LUKMAN ARDIANSYAH",
                  location: "Teknisi BGS Services",
                  status: "Available",
                  statusColor: Colors.green,
                ),
                const SizedBox(height: 12),
                _buildBorrowCard(
                  image: "assets/image/yellow_scooter.png",
                  plate: "B3434PJV",
                  model: "HONDA BEAT SPORTY CBS ISS 2021",
                  owner: "CHORIQ RACHMAN",
                  location: "Teknisi BGS Services",
                  status: "In Use",
                  statusColor: Colors.grey,
                ),
              ],
            ),

            // Batu
            ListView(
              padding: const EdgeInsets.all(12),
              children: [
                _buildBorrowCard(
                  image: "assets/image/yellow_scooter.png",
                  plate: "N5678BTR",
                  model: "YAMAHA MIO 2020",
                  owner: "FAHMI HIDAYAT",
                  location: "Teknisi Batu Services",
                  status: "Available",
                  statusColor: Colors.green,
                ),
              ],
            ),

            // Jember
            ListView(
              padding: const EdgeInsets.all(12),
              children: [
                _buildBorrowCard(
                  image: "assets/image/red_scooter.png",
                  plate: "P7890JBR",
                  model: "HONDA VARIO 2019",
                  owner: "NADIA PUTRI",
                  location: "Teknisi Jember Services",
                  status: "In Use",
                  statusColor: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Borrow card reusable widget
  static Widget _buildBorrowCard({
    required String image,
    required String plate,
    required String model,
    required String owner,
    required String location,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 138, 138, 138),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Scooter image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(image, width: 80, height: 80, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plate, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(model, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                const SizedBox(height: 4),
                Text(owner, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                Text(location, style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),

          // Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 240, 240, 240),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
