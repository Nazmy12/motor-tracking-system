import 'package:flutter/material.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  final List<Map<String, String>> data = const [
    {"serial": "B3337PJV", "user": "MUHAMMAD LUKMAN ARDIANSYAH", "position": "Teknisi BGES Services"},
    {"serial": "B3434PJV", "user": "CHOIRUL RACHMAN", "position": "Teknisi BGES Services"},
    {"serial": "B3011PLJ", "user": "YADID TAQWA MIFTAQUL HUDA", "position": "Teknisi BGES Services"},
    {"serial": "B3017PLK", "user": "M ERWIN KURNIAWAN", "position": "Teknisi BGES Services"},
    {"serial": "B3087PLK", "user": "AGUNG DWI SETYAWAN", "position": "Teknisi BGES Services"},
    {"serial": "B3148PLL", "user": "RADITYA INDRAKA H", "position": "Teknisi BGES Services"},
    {"serial": "B3156PLK", "user": "NANANG PURWANTO", "position": "Teknisi BGES Services"},
    {"serial": "B3028PLL", "user": "TITO DWI MAULUDDI", "position": "Teknisi B2C Batu"},
    {"serial": "B3233PLL", "user": "MUHAMMAD RIZQI ADHINEGORO", "position": "Teknisi B2C Batu"},
    {"serial": "B3297PLL", "user": "AMIR MUJAHID ABDULLAH", "position": "Teknisi B2C Batu"},
    {"serial": "B3348PLH", "user": "HUSNUL KHULUQ", "position": "Teknisi B2C Batu"},
    {"serial": "B3600PLJ", "user": "INDRA RIDWAN RATU OPENG", "position": "Teknisi B2C Batu"},
    {"serial": "B3784PLJ", "user": "MOCHAMAD RIZKI BAHTIAR", "position": "Teknisi B2C Batu"},
    {"serial": "B3788PLJ", "user": "MOCH. FAJAR ZAMRONI", "position": "Teknisi B2C Batu"},
    {"serial": "B3933PLK", "user": "EDO ERIYANTO", "position": "Teknisi B2C Batu"},
    {"serial": "B3236PLJ", "user": "RIZQI RACHMANSYAH", "position": "Teknisi B2C Kepanjen"},
    {"serial": "B3668PLJ", "user": "TAUFIQUR ROHMAN", "position": "Teknisi B2C Kepanjen"},
    {"serial": "B3930PLK", "user": "NOVAL AFFISSENA SHOLIHAN", "position": "Teknisi B2C Kepanjen"},
    {"serial": "B3939PLK", "user": "ILHAM BAGAS PRAYUDA", "position": "Teknisi B2C Kepanjen"},
    {"serial": "NOPOL-B3553PIE", "user": "ALI ROMADHONI", "position": "Teknisi B2C Malang"},
    {"serial": "B3172PLL", "user": "MOHAMMAD AMIRUL KHAKIM HADI KUSUMA", "position": "Teknisi B2C Malang"},
    {"serial": "B3231PLK", "user": "M RIDHO BAGUS KURNIAWAN", "position": "Teknisi B2C Malang"},
    {"serial": "B3231PLL", "user": "AHMAD FARIS SYAHRUDIN", "position": "Teknisi B2C Malang"},
    {"serial": "B3248PLK", "user": "ICHWANUL KIROM", "position": "Teknisi B2C Malang"},
    {"serial": "B3249PLK", "user": "MOCH LUKMAN FAUZI", "position": "Teknisi B2C Malang"},
    {"serial": "B3407PLJ", "user": "HERMANSYAH", "position": "Teknisi B2C Malang"},
    {"serial": "B3782PLJ", "user": "HENDRA ANDIKA SAPUTRA", "position": "Teknisi B2C Malang"},
    {"serial": "B3786PLJ", "user": "FADHLUL ILAH", "position": "Teknisi B2C Malang"},
    {"serial": "B3794PLJ", "user": "RIZKI ABDULLOH AL AMIN", "position": "Teknisi B2C Malang"},
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Malang, Batu, Kepanjen
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
              Tab(text: "Kepanjen"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StatusList(positionFilter: "Teknisi B2C Malang", data: data),
            StatusList(positionFilter: "Teknisi B2C Batu", data: data),
            StatusList(positionFilter: "Teknisi B2C Kepanjen", data: data),
          ],
        ),
      ),
    );
  }
}

class StatusList extends StatelessWidget {
  final String positionFilter;
  final List<Map<String, String>> data;

  const StatusList({super.key, required this.positionFilter, required this.data});

  @override
  Widget build(BuildContext context) {
    final filteredData = data.where((item) => item["position"] == positionFilter).toList();

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
                  SizedBox(width: 80, child: Text("Serial", style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(child: Text("User", style: TextStyle(fontWeight: FontWeight.bold))),
                  SizedBox(width: 100, child: Text("Status", style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
              const Divider(),

              // Rows
              ...filteredData.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 80, child: Text(item["serial"] ?? "")),
                      Expanded(child: Text(item["user"] ?? "", overflow: TextOverflow.ellipsis)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "Not Returned",
                          style: TextStyle(
                            color: Colors.red,
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
