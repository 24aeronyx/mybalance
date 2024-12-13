import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  var fullName = ''.obs;
  var dateOfBirth = ''.obs;
  var phoneNumber = ''.obs;
  var address = ''.obs;
  var dataNotFound = false.obs;

  // Method untuk fetch data profile
  @override
  void onInit() {
    super.onInit();
    fetchProfile(); 
  }

  void reset() {
    fullName.value = '';
    dateOfBirth.value = '';
    phoneNumber.value = ''; // Clear the list
    address.value = '';
    dataNotFound.value = false;
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
        if (data['profile'] != null) {
          fullName.value = data['profile']['full_name'] ?? '';

          // Parse and manually format date_of_birth
          String dob = data['profile']['date_of_birth'] ?? '';
          if (dob.isNotEmpty) {
            DateTime parsedDate = DateTime.parse(dob);
            dateOfBirth.value =
                '${parsedDate.day.toString().padLeft(2, '0')} ${_getMonthName(parsedDate.month)} ${parsedDate.year}';
          }

          phoneNumber.value = data['profile']['phone_number'] ?? '';
          address.value = data['profile']['address'] ?? '';
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

  void handleInvalidToken() {
    // Handle invalid token here, like logging out the user or redirecting to login page
    Get.snackbar('Session Expired', 'Please log in again.');
  }

  // Custom method to get month name in English
  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  Future<void> logout() async {
    final url = Uri.parse('${dotenv.env['BASE_URL']}/auth/logout');
    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        // Clear token from SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');

        // Navigate to login page
        Get.offAllNamed('/login');
      } else {
        Get.snackbar('Error', 'Logout gagal: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }
}
