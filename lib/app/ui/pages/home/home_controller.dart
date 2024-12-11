import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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

  Future<void> fetchData() async {
    isLoading.value = true;
    dataNotFound.value = false;

    // Timeout jika lebih dari 10 detik
    Future.delayed(const Duration(seconds: 10), () {
      if (isLoading.value) {
        Get.snackbar('Error', 'Gagal memuat data, silakan login kembali.');
        Get.offAllNamed('/login');
      }
    });

    try {
      // Ambil profil dan transaksi secara bersamaan
      await Future.wait([
        fetchProfile(),
        fetchLatestTransactions(),
      ]);

      // Jika data tidak ditemukan
      if (fullName.value.isEmpty || balance.value.isEmpty || latestTransactionList.isEmpty) {
        dataNotFound.value = true;
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProfile() async {
    final url = Uri.parse('http://10.0.2.2:3005/profile');

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
          balance.value = data['profile']['balance'].toString();
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
          latestTransactionList.value = transactions.map((t) {
            return Transaction(
              title: t['title'],
              category: t['category'],
              type: t['type'],
              date: DateTime.parse(t['transaction_date']),
              amount: t['amount'].toDouble(),
            );
          }).take(10).toList();
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

  void handleInvalidToken() {
    Get.snackbar('Error', 'Token tidak valid. Silakan login kembali.');
    Get.offAllNamed('/login');
  }
}