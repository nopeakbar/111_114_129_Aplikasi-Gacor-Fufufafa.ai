import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class KonversiWaktuPage extends StatefulWidget {
  const KonversiWaktuPage({super.key});
  @override
  State<KonversiWaktuPage> createState() => _KonversiWaktuPageState();
}

class _KonversiWaktuPageState extends State<KonversiWaktuPage> {
  final TextEditingController _tahunController = TextEditingController();
  final TextEditingController _jamController = TextEditingController();
  final TextEditingController _menitController = TextEditingController();
  final TextEditingController _detikController = TextEditingController();

  String _lastModified = '';
  Timer? _debounceTimer;

  String? _tahunError;
  String? _jamError;
  String? _menitError;
  String? _detikError;

  @override
  void initState() {
    super.initState();
    _tahunController.addListener(() => _handleTextChange('tahun'));
    _jamController.addListener(() => _handleTextChange('jam'));
    _menitController.addListener(() => _handleTextChange('menit'));
    _detikController.addListener(() => _handleTextChange('detik'));
  }

  void _handleTextChange(String field) {
    if (_lastModified != '' && _lastModified != field) return;

    _lastModified = field;
    _debounceTimer?.cancel();

    final controller = _getControllerForField(field);

    final text = controller.text;
    final validPattern = RegExp(r'^[0-9,]+$');

    if (text.isEmpty) {
      _clearErrorForField(field);
      return;
    }

    if (!validPattern.hasMatch(text)) {
      _setErrorForField(field, "Hanya masukkan angka dan koma");
      return;
    } else {
      _clearErrorForField(field);
    }

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (controller.text.isNotEmpty &&
          validPattern.hasMatch(controller.text)) {
        _performConversion(field);
      }
    });
  }

  void _setErrorForField(String field, String message) {
    setState(() {
      switch (field) {
        case 'tahun':
          _tahunError = message;
          break;
        case 'jam':
          _jamError = message;
          break;
        case 'menit':
          _menitError = message;
          break;
        case 'detik':
          _detikError = message;
          break;
      }
    });
  }

  void _clearErrorForField(String field) {
    setState(() {
      switch (field) {
        case 'tahun':
          _tahunError = null;
          break;
        case 'jam':
          _jamError = null;
          break;
        case 'menit':
          _menitError = null;
          break;
        case 'detik':
          _detikError = null;
          break;
      }
    });
  }

  TextEditingController _getControllerForField(String field) {
    switch (field) {
      case 'tahun':
        return _tahunController;
      case 'jam':
        return _jamController;
      case 'menit':
        return _menitController;
      case 'detik':
        return _detikController;
      default:
        return _tahunController;
    }
  }

  void _performConversion(String sourceField) {
    String input = _getControllerForField(
      sourceField,
    ).text.replaceAll(',', '.');
    if (input.isEmpty) return;

    double value = double.tryParse(input) ?? 0;
    if (value == 0) return;

    double tahun, jam, menit, detik;

    const double jamPerTahun = 365 * 24; // 8760 jam di 1 taun
    const double menitPerJam = 60; // 60 menit di 1 jam
    const double detikPerMenit = 60; // 60 detik di 1 menit

    switch (sourceField) {
      case 'tahun':
        tahun = value;
        jam = tahun * jamPerTahun;
        menit = jam * menitPerJam;
        detik = menit * detikPerMenit;
        break;
      case 'jam':
        jam = value;
        tahun = jam / jamPerTahun;
        menit = jam * menitPerJam;
        detik = menit * detikPerMenit;
        break;
      case 'menit':
        menit = value;
        jam = menit / menitPerJam;
        tahun = jam / jamPerTahun;
        detik = menit * detikPerMenit;
        break;
      case 'detik':
        detik = value;
        menit = detik / detikPerMenit;
        jam = menit / menitPerJam;
        tahun = jam / jamPerTahun;
        break;
      default:
        return;
    }

    setState(() {
      if (sourceField != 'tahun') {
        _tahunController.text = _formatWithCommas(tahun, 10);
      }
      if (sourceField != 'jam') {
        _jamController.text = _formatWithCommas(jam, 6);
      }
      if (sourceField != 'menit') {
        _menitController.text = _formatWithCommas(menit, 6);
      }
      if (sourceField != 'detik') {
        _detikController.text = _formatWithCommas(detik, 6);
      }
    });

    Future.delayed(const Duration(milliseconds: 50), () {
      _lastModified = '';
    });
  }

  String _formatWithCommas(double value, int decimalPlaces) {
    final formatter = NumberFormat.decimalPattern();
    String formatted = value.toStringAsFixed(decimalPlaces);

    if (formatted.contains('.')) {
      final parts = formatted.split('.');
      final formattedInteger = formatter.format(int.parse(parts[0]));
      String decimals = parts[1].replaceAll(RegExp(r'0+$'), '');
      if (decimals.isEmpty) {
        return formattedInteger;
      } else {
        return '$formattedInteger,$decimals'; 
      }
    } else {
      return formatter.format(value);
    }
  }

  void _reset() {
    setState(() {
      _lastModified = 'reset';
      _tahunController.clear();
      _jamController.clear();
      _menitController.clear();
      _detikController.clear();
      _tahunError = null;
      _jamError = null;
      _menitError = null;
      _detikError = null;
      _lastModified = '';
    });
  }

  Widget _buildHorizontalInputField(
    String label,
    TextEditingController controller,
    String? errorText,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(label, style: const TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 5,
                child: TextFormField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    filled: true,
                    fillColor: Colors.grey[850],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: errorText != null ? Colors.red : Colors.white24,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: errorText != null ? Colors.red : Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 4),
              child: Row(
                children: [
                  const SizedBox(width: 80),
                  Text(
                    errorText,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _tahunController.dispose();
    _jamController.dispose();
    _menitController.dispose();
    _detikController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Konversi Waktu",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _reset,
              tooltip: 'Reset semua nilai',
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Card(
                  color: Color(0xFF1E1E1E),
                  margin: EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue, size: 24),
                        SizedBox(height: 8),
                        Text(
                          "Masukkan nilai pada salah satu kotak untuk konversi otomatis",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                _buildHorizontalInputField(
                  "Tahun",
                  _tahunController,
                  _tahunError,
                ),
                _buildHorizontalInputField("Jam", _jamController, _jamError),
                _buildHorizontalInputField(
                  "Menit",
                  _menitController,
                  _menitError,
                ),
                _buildHorizontalInputField(
                  "Detik",
                  _detikController,
                  _detikError,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
