import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mybalance/app/ui/pages/editprofile/editprofile_controller.dart';
import 'package:mybalance/app/utils/color.dart';
import 'package:mybalance/app/utils/text.dart'; // Replace with actual path to controller

class EditprofilePage extends GetView<EditProfileController> {
  const EditprofilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile",
            style: TextStyle(
                fontSize: FontSize.extraLarge, fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.secondary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
                child: CircularProgressIndicator()); // Tampilkan loading
          }

          // Menangani jika data profil tidak ditemukan
          if (controller.dataNotFound.value) {
            return const Center(child: Text('Profile not found'));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Full Name Input
                TextFormField(
                  controller: controller.fullNameController,
                  decoration: const InputDecoration(
                    labelText: "Full Name",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Date of Birth Input
                TextFormField(
                  controller: controller.dobController,
                  decoration: const InputDecoration(
                    labelText: "Date of Birth (yyyy-mm-dd)",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                const SizedBox(height: 20),

                // Phone Number Input
                TextFormField(
                  controller: controller.phoneController,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),

                // Address Input
                TextFormField(
                  controller: controller.addressController,
                  decoration: const InputDecoration(
                    labelText: "Address",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 30),

                // Save Button
                ElevatedButton(
                  onPressed: () {
                    // Get values from the text controllers
                    String fullName = controller.fullNameController.text;
                    String dateOfBirth = controller.dobController.text;
                    String phoneNumber = controller.phoneController.text;
                    String address = controller.addressController.text;

                    // Call the updateProfile function and handle result
                    controller
                        .updateProfile(
                      fullName: fullName,
                      dateOfBirth: dateOfBirth,
                      phoneNumber: phoneNumber,
                      address: address,
                    )
                        .then((success) {
                      if (success) {
                        Get.snackbar(
                          'Success',
                          'Profile updated successfully',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      } else {
                        Get.snackbar(
                          'Error',
                          'Failed to update profile',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, // Button color
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                        fontSize: FontSize.large,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  child: const Text("Save Changes"),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
