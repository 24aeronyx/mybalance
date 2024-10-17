import 'package:flutter/material.dart';

class ShortcutButtons extends StatelessWidget {
  final VoidCallback addIncome;
  final VoidCallback addExpense;

  const ShortcutButtons({super.key, 
    required this.addIncome,
    required this.addExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -48),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: addIncome,
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(0, 74, 173, 1),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: const Icon(
                        Icons.monetization_on,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text('Add Income'),
                  ],
                ),
              ),
              GestureDetector(
                onTap: addExpense,
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(0, 74, 173, 1),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: const Icon(
                        Icons.money_off,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text('Add Outcome'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
