import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterController extends GetxController {
  var isLoading = false.obs; // Untuk mengatur status loading
  var isPasswordVisible = false.obs; // Variable untuk visibilitas password
  var isButtonDisabled = false.obs;

  // Fungsi untuk toggle visibilitas password
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> register(
    String email,
    String username,
    String password,
    String fullName,
  ) async {
    // Disable button when validation starts
    isButtonDisabled.value = true;

    // Validate email
    if (email.isEmpty) {
      Get.snackbar('Error', 'Email is required');
      isButtonDisabled.value = false;
      return;
    }
    if (!email.contains('@') || !isValidEmail(email)) {
      Get.snackbar('Error', 'Please provide a valid email address');
      isButtonDisabled.value = false;
      return;
    }

    // Validate username
    if (username.isEmpty || username.length < 3) {
      Get.snackbar('Error', 'Username must be at least 3 characters long');
      isButtonDisabled.value = false;
      return;
    }

    // Validate password
    if (password.isEmpty) {
      Get.snackbar('Error', 'Password is required');
      isButtonDisabled.value = false;
      return;
    }
    if (password.length < 8) {
      Get.snackbar('Error', 'Password must be at least 8 characters long');
      isButtonDisabled.value = false;
      return;
    }
    if (!password.contains(RegExp(r'\d'))) {
      Get.snackbar('Error', 'Password must contain at least one number');
      isButtonDisabled.value = false;
      return;
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      Get.snackbar(
          'Error', 'Password must contain at least one uppercase letter');
      isButtonDisabled.value = false;
      return;
    }

    // Validate full name
    if (fullName.isEmpty) {
      Get.snackbar('Error', 'Full name is required');
      isButtonDisabled.value = false;
      return;
    }

    // Set loading to true and disable button to prevent multiple clicks
    isLoading.value = true;

    final url = Uri.parse('${dotenv.env['BASE_URL']}/auth/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'username': username,
          'password': password,
          'full_name': fullName,
        }),
      );

      // Hide loading indicator after request is finished
      isLoading.value = false;

      if (response.statusCode == 201) {
        Get.snackbar('Success', 'User registered successfully');
        Get.offNamed('/login');
      } else {
        // If registration fails, display error and re-enable button
        Get.snackbar('Error', 'Registration failed: ${response.statusCode}');
      }
    } catch (e) {
      // Handle error case
      isLoading.value = false;
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      // Always re-enable the button after operation
      isButtonDisabled.value = false;
    }
  }

  // Fungsi validasi email (Anda bisa menggunakan regex untuk validasi email)
  bool isValidEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return regex.hasMatch(email);
  }
}
