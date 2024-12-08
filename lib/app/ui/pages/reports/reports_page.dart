import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mybalance/app/utils/color.dart';
import 'package:mybalance/app/utils/text.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'reports_controller.dart';

class ReportsPage extends GetView<ReportsController> {
  const ReportsPage({super.key});

  // Function to format numbers in Indonesian style (k, jt, m, t)
  String formatYAxisLabel(double value) {
    if (value >= 1e9) {
      return '${(value / 1e9).toStringAsFixed(1)} t'; // trillion
    } else if (value >= 1e6) {
      return '${(value / 1e6).toStringAsFixed(1)} jt'; // million
    } else if (value >= 1e3) {
      return '${(value / 1e3).toStringAsFixed(1)} k'; // thousand
    } else {
      return value.toStringAsFixed(0); // no formatting for smaller numbers
    }
  }

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
                'Reports',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          // Income and Outcome Card
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Income Column
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Income',
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Obx(() {
                        return Text(
                          controller.totalIncome.value == 0
                              ? '-'
                              : NumberFormat.currency(
                                      locale: 'id_ID', symbol: 'Rp. ')
                                  .format(controller.totalIncome.value),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: FontSize.heading,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                // Separator
                Container(
                  height: 60,
                  width: 1,
                  color: const Color.fromRGBO(255, 255, 255, 0.4),
                ),
                // Outcome Column
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Outcome',
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Obx(() {
                        return Text(
                          controller.totalOutcome.value == 0
                              ? '-'
                              : NumberFormat.currency(
                                      locale: 'id_ID', symbol: 'Rp. ')
                                  .format(controller.totalOutcome.value),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: FontSize.heading,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Monthly and Yearly Filters
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Dropdown for selecting Month
                Obx(() {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton2<String>(
                      value: controller
                          .filters[controller.selectedMonth.value - 1],
                      onChanged: (value) {
                        if (value != null) {
                          controller.updateMonth(value);
                        }
                      },
                      items: controller.filters.map((month) {
                        return DropdownMenuItem<String>(
                          value: month,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              month,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      underline: const SizedBox.shrink(),
                      buttonStyleData: const ButtonStyleData(
                        height: 30,
                        padding: EdgeInsets.symmetric(horizontal: 6),
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
                        maxHeight:
                            200, // Batasi tinggi dropdown menjadi scrollable
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  );
                }),

                const SizedBox(width: 10),
                Obx(() {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton2<int>(
                      value: controller.selectedYear.value,
                      onChanged: (value) {
                        if (value != null) {
                          controller.updateYear(value);
                        }
                      },
                      items: controller.years.map((year) {
                        return DropdownMenuItem<int>(
                          value: year,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              year.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      underline: const SizedBox.shrink(),
                      buttonStyleData: const ButtonStyleData(
                        height: 30,
                        padding: EdgeInsets.symmetric(horizontal: 6),
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
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Bar chart for income and outcome
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Obx(() {
                bool hasData = controller.totalIncome.value > 0 ||
                    controller.totalOutcome.value > 0;

                if (!hasData) {
                  return const Text(
                    'No data available',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  );
                }

                return Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1.7,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceBetween,
                          maxY: 2000, // Sesuaikan dengan nilai maksimum data
                          gridData: FlGridData(
                            show: true,
                            drawHorizontalLine: true,
                            drawVerticalLine: false,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.black.withOpacity(0.1),
                                strokeWidth: 1,
                              );
                            },
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          barGroups: List.generate(
                              controller.weeklyIncomeData.length, (index) {
                            return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: controller.weeklyIncomeData[index],
                                  color: AppColors.income,
                                  width: 20,
                                  borderRadius: BorderRadius.zero,
                                ),
                                BarChartRodData(
                                  toY: controller.weeklyOutcomeData[index],
                                  color: AppColors.outcome,
                                  width: 20,
                                  borderRadius: BorderRadius.zero,
                                ),
                              ],
                            );
                          }),
                          titlesData: FlTitlesData(
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, titleMeta) {
                                  switch (value.toInt()) {
                                    case 0:
                                      return const Text('Week 1');
                                    case 1:
                                      return const Text('Week 2');
                                    case 2:
                                      return const Text('Week 3');
                                    case 3:
                                      return const Text('Week 4');
                                    default:
                                      return const Text('');
                                  }
                                },
                                reservedSize: 32,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, titleMeta) {
                                  return Text(
                                    formatYAxisLabel(value),
                                    style: const TextStyle(
                                        fontSize: 10, color: Colors.black),
                                  );
                                },
                                reservedSize: 32,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 20,
                                height: 10,
                                color: AppColors.income,
                              ),
                              const Text('Income'),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Column(
                            children: [
                              Container(
                                width: 20,
                                height: 10,
                                color: AppColors.outcome,
                              ),
                              const Text('Outcome'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              })),
        ]),
      ),
    );
  }
}
