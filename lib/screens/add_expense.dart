import 'package:flutter/material.dart';
import '../models/transaction.dart';

class AddExpenseScreen extends StatefulWidget {
  final Function(Transaction) onAddExpense; // Callback function to add expense

  AddExpenseScreen({Key? key, required this.onAddExpense}) : super(key: key);

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  String _selectedCategory = 'Groceries'; // Default category
  DateTime? _selectedDate;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      double amount = double.parse(_amountController.text);
      Transaction newExpense = Transaction(
        title: _selectedCategory,
        amount: amount,
        isExpense: true,
        icon: Icons.shopping_cart, // You can change this based on category
        date: _selectedDate ?? DateTime.now(),
      );

      widget.onAddExpense(newExpense);
      Navigator.pop(context); // Go back after adding expense
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
        title: const Text('Add Expense'),
        backgroundColor: const Color.fromRGBO(0, 74, 173, 1),
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
                items: <String>['Groceries', 'Utilities', 'Entertainment', 'Other']
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
                child: const Text('Add Expense'),
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
