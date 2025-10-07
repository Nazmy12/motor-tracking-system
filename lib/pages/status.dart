import 'package:flutter/material.dart';
import 'package:gocheck/services/firestore_service.dart';
import 'package:gocheck/models/motorcycle.dart';
import 'package:gocheck/models/user.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  final FirestoreService _firestoreService = FirestoreService();
  List<MotorcycleStatus> _motorcycleData = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMotorcycleData();
  }

  Future<void> _loadMotorcycleData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Fetch motorcycles for all locations
      List<String> locations = [
        'Malang',
        'Batu',
        'Kepanjen',
        'BGES',
        'Provisioning',
        'Maintenance',
        'Turen',
        'Singosari',
        'FTM',
        'MO SBPU',
        'TSEL',
        'Wifi',
        'Patroli',
        'Wilsus',
        'OLO',
        'Blimbing',
        'NE',
      ];
      List<MotorcycleStatus> allData = [];

      for (String location in locations) {
        List<Motorcycle> motorcycles = await _firestoreService
            .getMotorcyclesByLocation(location);

        for (Motorcycle motorcycle in motorcycles) {
          // Get user name using ownerID
          User? user = await _firestoreService.getUser(motorcycle.ownerID);
          String userName = user?.name ?? 'Unknown User';

          allData.add(
            MotorcycleStatus(
              serialNumber: motorcycle.serialNumber,
              userName: userName,
              location: motorcycle.location,
              returnStatus: motorcycle.returnStatus,
            ),
          );
        }
      }

      setState(() {
        _motorcycleData = allData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load data: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 17, // length of the all location
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "Status",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
          bottom: const TabBar(
            labelColor: Colors.redAccent,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.redAccent,
            isScrollable: true,
            tabs: [
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
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(child: Text(_error!))
            : TabBarView(
                children: [
                  StatusList(locationFilter: "Malang", data: _motorcycleData),
                  StatusList(locationFilter: "Batu", data: _motorcycleData),
                  StatusList(locationFilter: "Kepanjen", data: _motorcycleData),
                  StatusList(locationFilter: "BGES", data: _motorcycleData),
                  StatusList(locationFilter: "Provisioning", data: _motorcycleData),
                  StatusList(locationFilter: "Maintenance", data: _motorcycleData),
                  StatusList(locationFilter: "Turen", data: _motorcycleData),
                  StatusList(locationFilter: "Singosari", data: _motorcycleData),
                  StatusList(locationFilter: "FTM", data: _motorcycleData),
                  StatusList(locationFilter: "MO SBPU", data: _motorcycleData),
                  StatusList(locationFilter: "TSEL", data: _motorcycleData),
                  StatusList(locationFilter: "Wifi", data: _motorcycleData),
                  StatusList(locationFilter: "Patroli", data: _motorcycleData),
                  StatusList(locationFilter: "Wilsus", data: _motorcycleData),
                  StatusList(locationFilter: "OLO", data: _motorcycleData),
                  StatusList(locationFilter: "Blimbing", data: _motorcycleData),
                  StatusList(locationFilter: "NE", data: _motorcycleData),
                ],
              ),
      ),
    );
  }
}

class MotorcycleStatus {
  final String serialNumber;
  final String userName;
  final String location;
  final String returnStatus;

  MotorcycleStatus({
    required this.serialNumber,
    required this.userName,
    required this.location,
    required this.returnStatus,
  });
}

class StatusList extends StatelessWidget {
  final String locationFilter;
  final List<MotorcycleStatus> data;

  const StatusList({
    super.key,
    required this.locationFilter,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final filteredData = data
        .where((item) => item.location == locationFilter)
        .toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  SizedBox(
                    width: 80,
                    child: Text(
                      "Serial",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "User",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(
                      "Status",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const Divider(),

              // Rows
              ...filteredData.map((item) {
                Color statusColor = item.returnStatus == 'returned'
                    ? Colors.green
                    : Colors.red;
                Color backgroundColor = item.returnStatus == 'returned'
                    ? Colors.green.shade100
                    : Colors.red.shade100;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 80, child: Text(item.serialNumber)),
                      Expanded(
                        child: Text(
                          item.userName,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item.returnStatus == 'returned'
                              ? 'Returned'
                              : 'Not Returned',
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
