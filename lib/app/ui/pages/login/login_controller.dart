import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;
  var isButtonDisabled = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}").hasMatch(email);
  }

  Future<void> login(String emailOrUsername, String password) async {
    if (emailOrUsername.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Email/Username dan password wajib diisi');
      return;
    }

    if (!emailOrUsername.contains('@') && emailOrUsername.length < 4) {
      Get.snackbar('Error', 'Username harus lebih dari 3 karakter');
      return;
    }

    if (emailOrUsername.contains('@') && !isValidEmail(emailOrUsername)) {
      Get.snackbar('Error', 'Format email tidak valid');
      return;
    }

    // Disable button and show loading indicator
    isButtonDisabled.value = true;
    isLoading.value = true;

    final url = Uri.parse('${dotenv.env['BASE_URL']}/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'emailOrUsername': emailOrUsername,
          'password': password,
        }),
      );

      isLoading.value = false;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', data['token']);
          Get.offAllNamed('/main');
        } else {
          Get.snackbar('Error', 'Login berhasil tetapi token tidak ditemukan');
        }
      } else if (response.statusCode == 401) {
        Get.snackbar('Error', 'Email/Username atau password salah');
      } else {
        Get.snackbar('Error', 'Login gagal: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      // Always re-enable button
      isLoading.value = false;
      isButtonDisabled.value = false;
    }
  }
}
