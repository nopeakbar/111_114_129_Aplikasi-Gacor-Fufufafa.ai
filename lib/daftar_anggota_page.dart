import 'package:flutter/material.dart';
import 'detail_anggota_page.dart';

class DaftarAnggotaPage extends StatelessWidget {
  const DaftarAnggotaPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Static list of members with image paths
    final List<Map<String, String>> anggota = [
      {
        "nama": "Abednego Baharaja Silalahi",
        "nim": "123220111",
        "foto": "assets/abed.jpg",
      },
      {
        "nama": "Alvino Abyan Rizaldi",
        "nim": "123220114",
        "foto": "assets/alvino.jpg",
      },
      {
        "nama": "Noveanto Nur Akbar",
        "nim": "123220129",
        "foto": "assets/akbar.jpg",
      },
    ];

    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Daftar Anggota',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: anggota.length,
          itemBuilder: (context, index) {
            final item = anggota[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              color: const Color(0xFF2C2C2E),
              elevation: 5,
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage(item["foto"]!),
                    onBackgroundImageError: (exception, stackTrace) {},
                    child: FutureBuilder<bool>(
                      future: _checkImageExists(item["foto"]!),
                      builder: (context, snapshot) {
                        if (snapshot.data == false) {
                          return const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 32,
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                title: Text(
                  item["nama"]!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "NIM: ${item["nim"]!}",
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  ),
                ),
                onTap: () {
                  // Navigasi ke halaman DetailAnggotaPage ketika item diklik
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => DetailAnggotaPage(
                            nama: item["nama"]!,
                            nim: item["nim"]!,
                            foto: item["foto"]!,
                          ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<bool> _checkImageExists(String assetPath) async {
    try {
      AssetImage(assetPath).resolve(const ImageConfiguration());
      return true;
    } catch (e) {
      return false;
    }
  }
}
