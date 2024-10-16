import 'package:flutter/material.dart';
import '../models/transaction.dart';

class AddIncomeScreen extends StatefulWidget {
  final Function(Transaction) onAddIncome; // Callback function to add income

  AddIncomeScreen({Key? key, required this.onAddIncome}) : super(key: key);

  @override
  _AddIncomeScreenState createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  String _selectedCategory = 'Salary'; // Default category
  DateTime? _selectedDate;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      double amount = double.parse(_amountController.text);
      Transaction newIncome = Transaction(
        title: _selectedCategory,
        amount: amount,
        isExpense: false,
        icon: Icons.monetization_on, // You can change this based on category
        date: _selectedDate ?? DateTime.now(),
      );

      widget.onAddIncome(newIncome);
      Navigator.pop(context); // Go back after adding income
    }
  }

  void _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Income',
          style: TextStyle(
            color: Colors.white, // Change the title text color to white
            fontWeight: FontWeight.bold, // Make the title bold
          ),
        ),
        centerTitle: true, // Center the title
        backgroundColor: const Color.fromRGBO(0, 74, 173, 1),
        iconTheme: const IconThemeData(color: Colors.white), // Change the icon color to white
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: <String>['Salary', 'Business', 'Gift', 'Other']
                    .map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDate == null
                        ? 'No date chosen!'
                        : 'Selected date: ${_selectedDate!.toLocal()}'.split(' ')[0],
                  ),
                  TextButton(
                    onPressed: _selectDate,
                    child: const Text(
                      'Choose Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text(
                  'Add Income',
                  style: TextStyle(color: Colors.white), // Change button text color to white
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 74, 173, 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
