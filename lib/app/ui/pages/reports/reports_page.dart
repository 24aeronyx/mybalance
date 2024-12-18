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

  Color colorBuilder(String value) {
    switch (value) {
      case 'income':
        return Colors.blue; // Warna untuk Income
      case 'outcome':
        return Colors.red; // Warna untuk Outcome
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    controller.reset();
    controller.fetchAllTransactions(
        controller.selectedYear.value, controller.selectedMonth.value);
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
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary),
                ),
              ),
            ),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            // Show loading indicator while data is being fetched
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.dataNotFound.value) {
            // Show message when no data is found
            return const Center(
              child: Text(
                'No transactions found.',
                style: TextStyle(fontSize: 16, color: AppColors.primary),
              ),
            );
          }
          return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
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
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: FontSize.large),
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
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: FontSize.large),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Obx(() {
                    bool hasData = controller.totalIncome.value > 0 ||
                        controller.totalOutcome.value > 0;

                    if (!hasData) {
                      return const Text(
                        'No data available',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      );
                    }

                    return Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 1.7,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceBetween,
                              maxY: controller.getMaxY(),
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
                              barTouchData: BarTouchData(
                                enabled: true, // Enable touch events
                                touchCallback: (FlTouchEvent event,
                                    BarTouchResponse? touchResponse) {
                                  if (touchResponse != null &&
                                      touchResponse.spot != null) {
                                    int touchedIndex = touchResponse
                                        .spot!.touchedBarGroupIndex;
                                    double incomeValue = controller
                                        .weeklyIncomeData[touchedIndex];
                                    double outcomeValue = controller
                                        .weeklyOutcomeData[touchedIndex];

                                    // Format the income and outcome values
                                    String formattedIncome =
                                        NumberFormat.currency(
                                      locale: 'id_ID', // Indonesian locale
                                      symbol: 'Rp. ', // Currency symbol
                                    ).format(incomeValue);

                                    String formattedOutcome =
                                        NumberFormat.currency(
                                      locale: 'id_ID', // Indonesian locale
                                      symbol: 'Rp. ', // Currency symbol
                                    ).format(outcomeValue);

                                    // Update formatted values in the controller
                                    controller.updateFormattedValues(
                                        formattedIncome, formattedOutcome);
                                  }
                                },
                                longPressDuration:
                                    const Duration(milliseconds: 500),
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
                  }),
                ),
                Obx(
                  () => ToggleButtons(
                    isSelected: [
                      controller.selectedType.value == 'income',
                      controller.selectedType.value == 'outcome',
                    ],
                    onPressed: (index) {
                      if (index == 0) {
                        controller.toggleTransactionType('income');
                      } else {
                        controller.toggleTransactionType('outcome');
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    selectedColor: Colors.white,
                    fillColor: AppColors.primary,
                    color: Colors.black,
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Income',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: FontSize.large),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Outcome',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: FontSize.large),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() {
                  List<Map<String, dynamic>> data =
                      controller.selectedType.value == 'income'
                          ? controller.groupedIncomeData
                          : controller.groupedOutcomeData;

                  double total = data.fold(
                      0,
                      (sum, value) =>
                          sum + value['amount']); // Total seluruh amount

                  // Generate warna terang
                  List<Color> sectionColors =
                      controller.generateBrightColors(data.length);

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Pie Chart (diperkecil)
                      SizedBox(
                        width: 220, // Ukuran pie chart lebih kecil
                        height: 220,
                        child: PieChart(
                          PieChartData(
                            sections: List.generate(data.length, (index) {
                              double percentage = total > 0
                                  ? (data[index]['amount'] / total) * 100
                                  : 0;
                              return PieChartSectionData(
                                value: data[index]['amount'],
                                color: sectionColors[index], // Warna dinamis
                                title:
                                    '${percentage.toStringAsFixed(1)}%', // Persentase
                                radius: 90, // Radius pie lebih kecil
                                titleStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                titlePositionPercentageOffset: 1.2,
                              );
                            }),
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 2,
                            centerSpaceRadius: 0,
                          ),
                        ),
                      ),
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        direction: Axis.vertical,
                        children: List.generate(data.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5), // Spasi antar item
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 20,
                                  height: 10,
                                  color: sectionColors[index],
                                ),
                                const SizedBox(
                                    width: 8), // Jarak antara warna dan teks
                                // Title
                                Text(
                                  data[index]['title'], // Menampilkan title
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 20)
              ]));
        }));

    // Display the filtered transactions (based on type)
  }
}
