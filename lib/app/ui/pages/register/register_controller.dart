import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterController extends GetxController {
  var isLoading = false.obs;  // Untuk mengatur status loading
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
    String dateOfBirth,
    String phoneNumber,
    String address,
  ) async {
    if (email.isEmpty ||
        username.isEmpty ||
        password.isEmpty ||
        fullName.isEmpty ||
        dateOfBirth.isEmpty ||
        phoneNumber.isEmpty ||
        address.isEmpty) {
      Get.snackbar('Error', 'All fields are required');
      return;
    }

    isLoading.value = true; // Mengatur status loading menjadi true
    final url = Uri.parse('http://10.0.2.2:3005/auth/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'username': username,
          'password': password,
          'full_name': fullName,
          'date_of_birth': dateOfBirth,
          'phone_number': phoneNumber,
          'address': address,
        }),
      );

      isLoading.value = false; // Mengatur status loading menjadi false setelah request selesai
      if (response.statusCode == 201) {
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
}
