import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SitusRekomendasiPage extends StatefulWidget {
  const SitusRekomendasiPage({super.key});

  @override
  State<SitusRekomendasiPage> createState() => _SitusRekomendasiPageState();
}

class _SitusRekomendasiPageState extends State<SitusRekomendasiPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> situsList = [
    {
      'nama': 'Tanaman vs Mutan',
      'url':
          'https://play.google.com/store/apps/details?id=com.ea.game.pvzfree_row&hl=id',
      'gambar': 'assets/tanamangerak.jpg',
      'favorite': false,
    },
    {
      'nama': 'Sepakbola Elektronik',
      'url':
          'https://play.google.com/store/apps/details?id=jp.konami.pesam&hl=id',
      'gambar': 'assets/efootball.webp',
      'favorite': false,
    },
    {
      'nama': 'Iki Epep',
      'url':
          'https://play.google.com/store/apps/details?id=com.dts.freefireth&hl=id',
      'gambar': 'assets/epep.webp',
      'favorite': false,
    },
    {
      'nama': 'Epep versi HD Ada Pintu',
      'url': 'https://play.google.com/store/apps/details?id=com.tencent.ig',
      'gambar': 'assets/pubg.webp',
      'favorite': false,
    },
    {
      'nama': 'Legenda Seluler',
      'url':
          'https://play.google.com/store/apps/details?id=com.mobile.legends&hl=id',
      'gambar': 'assets/legenda_seluler.jpg',
      'favorite': false,
    },
    {
      'nama': 'Ea Ea Ea FC',
      'url':
          'https://play.google.com/store/apps/details?id=com.ea.gp.fifamobile&hl=id',
      'gambar': 'assets/eafc.webp',
      'favorite': false,
    },
  ];

  void _toggleFavorite(int index) {
    setState(() {
      situsList[index]['favorite'] = !situsList[index]['favorite'];
    });
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Tidak bisa membuka $url')));
    }
  }

  Widget _buildSitusCard(Map<String, dynamic> situs, int index) {
    return Card(
      color: Colors.grey[850],
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          // Image section (full width)
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: SizedBox(
              width: double.infinity,
              height: 180,
              child: Image.asset(
                situs['gambar'],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),

          // Content section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Title and URL
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        situs['nama'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        situs['url'],
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                // Favorite button
                IconButton(
                  icon: Icon(
                    situs['favorite'] ? Icons.favorite : Icons.favorite_border,
                    color: situs['favorite'] ? Colors.red : Colors.white,
                    size: 28,
                  ),
                  onPressed: () => _toggleFavorite(index),
                ),

                // Visit button
                ElevatedButton.icon(
                  onPressed: () => _launchURL(situs['url']),
                  icon: const Icon(Icons.open_in_browser),
                  label: const Text('Visit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get favorited sites
    final List<Map<String, dynamic>> favoriteSites =
        situsList
            .asMap()
            .entries
            .where((entry) => entry.value['favorite'] == true)
            .map((entry) => {...entry.value, 'originalIndex': entry.key})
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Situs Rekomendasi'),
        backgroundColor: Colors.grey[900],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Semua Rekomendasi'), Tab(text: 'Favorit')],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.blue,
        ),
      ),
      backgroundColor: Colors.black,
      body: TabBarView(
        controller: _tabController,
        children: [
          // All recommendations tab
          ListView.builder(
            itemCount: situsList.length,
            itemBuilder: (context, index) {
              return _buildSitusCard(situsList[index], index);
            },
          ),

          // Favorites tab
          favoriteSites.isEmpty
              ? const Center(
                child: Text(
                  'Belum ada favorit yang ditambahkan',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              )
              : ListView.builder(
                itemCount: favoriteSites.length,
                itemBuilder: (context, index) {
                  final originalIndex = favoriteSites[index]['originalIndex'];
                  return _buildSitusCard(
                    situsList[originalIndex],
                    originalIndex,
                  );
                },
              ),
        ],
      ),
    );
  }
}
