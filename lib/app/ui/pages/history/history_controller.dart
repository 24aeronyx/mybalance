import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mybalance/app/models/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryController extends GetxController {
  var isLoading = true.obs;
  var dataNotFound = false.obs;
  var latestTransactionList = <Transaction>[].obs;
  var groupedTransactions = <String, List<Transaction>>{}.obs;

  // Tambahkan variabel untuk filter
  var selectedDate = Rxn<DateTime>();
  var searchTitle = ''.obs;

  Future<void> fetchLatestTransactions() async {
    isLoading.value = true;
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

      if (response.statusCode != 200) {
        throw Exception('Failed to load transactions: ${response.statusCode}');
      }

      final data = json.decode(response.body);

      if (data.containsKey('transactions') && data['transactions'] is List) {
        final transactions = data['transactions'] as List;

        if (transactions.isEmpty) {
          dataNotFound.value = true;
        } else {
          latestTransactionList.value = transactions.map((t) {
            return Transaction(
              title: t['title'] ?? 'Untitled',
              category: t['category'] ?? 'Uncategorized',
              type: t['type'] ?? 'Unknown',
              date: DateTime.parse(
                  t['transaction_date'] ?? DateTime.now().toString()),
              amount: (t['amount'] ?? 0.0).toDouble(),
            );
          }).toList();

          groupTransactionsByDate();
        }
      } else {
        throw Exception('Missing or invalid "transactions" data');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk mengelompokkan transaksi dan memfilter berdasarkan tanggal atau judul
  void groupTransactionsByDate() {
    groupedTransactions.clear();

    List<Transaction> filteredTransactions = latestTransactionList;

    // Filter based on date
    if (selectedDate.value != null) {
      filteredTransactions = filteredTransactions.where((t) {
        return t.date.year == selectedDate.value!.year &&
            t.date.month == selectedDate.value!.month &&
            t.date.day == selectedDate.value!.day;
      }).toList();
    }

    // Filter based on title
    if (searchTitle.value.isNotEmpty) {
      filteredTransactions = filteredTransactions.where((t) {
        return t.title.toLowerCase().contains(searchTitle.value.toLowerCase());
      }).toList();
    }

    // Group transactions by date
    Map<String, List<Transaction>> tempGroupedTransactions = {};

    for (var transaction in filteredTransactions) {
      String formattedDate = transaction.date.toIso8601String().split('T')[0];

      if (!tempGroupedTransactions.containsKey(formattedDate)) {
        tempGroupedTransactions[formattedDate] = [];
      }
      tempGroupedTransactions[formattedDate]!.add(transaction);
    }

    // Convert Map<String, List<Transaction>> to RxMap<String, RxList<Transaction>>
    tempGroupedTransactions.forEach((key, value) {
      groupedTransactions[key] = value.obs; // Use .obs to convert to RxList
    });
  }

  void handleInvalidToken() {
    Get.snackbar('Error', 'Token tidak valid. Silakan login kembali.');
    Get.offAllNamed('/login');
  }
}
