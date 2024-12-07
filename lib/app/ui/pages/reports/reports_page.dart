import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mybalance/app/utils/color.dart';
import 'package:mybalance/app/utils/text.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: AppBar(
              backgroundColor: AppColors.secondary,
              flexibleSpace: SafeArea(
                child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: const Color.fromRGBO(0, 0, 0, 0.3)),
                          ),
                          child: const Icon(FontAwesome.angle_left_solid,
                              size: 30, color: Colors.black),
                        ),
                        const Text(
                          'Reports',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: FontSize.extraLarge),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: const Color.fromRGBO(0, 0, 0, 0.3)),
                          ),
                          child: const Icon(Clarity.cog_line,
                              size: 30, color: Colors.black),
                        ),
                      ],
                    )),
              ))),
      body: Column(),
    );
  }
}
