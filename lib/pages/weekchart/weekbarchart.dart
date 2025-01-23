import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class WeekBarChart extends StatefulWidget {
  final List<double> sleepData;
  final DateTime startDate;

  WeekBarChart({required this.sleepData, required this.startDate});

  @override
  _WeekBarChartState createState() => _WeekBarChartState();
}

class _WeekBarChartState extends State<WeekBarChart> {
  int touchedIndex = -1; // Menyimpan index yang disentuh

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double chartWidth =
            constraints.maxWidth * 0.9; // 90% dari lebar yang tersedia
        double chartHeight =
            constraints.maxHeight * 0.5; // 50% dari tinggi yang tersedia
        double barWidth =
            chartWidth / (7 * 1.5); // 7 hari dengan jarak antar bar

        if (constraints.maxHeight.isInfinite) {
          chartHeight = 200;
        }

        double fontSize = MediaQuery.of(context).size.width * 0.02;

        double minY = 2.0;
        double maxY = 12.0;

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
                        // Mengambil tanggal dari hari pertama di minggu tersebut
                        DateTime date =
                            widget.startDate.add(Duration(days: value.toInt()));
                        String dayText = DateFormat('EEE').format(date);

                        return FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(dayText,
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
                      interval: 2, // Menampilkan setiap interval 2 jam
                      getTitlesWidget: (value, meta) {
                        if (value < minY || value > maxY) return Container();

                        String hourText =
                            '${value.toInt().toString().padLeft(2, '0')}j';
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
                minY: minY, // Set minY ke 2j
                maxY: maxY, // Set maxY ke 12j
              ),
            ),
          ),
        );
      },
    );
  }

  List<BarChartGroupData> _createBarGroups(double barWidth) {
    return List.generate(7, (index) {
      double value = widget.sleepData[index];
      double displayedValue = value > 12.0 ? 12.0 : value;

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