import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mybalance/app/models/transaction_model.dart';
import 'package:mybalance/app/ui/pages/home/home_controller.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class OutcomeController extends GetxController {
  // Form fields
  var amount = 0.0.obs;
  var description = ''.obs;
  var title = ''.obs;
  var category = ''.obs;
  var date = ''.obs;
  var isButtonDisabled = false.obs;
  final homeController = Get.find<HomeController>();

  // Valid categories (for Outcome)
  final validCategories = [
    'Food',
    'Transportation',
    'Entertainment',
    'Utilities',
  ];

  // Latest transactions list
  var latestTransactionList = <Transaction>[].obs;
  var dataNotFound = false.obs;

  // API request to add outcome
  Future<void> addOutcome() async {
    try {
      // Validasi input
      if (!validCategories.contains(category.value)) {
        Get.snackbar('Error', 'Invalid category selected');
        return;
      }

      if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(date.value)) {
        Get.snackbar('Error', 'Invalid date format. Please use YYYY-MM-DD.');
        return;
      }

      if (amount.value <= 0 || amount.value > 1000000000) {
        Get.snackbar('Error',
            'Amount must be greater than 0 and less than or equal to 1 billion.');
        return;
      }

      if (title.value.length > 20) {
        Get.snackbar('Error', 'Title must not exceed 20 characters.');
        return;
      }

      if (description.value.length > 30) {
        Get.snackbar('Error', 'Description must not exceed 30 characters.');
        return;
      }

      // Ambil token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        Get.snackbar('Error', 'Token not found. Please login again.');
        return;
      }

      // Kirim request
      final response = await http.post(
        Uri.parse('${dotenv.env['BASE_URL']}/transaction/outcome'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'amount': amount.value,
          'description': description.value,
          'title': title.value,
          'category': category.value,
          'date': date.value,
        }),
      );

      // Cek hasil
      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Outcome added successfully');
        homeController.fetchLatestTransactions();
        homeController.fetchProfile();
      } else {
        Get.snackbar('Error',
            'Failed to add outcome. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }
}
