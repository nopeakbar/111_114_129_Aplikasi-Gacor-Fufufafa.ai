import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(LBSTrackingApp());
}

class LBSTrackingApp extends StatelessWidget {
  const LBSTrackingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black, // Latar belakang hitam
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white), // Warna teks putih
          bodyMedium: TextStyle(color: Colors.white), // Warna teks putih
        ),
      ),
      home: const LokasiPenggunaScreen(),
    );
  }
}

class LokasiPenggunaScreen extends StatefulWidget {
  const LokasiPenggunaScreen({super.key});

  @override
  LokasiPenggunaScreenState createState() => LokasiPenggunaScreenState();
}

class LokasiPenggunaScreenState extends State<LokasiPenggunaScreen> {
  Position? _currentPosition;
  String _locationMessage = "Tekan tombol untuk mendapatkan lokasi Anda";

  String get _formattedLocation {
    if (_currentPosition == null) {
      return "Lokasi tidak tersedia";
    }
    return "Lintang: ${_currentPosition!.latitude}, Bujur: ${_currentPosition!.longitude}";
  }

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Periksa apakah layanan lokasi diaktifkan
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationMessage = "Layanan lokasi tidak diaktifkan.";
      });
      return;
    }

    // Periksa izin lokasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationMessage = "Izin lokasi ditolak.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationMessage =
            "Izin lokasi ditolak secara permanen. Harap aktifkan di pengaturan.";
      });
      return;
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
        _locationMessage = _formattedLocation;
      });
    } catch (e) {
      setState(() {
        _locationMessage = "Terjadi kesalahan saat mendapatkan lokasi: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sistem Pelacakan Lokasi"),
        backgroundColor: Colors.grey[900], // Warna AppBar gelap
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            // Scroll bila layar tidak cukup
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_on,
                  size: 100,
                  color: Colors.redAccent, // Ikon lokasi dengan warna menarik
                ),
                const SizedBox(height: 20),
                const Text(
                  "Lokasi Anda Saat Ini",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _locationMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 20),

                // Tampilkan Map jika lokasi sudah tersedia
                if (_currentPosition != null)
                  Container(
                    height: 300,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white70),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: FlutterMap(
                        options: MapOptions(
                          center: LatLng(
                            _currentPosition!.latitude,
                            _currentPosition!.longitude,
                          ),
                          zoom: 16.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            subdomains: const ['a', 'b', 'c'],
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                width: 60.0,
                                height: 60.0,
                                point: LatLng(
                                  _currentPosition!.latitude,
                                  _currentPosition!.longitude,
                                ),
                                child: const Icon(
                                  Icons.location_pin,
                                  size: 40,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                ElevatedButton.icon(
                  onPressed: _getCurrentLocation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: const Icon(Icons.my_location),
                  label: const Text(
                    "Dapatkan Lokasi",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
