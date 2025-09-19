import 'package:flutter/material.dart';
import 'package:gocheck/models/scooter.dart';
import 'package:gocheck/services/firestore_service.dart';

class BorrowPage extends StatefulWidget {
  const BorrowPage({super.key});

  @override
  State<BorrowPage> createState() => _BorrowPageState();
}

class _BorrowPageState extends State<BorrowPage> with TickerProviderStateMixin {
  late TabController _tabController;
  Map<String, List<Scooter>> _scooters = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchScooters();
  }

  Future<void> _fetchScooters() async {
    final firestoreService = FirestoreService();
    final locations = ['Malang', 'Batu', 'Jember'];
    Map<String, List<Scooter>> scooters = {};

    for (String location in locations) {
      try {
        scooters[location] = await firestoreService.getScootersByLocation(location);
      } catch (e) {
        print('Error fetching scooters for $location: $e');
        scooters[location] = [];
      }
    }

    setState(() {
      _scooters = scooters;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.redAccent,
          labelColor: Colors.redAccent,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: "Malang"),
            Tab(text: "Batu"),
            Tab(text: "Jember"),
          ],
        ),
      ),

      // 🔹 Tab Views
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                // Malang
                _buildScooterList('Malang'),

                // Batu
                _buildScooterList('Batu'),

                // Jember
                _buildScooterList('Jember'),
              ],
            ),
    );
  }

  Widget _buildScooterList(String location) {
    final scooters = _scooters[location] ?? [];
    if (scooters.isEmpty) {
      return const Center(child: Text('No scooters available'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: scooters.length,
      itemBuilder: (context, index) {
        final scooter = scooters[index];
        return _buildBorrowCard(scooter, context);
      },
    );
  }

  // 🔹 Borrow card reusable widget
  static Widget _buildBorrowCard(Scooter scooter, BuildContext context) {
    // Determine image based on model or use default
    String image = "assets/image/red_scooter.png"; // default
    if (scooter.model.contains("YAMAHA")) {
      image = "assets/image/yellow_scooter.png";
    }

    Color statusColor = scooter.status == "Available" ? Colors.green : Colors.grey;

    return GestureDetector(
      onTap: () {
        if (scooter.status == "Available") {
          Navigator.pushNamed(context, '/form_borrow', arguments: scooter.id);
        }
      },
      child: Container(
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
                  Text(scooter.plate, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(scooter.model, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  const SizedBox(height: 4),
                  Text(scooter.owner, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                  Text(scooter.location, style: const TextStyle(fontSize: 12, color: Colors.black54)),
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
                scooter.status,
                style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
