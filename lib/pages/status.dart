import 'package:flutter/material.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Malang, Batu, Jember
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
            tabs: [
              Tab(text: "Malang"),
              Tab(text: "Batu"),
              Tab(text: "Jember"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            StatusList(), // Malang
            Center(child: Text("No data for Batu yet")),
            Center(child: Text("No data for Jember yet")),
          ],
        ),
      ),
    );
  }
}

class StatusList extends StatelessWidget {
  const StatusList({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for now
    final List<Map<String, dynamic>> data = [
      {"serial": "B3337PJV", "user": "MUHAMMAD LUKMAN ARDIANSYAH", "status": "Not Returned"},
      {"serial": "B3434PJV", "user": "CHOIRUL RACHMAN", "status": "Returned"},
      {"serial": "B3011PLJ", "user": "YADID TAQWA MIFTAQUL HUDA", "status": "Not Returned"},
      {"serial": "B3017PLK", "user": "M ERWIN KURNIAWAN", "status": "Not Returned"},
      {"serial": "B3087PLK", "user": "AGUNG DWI SETYAWAN", "status": "Not Returned"},
      {"serial": "B3148PLL", "user": "RADITYA INDRAKA H", "status": "Not Returned"},
      {"serial": "B3156PLK", "user": "NANANG PURWANTO", "status": "Not Returned"},
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
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
                  Text("Serial", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("User", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const Divider(),

              // Rows
              ...data.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 80, child: Text(item["serial"])),
                      Expanded(child: Text(item["user"], overflow: TextOverflow.ellipsis)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: item["status"] == "Returned"
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item["status"],
                          style: TextStyle(
                            color: item["status"] == "Returned"
                                ? Colors.green
                                : Colors.red,
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
