import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mybalance/app/ui/pages/editprofile/editprofile_controller.dart';
import 'package:mybalance/app/utils/color.dart';
import 'package:mybalance/app/utils/text.dart';

class EditprofilePage extends GetView<EditProfileController> {
  const EditprofilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            fontSize: FontSize.extraLarge,
            fontWeight: FontWeight.w600,
            color: AppColors.primary
          ),
        ),
        backgroundColor: AppColors.secondary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
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

                // Date of Birth Input (with Date Picker)
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      controller.dobController.text =
                          '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: controller.dobController,
                      decoration: const InputDecoration(
                        labelText: "Date of Birth (yyyy-mm-dd)",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                        suffixIcon: Icon(BoxIcons.bx_calendar, size: 30, color: AppColors.primary,),
                      ),
                    ),
                  ),
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      String fullName = controller.fullNameController.text;
                      String dateOfBirth = controller.dobController.text;
                      String phoneNumber = controller.phoneController.text;
                      String address = controller.addressController.text;

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
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Save Changes",
                      style: TextStyle(
                        fontSize: FontSize.large,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
