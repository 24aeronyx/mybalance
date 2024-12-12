import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mybalance/app/utils/color.dart';
import 'package:mybalance/app/utils/text.dart';
import 'package:mybalance/app/ui/pages/outcome/outcome_controller.dart';

class OutcomePage extends GetView<OutcomeController> {
  const OutcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Outcome",
          style: TextStyle(
            fontSize: FontSize.extraLarge,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        backgroundColor: AppColors.secondary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount Input
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Amount",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  controller.amount.value = double.tryParse(value) ?? 0.0;
                },
              ),
              const SizedBox(height: 20),

              // Description Input
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  controller.description.value = value;
                },
              ),
              const SizedBox(height: 20),

              // Title Input
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
                onChanged: (value) {
                  controller.title.value = value;
                },
              ),
              const SizedBox(height: 20),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: controller.category.value.isEmpty
                    ? null
                    : controller.category.value,
                onChanged: (newCategory) {
                  controller.category.value = newCategory ?? '';
                },
                items: controller.validCategories
                    .map((category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    controller.date.value =
                        '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
                  }
                },
                child: AbsorbPointer(
                  child: Obx(() => TextFormField(
                        controller:
                            TextEditingController(text: controller.date.value),
                        decoration: const InputDecoration(
                          labelText: "Transaction Date (yyyy-mm-dd)",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                          suffixIcon: Icon(
                            BoxIcons.bx_calendar,
                            size: 30,
                            color: AppColors.primary,
                          ),
                        ),
                      )),
                ),
              ),

              const SizedBox(height: 30),

              // Add Outcome Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller.addOutcome();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Add Outcome",
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
        ),
      ),
    );
  }
}
