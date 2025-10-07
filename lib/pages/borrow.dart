import 'package:flutter/material.dart';
import 'package:gocheck/models/motorcycle.dart';
import 'package:gocheck/services/firestore_service.dart';

class BorrowPage extends StatefulWidget {
  const BorrowPage({super.key});

  @override
  State<BorrowPage> createState() => _BorrowPageState();
}

class _BorrowPageState extends State<BorrowPage> with TickerProviderStateMixin {
  late TabController _tabController;
  Map<String, List<Motorcycle>> _motorcycles = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 17, vsync: this);
    _fetchMotorcycles();
  }

  Future<void> _fetchMotorcycles() async {
    final firestoreService = FirestoreService();
    final locations = ['Malang', 'Batu', 'Kepanjen','BGES', 'Provisioning', 'Maintenance', 'Turen', 'Singosari', 'FTM', 'MO SBPU', 'TSEL', 'Wifi','Patroli', 'Wilsus', 'OLO', 'Blimbing', 'NE'];
    Map<String, List<Motorcycle>> motorcycles = {};

    for (String location in locations) {
      try {
        motorcycles[location] = await firestoreService.getMotorcyclesByLocation(location);
      } catch (e) {
        print('Error fetching motorcycles for $location: $e');
        motorcycles[location] = [];
      }
    }

    if (mounted) {
      setState(() {
        _motorcycles = motorcycles;
        _isLoading = false;
      });
    }
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
          isScrollable: true,
          tabs: const [
            Tab(text: "Malang"),
            Tab(text: "Batu"),
            Tab(text: "Kepanjen"), 
            Tab(text: "BGES"), 
            Tab(text: "Provisioning"),
            Tab(text: "Maintenance"),
            Tab(text: "Turen"),
            Tab(text: "Singosari"),
            Tab(text: "FTM"),
            Tab(text: "MO SBPU"),
            Tab(text: "TSEL"),
            Tab(text: "Wifi"),
            Tab(text: "Patroli"),
            Tab(text: "Wilsus"),
            Tab(text: "OLO"),
            Tab(text: "Blimbing"),
            Tab(text: "NE"),
          ],
        ),
      ),

      // 🔹 Tab Views
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildMotorcycleList('Malang'),

                _buildMotorcycleList('Batu'),

                _buildMotorcycleList('Kepanjen'),

                _buildMotorcycleList('BGES'),

                _buildMotorcycleList('Provisioning'),

                _buildMotorcycleList('Maintenance'),

                _buildMotorcycleList('Turen'),

                _buildMotorcycleList('Singosari'),

                _buildMotorcycleList('FTM'),

                _buildMotorcycleList('MO SBPU'),
                
                _buildMotorcycleList('TSEL'),

                _buildMotorcycleList('Wifi'),

                _buildMotorcycleList('Patroli'),

                _buildMotorcycleList('Wilsus'),

                _buildMotorcycleList('OLO'),

                _buildMotorcycleList('Blimbing'),

                _buildMotorcycleList('NE'),
                
              ],
            ),
    );
  }

  Widget _buildMotorcycleList(String location) {
    final motorcycles = _motorcycles[location] ?? [];
    if (motorcycles.isEmpty) {
      return const Center(child: Text('No motorcycles available'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: motorcycles.length,
      itemBuilder: (context, index) {
        final motorcycle = motorcycles[index];
        return _buildBorrowCard(motorcycle, context);
      },
    );
  }

  // 🔹 Borrow card reusable widget
  static Widget _buildBorrowCard(Motorcycle motorcycle, BuildContext context) {
    // Determine image based on model or use default
    String image = "assets/image/red_scooter.png"; // default
    if (motorcycle.model.contains("YAMAHA")) {
      image = "assets/image/yellow_scooter.png";
    }

    Color statusColor = motorcycle.borrowStatus == "available" ? Colors.green : Colors.grey;

    return GestureDetector(
      onTap: () {
        if (motorcycle.borrowStatus == "available") {
          Navigator.pushNamed(context, '/form_borrow', arguments: motorcycle.serialNumber);
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
            // Motorcycle image
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
                  Text(motorcycle.serialNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(motorcycle.model, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  const SizedBox(height: 4),
                  Text(motorcycle.location, style: const TextStyle(fontSize: 12, color: Colors.black54)),
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
                motorcycle.borrowStatus,
                style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
