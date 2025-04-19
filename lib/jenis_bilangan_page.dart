import 'package:flutter/material.dart';
import 'dart:math';

class JenisBilanganPage extends StatefulWidget {
  const JenisBilanganPage({super.key});

  @override
  State<JenisBilanganPage> createState() => _JenisBilanganPageState();
}

class _JenisBilanganPageState extends State<JenisBilanganPage> {
  final TextEditingController _controller = TextEditingController();
  bool isChecked = false;
  bool isCacah = false;
  bool isBulat = false;
  bool isPrima = false;
  bool isDesimal = false;
  num number = 0;
  String bulatLabel = "Bulat";

  // Error state
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_validateInput);
  }

  void _validateInput() {
    final text = _controller.text;
    if (text.isEmpty) {
      setState(() {
        _errorMessage = null;
      });
      return;
    }

    // Allows only numbers, minus sign, and commas
    final validPattern = RegExp(r'^[-0-9,]+$');

    setState(() {
      if (!validPattern.hasMatch(text)) {
        _errorMessage = "Hanya masukkan angka, minus (-), dan koma (,)";
      } else {
        _errorMessage = null;
      }
    });
  }

  void _cekBilangan() {
    final input = _controller.text;
    if (input.isEmpty || _errorMessage != null) return;

    // Replace comma with period for parsing
    final normalizedInput = input.replaceAll(',', '.');

    setState(() {
      number = num.tryParse(normalizedInput) ?? 0;
      isChecked = true;

      isCacah = number is int && number >= 0;
      isBulat = number % 1 == 0;
      isDesimal = number % 1 != 0;
      isPrima = _isPrima(number);

      if (isBulat) {
        if (number > 0) {
          bulatLabel = "Bulat (positif)";
        } else if (number < 0) {
          bulatLabel = "Bulat (negatif)";
        } else {
          bulatLabel = "Bulat";
        }
      } else {
        bulatLabel = "Bulat";
      }
    });
  }

  bool _isPrima(num n) {
    if (n is! int || n < 2) return false;
    for (int i = 2; i <= sqrt(n).toInt(); i++) {
      if (n % i == 0) return false;
    }
    return true;
  }

  Widget _buildSimpleStatus(bool status, String label) {
    return Column(
      children: [
        Icon(
          status ? Icons.check_circle : Icons.cancel,
          color: status ? Colors.greenAccent : Colors.redAccent,
          size: 28,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey[300]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(), // Apply dark theme
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cek Jenis Bilangan'),
          backgroundColor: Colors.grey[900], // consistent dark
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Masukkan Angka',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.grey[850],
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color:
                            _errorMessage != null ? Colors.red : Colors.white38,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color:
                            _errorMessage != null ? Colors.red : Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    errorText: _errorMessage,
                    errorStyle: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity, // Full width button
                  child: ElevatedButton(
                    onPressed: _errorMessage == null ? _cekBilangan : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor:
                          _errorMessage == null
                              ? const Color(0xFF0A84FF)
                              : Colors.grey,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cek Bilangan'),
                  ),
                ),
                const SizedBox(height: 40),
                if (isChecked)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSimpleStatus(isCacah, "Cacah"),
                      _buildSimpleStatus(isBulat, bulatLabel),
                      _buildSimpleStatus(isPrima, "Prima"),
                      _buildSimpleStatus(isDesimal, "Desimal"),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
