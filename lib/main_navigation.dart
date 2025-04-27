import 'package:flutter/material.dart';
import 'home_page.dart';
import 'daftar_anggota_page.dart';
import 'bantuan_page.dart';

class MainNavigation extends StatefulWidget {
  final String username;

  const MainNavigation({super.key, required this.username});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(username: widget.username),
      const DaftarAnggotaPage(),
      const BantuanPage(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.grey[900],
          selectedItemColor: const Color.fromARGB(255, 10, 132, 255),
          unselectedItemColor: Colors.grey,
          elevation: 8,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              activeIcon: Icon(Icons.home_rounded, size: 28),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group_rounded),
              activeIcon: Icon(Icons.group_rounded, size: 28),
              label: 'Anggota',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.help_outline_rounded),
              activeIcon: Icon(Icons.help_rounded, size: 28),
              label: 'Bantuan',
            ),
          ],
        ),
      ),
      extendBody: true, 
    );
  }
}
