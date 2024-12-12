import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

    // Send the request
    try {
      final response = await http.post(
        Uri.parse('https://your-api-endpoint.com/income'),
        headers: {'Content-Type': 'application/json'},
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
        Get.snackbar('Error', 'Failed to add income');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }
}
