import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mybalance/app/ui/pages/income/income_controller.dart';

class IncomePage extends GetView<IncomeController> {
  const IncomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Income')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  controller.amount.value = double.tryParse(value) ?? 0.0;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (value) {
                  controller.description.value = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (value) {
                  controller.title.value = value;
                },
              ),
              DropdownButtonFormField<String>(
                value: controller.category.value.isEmpty ? null : controller.category.value,
                onChanged: (newCategory) {
                  controller.category.value = newCategory ?? '';
                },
                items: controller.validCategories
                    .map((category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                onChanged: (value) {
                  controller.date.value = value;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  controller.addIncome();
                },
                child: const Text('Add Income'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
