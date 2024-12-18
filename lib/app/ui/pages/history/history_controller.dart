import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

  @override
  void onInit() {
    super.onInit();
    fetchLatestTransactions();
  }

  void reset() {
    latestTransactionList.clear();
    isLoading.value = true;
    dataNotFound.value = false;
  }

  Future<void> fetchLatestTransactions() async {
    isLoading.value = true;
    dataNotFound.value = false; // Reset status
    final url = Uri.parse('${dotenv.env['BASE_URL']}/transaction/history');

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

        if (data.containsKey('transactions') && data['transactions'] is List) {
          final transactions = data['transactions'] as List;

          if (transactions.isEmpty) {
            dataNotFound.value = true; // Data tidak ditemukan
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
          dataNotFound.value = true; // Jika respons tidak valid
        }
      } else {
        dataNotFound.value = true; // Status kode tidak 200
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
      dataNotFound.value = true; // Kesalahan lain (network, parsing, dll.)
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk mengelompokkan transaksi dan memfilter berdasarkan tanggal atau judul
  void groupTransactionsByDate() {
    groupedTransactions.clear();

    List<Transaction> filteredTransactions = latestTransactionList;

    // Filter berdasarkan tanggal
    if (selectedDate.value != null) {
      filteredTransactions = filteredTransactions.where((t) {
        return t.date.year == selectedDate.value!.year &&
            t.date.month == selectedDate.value!.month &&
            t.date.day == selectedDate.value!.day;
      }).toList();
    }

    // Filter berdasarkan judul
    if (searchTitle.value.isNotEmpty) {
      filteredTransactions = filteredTransactions.where((t) {
        return t.title.toLowerCase().contains(searchTitle.value.toLowerCase());
      }).toList();
    }

    // Kelompokkan transaksi berdasarkan tanggal
    Map<String, List<Transaction>> tempGroupedTransactions = {};

    for (var transaction in filteredTransactions) {
      String formattedDate = transaction.date.toIso8601String().split('T')[0];

      if (!tempGroupedTransactions.containsKey(formattedDate)) {
        tempGroupedTransactions[formattedDate] = [];
      }
      tempGroupedTransactions[formattedDate]!.add(transaction);
    }

    // Konversi ke RxMap
    tempGroupedTransactions.forEach((key, value) {
      groupedTransactions[key] = value.obs;
    });
  }

  void handleInvalidToken() {
    Get.snackbar('Error', 'Token tidak valid. Silakan login kembali.');
    Get.offAllNamed('/login');
  }
}
