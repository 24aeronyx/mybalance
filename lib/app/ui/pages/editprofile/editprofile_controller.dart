import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mybalance/app/ui/pages/profile/profile_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class EditProfileController extends GetxController {
  var fullName = ''.obs;
  var dateOfBirth = ''.obs;
  var phoneNumber = ''.obs;
  var address = ''.obs;
  var dataNotFound = false.obs;

  var fullNameController = TextEditingController();
  var dobController = TextEditingController();
  var phoneController = TextEditingController();
  var addressController = TextEditingController();

  // Validation Errors
  var fullNameError = ''.obs;
  var dobError = ''.obs;
  var phoneError = ''.obs;
  var addressError = ''.obs;

  final profileController = Get.find<ProfileController>();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  // Fetch Profile
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
        if (data['profile'] != null) {
          fullName.value = data['profile']['full_name'] ?? '';

          // Parse and format date of birth
          String rawDob = data['profile']['date_of_birth'] ?? '';
          if (rawDob.isNotEmpty) {
            try {
              DateTime dob = DateTime.parse(rawDob);
              dateOfBirth.value =
                  DateFormat('yyyy-MM-dd').format(dob); // Format to yyyy-MM-dd
            } catch (e) {
              dateOfBirth.value = ''; // Handle invalid date
            }
          }

          phoneNumber.value = data['profile']['phone_number'] ?? '';
          address.value = data['profile']['address'] ?? '';

          fullNameController.text = fullName.value;
          dobController.text = dateOfBirth.value;
          phoneController.text = phoneNumber.value;
          addressController.text = address.value;
        
        } else {
          dataNotFound.value = true;
        }
      } else if (response.statusCode == 401) {
        handleInvalidToken();
      } else {
        throw Exception('Failed to fetch profile: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error occurred: $e');
    }
  }

  // Handle invalid token
  void handleInvalidToken() {
    Get.snackbar('Session Expired', 'Please log in again.');
  }

  // Validation Methods
  bool validateFullName(String name) {
    if (name.isEmpty) {
      fullNameError.value = 'Full name is required';
      return false;
    } else if (RegExp(r'[0-9]').hasMatch(name)) {
      fullNameError.value = 'Full name cannot contain numbers';
      return false;
    }
    fullNameError.value = '';
    return true;
  }

  bool validateDOB(String dob) {
    if (dob.isEmpty) {
      dobError.value = 'Date of birth is required';
      return false;
    } else if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(dob)) {
      dobError.value = 'Date of birth must be in format yyyy-mm-dd';
      return false;
    }
    dobError.value = '';
    return true;
  }

  bool validatePhoneNumber(String phone) {
    if (phone.isEmpty) {
      phoneError.value = 'Phone number is required';
      return false;
    } else if (!RegExp(r'^\d+$').hasMatch(phone)) {
      phoneError.value = 'Phone number must contain only digits';
      return false;
    }
    phoneError.value = '';
    return true;
  }

  bool validateAddress(String addr) {
    if (addr.isEmpty) {
      addressError.value = 'Address is required';
      return false;
    }
    addressError.value = '';
    return true;
  }

  bool validateAll() {
    return validateFullName(fullNameController.text) &&
        validateDOB(dobController.text) &&
        validatePhoneNumber(phoneController.text) &&
        validateAddress(addressController.text);
  }

  // Update Profile
  Future<bool> updateProfile({
    required String fullName,
    required String dateOfBirth,
    required String phoneNumber,
    required String address,
  }) async {
    if (!validateAll()) {
      return false;
    }

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
        return true;
      } else {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error occurred while updating profile: $e');
      return false;
    }
  }

   Future<void> refreshMainProfile() async {
    await profileController.fetchProfile();
  }
}
