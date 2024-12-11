import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mybalance/app/models/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryController extends GetxController {
  var isLoading = true.obs;
  var dataNotFound = false.obs;
  var latestTransactionList = <Transaction>[].obs;
  var groupedTransactions =
      <String, List<Transaction>>{}.obs; // Data per tanggal

  Future<void> fetchLatestTransactions() async {
    final url = Uri.parse('http://10.0.2.2:3005/transaction/history');

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        handleInvalidToken();
        return;
      }

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final transactions = data['transactions'] as List;

        if (transactions.isNotEmpty) {
          // Proses transaksi
          latestTransactionList.value = transactions
              .map((t) {
                return Transaction(
                  title: t['title'],
                  category: t['category'],
                  type: t['type'],
                  date: DateTime.parse(t['transaction_date']),
                  amount: t['amount'].toDouble(),
                );
              })
              .take(10)
              .toList();

          // Grouping by date
          groupTransactionsByDate();
        } else {
          dataNotFound.value = true;
        }
      } else {
        throw Exception('Gagal memuat transaksi: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }

  void groupTransactionsByDate() {
    // Bersihkan data grup sebelumnya
    groupedTransactions.clear();

    for (var transaction in latestTransactionList) {
      String formattedDate = transaction.date
          .toIso8601String()
          .split('T')[0]; // Format 'YYYY-MM-DD'

      if (!groupedTransactions.containsKey(formattedDate)) {
        groupedTransactions[formattedDate] = [];
      }
      groupedTransactions[formattedDate]!.add(transaction);
    }
  }

  void handleInvalidToken() {
    Get.snackbar('Error', 'Token tidak valid. Silakan login kembali.');
    Get.offAllNamed('/login');
  }
}
