import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mybalance/app/models/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  var fullName = ''.obs;
  var balance = ''.obs;
  var latestTransactionList = <Transaction>[].obs; // Make it observable

  Future<void> fetchProfile() async {
    final url = Uri.parse('http://10.0.2.2:3005/profile');
    try {
      // Ambil token dari SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        // Jika token tidak ditemukan
        Get.snackbar('Error', 'Token tidak ditemukan. Silakan login kembali.');
        return;
      }

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['profile']?['full_name'] != null) {
          fullName.value = data['profile']['full_name'];
          balance.value = data['profile']['balance'].toString();
        } else {
          // Jika profil tidak mengandung full_name
          Get.snackbar('Error', 'Data profil tidak valid.');
        }
      } else if (response.statusCode == 401) {
        // Token tidak valid atau kedaluwarsa
        Get.snackbar('Error', 'Token kedaluwarsa. Silakan login kembali.');
      } else {
        // Kesalahan lainnya
        Get.snackbar('Error', 'Gagal mengambil profil: ${response.statusCode}');
      }
    } catch (e) {
      // Penanganan error saat proses HTTP atau parsing data
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }

  Future<void> fetchLatestTransactions() async {
    final url = Uri.parse('http://10.0.2.2:3005/transaction/get-history');

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        Get.snackbar('Error', 'Token tidak ditemukan. Silakan login kembali.');
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

        // Pemetaan transaksi yang diterima
        final latestTransactions = transactions.map((t) {
          return Transaction(
            title: t['title'],
            category: t['category'],
            type: t['type'],
            date: DateTime.parse(t['transaction_date']),
            amount: t['amount'].toDouble(),
          );
        }).toList();

        // Ambil 10 transaksi terbaru
        latestTransactionList.value = latestTransactions.take(10).toList();
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan saat mengambil data: $e');
    }
  }
}
