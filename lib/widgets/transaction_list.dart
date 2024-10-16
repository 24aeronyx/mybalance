import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package untuk format angka
import '../models/transaction.dart'; // Pastikan Anda memiliki model Transaction

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionList({required this.transactions, Key? key})
      : super(key: key);

  // Fungsi untuk memformat jumlah uang menjadi format dengan koma
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  // Fungsi untuk memformat tanggal
  String formatDate(DateTime date) {
    final formatter = DateFormat('dd MMMM yyyy'); // Format tanggal
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: transactions.map((transaction) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white, // Warna latar belakang
            borderRadius: BorderRadius.circular(4), // Sudut membulat (opsional)
          ),
          child: ListTile(
            leading: Icon(
              transaction.icon,
              color: const Color.fromRGBO(0, 74, 173, 1),
            ),
            title: Text(transaction.title),
            subtitle: Text(formatDate(
                transaction.date)), // Tampilkan tanggal sebagai subtitle
            trailing: Text(
              '${transaction.isExpense ? '-' : ''}Rp ${TransactionList.formatCurrency(transaction.amount)}', // Memanggil fungsi statis
              style: TextStyle(
                color: transaction.isExpense ? Colors.red : Colors.green,
                fontSize: 14,
                fontWeight: FontWeight.bold, // Menebalkan angka
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
