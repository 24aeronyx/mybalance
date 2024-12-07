import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mybalance/app/ui/pages/reports/reports_controller.dart';
import 'package:mybalance/app/utils/color.dart';
import 'package:mybalance/app/utils/text.dart';
import 'package:get/get.dart';

class ReportsPage extends GetView<ReportsController> {
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
                    padding: const EdgeInsets.all(20),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Column(
                      children: [
                        Text(
                          'Income',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 10),
                        Text('Rp.15.000',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: FontSize.extraLarge,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Container(
                      height: 60,
                      width: 1,
                      color: const Color.fromRGBO(255, 255, 255, 0.4),
                    ),
                    const Column(
                      children: [
                        Text('Outcome', style: TextStyle(color: Colors.white)),
                        SizedBox(height: 10),
                        Text('Rp.15.000',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: FontSize.extraLarge,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filter:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: FontSize.large,
                    ),
                  ),
                  Obx(() {
                    return DropdownButton<String>(
                      value: controller.selectedFilter.value,
                      onChanged: (value) {
                        if (value != null) {
                          controller.updateFilter(value);
                        }
                      },
                      items: controller.filters.map((option) {
                        return DropdownMenuItem(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
