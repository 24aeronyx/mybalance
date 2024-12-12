import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mybalance/app/ui/pages/profile/profile_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Impor ProfileController

class EditProfileController extends ProfileController {
  var fullNameController = TextEditingController();
  var dobController = TextEditingController();
  var phoneController = TextEditingController();
  var addressController = TextEditingController();
  var isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    // Memanggil fetchProfile dan menunggu hingga selesai
    fetchProfile().then((_) {
      isLoading.value = false; // Data selesai diambil, hentikan loading
      setControllerValues();
    });
  }

  // Set controller values after fetching the profile
  void setControllerValues() {
    // Pastikan nilai telah di-set ke TextEditingController
    fullNameController.text = fullName.value;
    dobController.text = dateOfBirth.value;
    phoneController.text = phoneNumber.value;
    addressController.text = address.value;
  }

  // Method to update the profile
  Future<bool> updateProfile({
    required String fullName,
    required String dateOfBirth,
    required String phoneNumber,
    required String address,
  }) async {
    final url = Uri.parse('http://10.0.2.2:3005/profile');

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        handleInvalidToken();
        return false;
      }

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'full_name': fullName,
          'date_of_birth': dateOfBirth,
          'phone_number': phoneNumber,
          'address': address,
        }),
      );

      if (response.statusCode == 200) {
        // After successful update, fetch the updated profile
        fetchProfile(); // Refresh profile data
        return true; // Profile updated successfully
      } else {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error occurred while updating profile: $e');
      return false; // Return false if an error occurs
    }
  }
}
