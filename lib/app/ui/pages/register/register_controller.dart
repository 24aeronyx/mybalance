import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterController extends GetxController {
  var isLoading = false.obs; // Untuk mengatur status loading
  var isPasswordVisible = false.obs; // Variable untuk visibilitas password

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
    // Validasi input email
    if (email.isEmpty) {
      Get.snackbar('Error', 'Email is required');
      return;
    }
    if (!email.contains('@') || !isValidEmail(email)) {
      Get.snackbar('Error', 'Please provide a valid email address');
      return;
    }

    // Validasi username
    if (username.isEmpty || username.length < 3) {
      Get.snackbar('Error', 'Username must be at least 3 characters long');
      return;
    }

    // Validasi password
    if (password.isEmpty) {
      Get.snackbar('Error', 'Password is required');
      return;
    }
    if (password.length < 8) {
      Get.snackbar('Error', 'Password must be at least 8 characters long');
      return;
    }
    if (!password.contains(RegExp(r'\d'))) {
      Get.snackbar('Error', 'Password must contain at least one number');
      return;
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      Get.snackbar('Error', 'Password must contain at least one uppercase letter');
      return;
    }

    // Validasi full name
    if (fullName.isEmpty) {
      Get.snackbar('Error', 'Full name is required');
      return;
    }

    isLoading.value = true; // Mengatur status loading menjadi true
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

      isLoading.value = false; // Mengatur status loading menjadi false setelah request selesai
      if (response.statusCode == 201) {
        // ignore: unused_local_variable
        final data = jsonDecode(response.body);
        Get.snackbar('Success', 'User registered successfully');
        Get.offNamed('/login'); // Arahkan pengguna ke halaman login setelah sukses
      } else {
        Get.snackbar('Error', 'Registration failed: ${response.statusCode}');
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }

  // Fungsi validasi email (Anda bisa menggunakan regex untuk validasi email)
  bool isValidEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return regex.hasMatch(email);
  }
}
