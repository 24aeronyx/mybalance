import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;
  final bool isIncome;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.color,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        // Menghilangkan border
        // boxShadow: [BoxShadow(...)], // Bisa dihilangkan atau diatur
      ),
      child: Row(
        children: [
          Icon(
            isIncome ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            color: color,
            size: 36, // Ukuran logo yang lebih besar
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rp ${_formatAmount(amount)}', // Menampilkan amount di atas
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
              ),
              const SizedBox(height: 4), // Mengurangi jarak antara amount dan title
              Text(
                title, // Menampilkan title di bawah
                style: const TextStyle(fontSize: 16, color: Colors.grey), // Menggunakan warna abu-abu dan menghilangkan bold
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1e9) {
      return '${(amount / 1e9).toStringAsFixed(1)} B'; // Miliar
    } else if (amount >= 1e6) {
      return '${(amount / 1e6).toStringAsFixed(1)} M'; // Juta
    } else if (amount >= 1e3) {
      return '${(amount / 1e3).toStringAsFixed(1)} K'; // Ribu
    }
    return amount.toString(); // Format untuk angka di bawah 1000
  }
}
