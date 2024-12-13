import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mybalance/app/models/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  var isLoading = true.obs;
  var dataNotFound = false.obs;
  var fullName = ''.obs;
  var balance = ''.obs;
  var latestTransactionList = <Transaction>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void reset() {
    fullName.value = '';
    balance.value = '';
    latestTransactionList.clear();
    isLoading.value = true;
    dataNotFound.value = false;
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    dataNotFound.value = false;

    // Timeout jika lebih dari 10 detik
    Future.delayed(const Duration(seconds: 20), () {
      if (isLoading.value) {
        Get.snackbar('Error', 'Gagal memuat data, silakan login kembali.');
        Get.offAllNamed('/login');
      }
    });

    try {
      await Future.wait([
        fetchProfile(),
        fetchLatestTransactions(),
      ]);

      // Jika data tidak ditemukan
      if (fullName.value.isEmpty) {
        dataNotFound.value = true;
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProfile() async {
    final url = Uri.parse('${dotenv.env['BASE_URL']}/profile');

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
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['profile']?['full_name'] != null) {
          fullName.value = data['profile']['full_name'];

          // Format the balance to Indonesian currency format
          double rawBalance = data['profile']['balance'].toDouble();
          balance.value = _formatCurrency(rawBalance); // Format balance
        } else {
          dataNotFound.value = true;
        }
      } else if (response.statusCode == 401) {
        handleInvalidToken();
      } else {
        throw Exception('Gagal mengambil profil: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }

// Format the balance in Indonesian currency format
  String _formatCurrency(double amount) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID', // Indonesian locale
      symbol: 'Rp', // Currency symbol
      decimalDigits: 2, // Number of decimal digits
    );
    return formatCurrency.format(amount);
  }

  Future<void> fetchLatestTransactions() async {
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
        final transactions = data['transactions'] as List;

        if (transactions.isNotEmpty) {
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
        } else {
          dataNotFound.value = true;
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }

  void handleInvalidToken() {
    Get.snackbar('Error', 'Token tidak valid. Silakan login kembali.');
    Get.offAllNamed('/login');
  }
}
