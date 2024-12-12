import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mybalance/app/utils/color.dart';
import 'package:mybalance/app/utils/text.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About',
          style: TextStyle(
              fontSize: FontSize.extraLarge, fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.secondary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/icons/Mybe.png', // Pastikan Anda memiliki logo di folder assets
                    height: 100,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'MyBalance',
                    style: TextStyle(
                      fontSize: FontSize.display,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'About the App',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'MyBalance is a simple and intuitive app designed to help you manage your finances. With MyBalance, you can track your income and expenses effortlessly, ensuring better financial planning and management.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            const Text(
              'Features:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('- Add and track your income and expenses.',
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 4),
                Text('- View detailed reports and summaries.',
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 4),
                Text('- Secure your data with account protection.',
                    style: TextStyle(fontSize: 16)),
              ],
            ),
            const Spacer(),
            const Center(
              child: Column(
                children: [
                  Text(
                    'Developed by Ariel Zakly Pratama',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Contact: 11211017@student.itk.ac.id',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
