import 'package:flutter/material.dart';
import 'package:mybalance/app/utils/color.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            backgroundColor: AppColors.secondary,
            flexibleSpace: const SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'History',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ),
        body: Center(
          child: Row(
            children: [],
          ),
        ));
  }
}
