import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ReportsChart extends StatelessWidget {
  final List<double> weeklyData;

  const ReportsChart({super.key, required this.weeklyData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.only(left: 4.0),
      child: BarChart(
        BarChartData(
          barGroups: [
            _buildBarChartGroup('Week 1', weeklyData[0], weeklyData[1]),
            _buildBarChartGroup('Week 2', weeklyData[2], weeklyData[3]),
            _buildBarChartGroup('Week 3', 0, 0), // Dummy values for Week 3
            _buildBarChartGroup('Week 4', 0, 0), // Dummy values for Week 4
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 60,
                getTitlesWidget: (value, meta) {
                  return Text(
                    _formatYAxisLabel(value),
                    style: const TextStyle(fontSize: 12),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
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
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          gridData: const FlGridData(show: true),
        ),
      ),
    );
  }

  String _formatYAxisLabel(double value) {
    if (value >= 1e9) {
      return '${(value / 1e9).toStringAsFixed(1)} B'; // Miliar
    } else if (value >= 1e6) {
      return '${(value / 1e6).toStringAsFixed(1)} M'; // Juta
    } else if (value >= 1e3) {
      return '${(value / 1e3).toStringAsFixed(1)} K'; // Ribu
    }
    return value.toString();
  }

  BarChartGroupData _buildBarChartGroup(String week, double income, double expense) {
    return BarChartGroupData(
      x: week == 'Week 1' ? 0 : week == 'Week 2' ? 1 : week == 'Week 3' ? 2 : 3,
      barRods: [
        BarChartRodData(
          toY: income,
          color: Colors.green,
          width: 10,
          borderRadius: BorderRadius.circular(5),
        ),
        BarChartRodData(
          toY: expense,
          color: Colors.red,
          width: 10,
          borderRadius: BorderRadius.circular(5),
        ),
      ],
    );
  }
}
