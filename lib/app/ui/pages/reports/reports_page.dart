import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mybalance/app/ui/pages/reports/reports_controller.dart';
import 'package:mybalance/app/utils/color.dart';
import 'package:mybalance/app/utils/text.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class ReportsPage extends GetView<ReportsController> {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(90),
            child: AppBar(
              backgroundColor: AppColors.secondary,
              flexibleSpace: const SafeArea(
                child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Reports',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    )),
              ),
            )),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            Container(
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButton2<String>(
                        value: controller.selectedFilter.value,
                        onChanged: (value) {
                          if (value != null) {
                            controller.updateFilter(value);
                          }
                        },
                        items: controller.filters.map((option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10), // Padding teks
                              child: Text(
                                option,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        underline:
                            const SizedBox.shrink(), // Menghilangkan underline
                        buttonStyleData: const ButtonStyleData(
                          height: 30,
                          padding: EdgeInsets.symmetric(
                              horizontal: 6), // Padding button
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(FontAwesome.angle_down_solid),
                          iconSize: 14,
                          iconEnabledColor: Colors.black,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets
                              .zero, // Untuk menghilangkan padding default dropdown
                        ),
                      ),
                    );
                  }),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(BoxIcons.bxs_chevron_down, color: AppColors.income,),
                          Text('Income')
                        ],
                      ),
                      SizedBox(width: 10),
                      Row(
                        children: [
                          Icon(BoxIcons.bxs_chevron_up, color: AppColors.outcome),
                          Text('Outcome')
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ]),
        ));
  }
}
