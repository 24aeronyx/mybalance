import 'package:flutter/material.dart';

class BalanceSection extends StatelessWidget {
  final double totalBalance;
  final String Function(double) formatCurrency;

  const BalanceSection({
    required this.totalBalance,
    required this.formatCurrency,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: const Color.fromRGBO(0, 74, 173, 1),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(bottom: 0.0, top: 50),
        child: Column(
          children: [
            const Text(
              'Your Balance',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Rp ${formatCurrency(totalBalance)}', // Menambahkan 'Rp.' sebelum saldo
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
