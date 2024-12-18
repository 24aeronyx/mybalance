import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class IncomeController extends GetxController {
  // Form fields
  var amount = 0.0.obs;
  var description = ''.obs;
  var title = ''.obs;
  var category = ''.obs;
  var date = ''.obs;

  // Valid categories
  final validCategories = [
    'Salary',
    'Investment',
    'Gift',
    'Freelance',
  ];

  // Latest transactions list
  var latestTransactionList = <Transaction>[].obs;
  var dataNotFound = false.obs;

  // API request to add income
  Future<void> addIncome() async {
    // Validate category
    if (!validCategories.contains(category.value)) {
      Get.snackbar('Error', 'Invalid category selected');
      return;
    }

    // Validate date format (YYYY-MM-DD)
    final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateRegex.hasMatch(date.value)) {
      Get.snackbar('Error', 'Invalid date format. Please use YYYY-MM-DD.');
      return;
    }

    // Validate that amount is greater than 0
    if (amount.value <= 0) {
      Get.snackbar('Error', 'Amount must be greater than 0.');
      return;
    }

    try {
      // Retrieve token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token =
          prefs.getString('token'); // Replace 'token' with your actual key

      if (token == null) {
        Get.snackbar('Error', 'Token not found. Please login again.');
        return;
      }

      // Send the request with the token in the Authorization header
      final response = await http.post(
        Uri.parse('${dotenv.env['BASE_URL']}/transaction/income'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $token', // Add token in the Authorization header
        },
        body: jsonEncode({
          'amount': amount.value,
          'description': description.value,
          'title': title.value,
          'category': category.value,
          'date': date.value,
        }),
      );

      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Income added successfully');
      } else {
        Get.snackbar('Error',
            'Failed to add income. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  // Fetch latest transactions
  Future<void> fetchLatestTransactions() async {
    final url = Uri.parse('${dotenv.env['BASE_URL']}:3005/transaction/history');

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
      } else {
        throw Exception('Failed to load transactions: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  void handleInvalidToken() {
    Get.snackbar('Error', 'Token is invalid. Please login again.');
    Get.offAllNamed('/login');
  }
}

class Transaction {
  final String title;
  final String category;
  final String type;
  final DateTime date;
  final double amount;

  Transaction({
    required this.title,
    required this.category,
    required this.type,
    required this.date,
    required this.amount,
  });
}
