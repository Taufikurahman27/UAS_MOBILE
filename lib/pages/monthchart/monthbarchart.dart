import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MonthBarChart extends StatefulWidget {
  final List<double> sleepData;
  final DateTime startDate;

  MonthBarChart({required this.sleepData, required this.startDate});

  @override
  _MonthBarChartState createState() => _MonthBarChartState();
}

class _MonthBarChartState extends State<MonthBarChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double chartWidth = constraints.maxWidth * 0.9;
        double chartHeight = constraints.maxHeight * 0.5;
        double barWidth =
            chartWidth / (4 * 1.5); // 4 minggu dengan jarak antar bar

        if (constraints.maxHeight.isInfinite) {
          chartHeight = 200;
        }

        double fontSize = MediaQuery.of(context).size.width * 0.02;

        double minY = 40.0;
        double maxY = 90.0;

        return Center(
          child: SizedBox(
            width: chartWidth,
            height: chartHeight,
            child: BarChart(
              BarChartData(
                barGroups: _createBarGroups(barWidth),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        String weekText = 'Week ${value.toInt() + 1}';
                        return FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(weekText,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Urbanist',
                                  fontSize: fontSize)),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 10, // Menampilkan setiap interval 10 jam
                      getTitlesWidget: (value, meta) {
                        if (value < minY || value > maxY) return Container();

                        String hourText = '${value.toInt()}j';
                        return FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(hourText,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Urbanist',
                                  fontSize: fontSize)),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
                barTouchData: BarTouchData(
                  touchCallback: (event, response) {
                    setState(() {
                      if (response != null && response.spot != null) {
                        touchedIndex = response.spot!.touchedBarGroupIndex;
                      } else {
                        touchedIndex = -1;
                      }
                    });
                  },
                  touchTooltipData: BarTouchTooltipData(
                    tooltipPadding: EdgeInsets.all(5),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      double originalValue =
                          widget.sleepData[group.x]; // Nilai asli
                      return BarTooltipItem(
                        '${originalValue.toInt()}j',
                        TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                minY: minY, // Set minY ke 40j
                maxY: maxY, // Set maxY ke 90j
              ),
            ),
          ),
        );
      },
    );
  }

  List<BarChartGroupData> _createBarGroups(double barWidth) {
    return List.generate(4, (index) {
      double value = widget.sleepData[index];
      double displayedValue = value > 90.0 ? 90.0 : value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: displayedValue,
            color: index == touchedIndex
                ? Colors.red
                : Color(0xFF60354A), // Mengubah warna saat disentuh
            width: barWidth,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
        ],
      );
    });
  }
}