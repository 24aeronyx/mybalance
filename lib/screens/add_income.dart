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
        icon: _getCategoryIcon(_selectedCategory), // Get the appropriate icon based on category
        date: _selectedDate ?? DateTime.now(),
      );

      widget.onAddIncome(newIncome);
      Navigator.pop(context); // Go back after adding income
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Salary':
        return Icons.monetization_on;
      case 'Business':
        return Icons.business;
      case 'Gift':
        return Icons.card_giftcard;
      case 'Other':
        return Icons.category;
      default:
        return Icons.category;
    }
  }

  Color _getCategoryIconColor(String category) {
    return Color.fromRGBO(0, 74, 173, 1); // Set the icon color to blue
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
          'Add Income',
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
                items: <String>['Salary', 'Business', 'Gift', 'Other']
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
                child: const Text(
                  'Add Income',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 74, 173, 1),
                  minimumSize: const Size(double.infinity, 50), // Full-width button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners
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
