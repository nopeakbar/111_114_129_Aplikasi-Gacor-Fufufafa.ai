import 'package:flutter/material.dart';
import 'login_page.dart';

class BantuanPage extends StatelessWidget {
  const BantuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    // List of help items
    final List<Map<String, String>> helpItems = [
      {
        "title": "Login",
        "description":
            "Masukkan username dan password Anda untuk mengakses aplikasi. Jika Anda belum memiliki akun, silakan daftarkan diri Anda terlebih dahulu.",
        "icon": "login",
      },
      {
        "title": "Home Page",
        "description":
            "Di halaman utama, Anda dapat melihat berbagai pilihan menu dan melakukan pemesanan makanan sesuai dengan keinginan Anda.",
        "icon": "home",
      },
      {
        "title": "Pesan Makanan",
        "description":
            "Pilih makanan yang kamu inginkan, tentukan jumlah, dan klik tombol \"Pesan\" untuk memproses pesanan Anda.",
        "icon": "restaurant",
      },
      {
        "title": "Cek Pesanan",
        "description":
            "Di halaman pemesanan, kamu dapat melihat detail makanan yang dipesan, jumlah, dan harga total.",
        "icon": "receipt",
      },
      {
        "title": "Logout",
        "description":
            "Jika kamu selesai menggunakan aplikasi, jangan lupa logout biar tenang.",
        "icon": "logout",
      },
      {
        "title": "Daftar Anggota",
        "description":
            "Jika kamu selesai menggunakan aplikasi ini, jbisa cek muka-muka kami.",
        "icon": "group",
      },
    ];

    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Bantuan',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            // Adding logout button to the AppBar
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              tooltip: 'Logout',
              onPressed: () {
                // Logout: kembali ke login dan hapus session
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
        body: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: helpItems.length,
          itemBuilder: (context, index) {
            final item = helpItems[index];
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
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      _getIconData(item["icon"]!),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                title: Text(
                  "${index + 1}. ${item["title"]!}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    item["description"]!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'login':
        return Icons.login;
      case 'home':
        return Icons.home;
      case 'restaurant':
        return Icons.restaurant;
      case 'receipt':
        return Icons.receipt;
      case 'logout':
        return Icons.logout;
      case 'group':
        return Icons.group;
      default:
        return Icons.help;
    }
  }
}
