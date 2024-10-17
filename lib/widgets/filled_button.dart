import 'package:flutter/material.dart';

class FillButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const FillButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, // Warna background tombol
        foregroundColor: Colors.blue, // Ganti warna teks tombol menjadi biru
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0), // Padding tombol
        shape: RoundedRectangleBorder( // Bentuk tombol melengkung
          borderRadius: BorderRadius.circular(100.0),
          side: const BorderSide(color: Color.fromRGBO(0, 74, 173, 1)), // Warna border
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
