// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:mybalance/app/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class CheckTokenPage extends StatelessWidget {
  const CheckTokenPage({super.key});

  @override
  Widget build(BuildContext context) {
    _checkToken();
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      Get.offAllNamed(AppRoutes.main); // Arahkan ke main jika token ditemukan
    } else {
      Get.offAllNamed(AppRoutes.login); // Arahkan ke login jika token tidak ada
    }
  }
}