import 'package:flutter/material.dart';

class LatestTransactionsSection extends StatelessWidget {
  final VoidCallback viewMore;

  const LatestTransactionsSection({super.key, 
    required this.viewMore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Latest Transactions',
            style: TextStyle(
              color: Color.fromRGBO(0, 74, 173, 1),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          TextButton(
            onPressed: viewMore,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            child: const Row(
              children: [
                Text(
                  'View More',
                  style: TextStyle(
                    color: Color.fromRGBO(0, 74, 173, 1),
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward,
                  color: Color.fromRGBO(0, 74, 173, 1),
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
