import 'package:flutter/material.dart';
import '../models/transaction.dart';

class AddExpenseScreen extends StatefulWidget {
  final Function(Transaction) onAddExpense; // Callback function to add expense

  const AddExpenseScreen({super.key, required this.onAddExpense});

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
        icon: _getCategoryIcon(_selectedCategory), // Get the appropriate icon based on category
        date: _selectedDate ?? DateTime.now(),
      );

      widget.onAddExpense(newExpense);
      Navigator.pop(context); // Go back after adding expense
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Groceries':
        return Icons.shopping_cart;
      case 'Utilities':
        return Icons.lightbulb;
      case 'Entertainment':
        return Icons.movie;
      case 'Other':
        return Icons.category;
      default:
        return Icons.category;
    }
  }

  Color _getCategoryIconColor(String category) {
    return const Color.fromRGBO(0, 74, 173, 1); // Set the icon color to blue
  }

  void _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate; // Update the selected date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Expense',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(0, 74, 173, 1),
        iconTheme: const IconThemeData(color: Colors.white),
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
                    child: Row(
                      children: [
                        Icon(
                          _getCategoryIcon(category), // Display category icon
                          color: _getCategoryIconColor(category), // Set icon color to blue
                        ),
                        const SizedBox(width: 8),
                        Text(category),
                      ],
                    ),
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
              GestureDetector(
                onTap: _selectDate,
                child: TextFormField(
                  readOnly: true, // Make the field read-only
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today, color: Color.fromRGBO(0, 74, 173, 1)), // Change calendar icon color to blue
                  ),
                  controller: TextEditingController(
                    text: _selectedDate == null
                        ? 'No date chosen!'
                        : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}', // Show the selected date
                  ),
                  onTap: _selectDate,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 74, 173, 1),
                  minimumSize: const Size(double.infinity, 50), // Full-width button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  ),
                ),
                child:  Text(
                  'Add Expense',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
