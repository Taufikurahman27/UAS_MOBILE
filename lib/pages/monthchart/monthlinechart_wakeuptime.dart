import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MonthLineChart1 extends StatefulWidget {
  final List<double?> data;
  final DateTime startDate;

  MonthLineChart1({required this.data, required this.startDate});

  @override
  _MonthLineChart1State createState() => _MonthLineChart1State();
}

class _MonthLineChart1State extends State<MonthLineChart1> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double chartWidth = constraints.maxWidth * 0.9; // 90% of available width
      double chartHeight =
          constraints.maxHeight * 0.5; // 50% of available height

      if (constraints.maxHeight.isInfinite) {
        chartHeight = 200;
      }

      double fontSize = MediaQuery.of(context).size.width * 0.02;

      // Set minY and maxY to match the range from 06:00 to 12:00
      double minY = 2.0;
      double maxY = 12.0;

      // Generate the list of hours based on minY and maxY with a 1-hour interval
      List<double> yAxisLabels = [];
      for (double i = minY; i <= maxY; i += 1) {
        yAxisLabels.add(i);
      }

      return Padding(
        padding: const EdgeInsets.all(16), // Add padding for better spacing
        child: SizedBox(
          width: chartWidth, // Adjust the width as needed
          height: chartHeight, // Adjust the height as needed
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: false,
                drawVerticalLine: true,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.white.withOpacity(0.2),
                    strokeWidth: 1,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: Colors.white.withOpacity(0.2),
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 22,
                    getTitlesWidget: (value, meta) {
                      String weekText = '';
                      if (value == 0) {
                        weekText = 'Week 1';
                      } else if (value == 1) {
                        weekText = 'Week 2';
                      } else if (value == 2) {
                        weekText = 'Week 3';
                      } else if (value == 3) {
                        weekText = 'Week 4';
                      }

                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0), // Adjust this value as needed
                        child: Text(
                          weekText,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Urbanist',
                            fontSize: fontSize,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: 2, // Show every hour
                    getTitlesWidget: (value, meta) {
                      if (!yAxisLabels.contains(value)) return Container();

                      String hourText =
                          '${value.toInt().toString().padLeft(2, '0')}:00';
                      return Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(hourText,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontSize: fontSize,
                              )),
                        ),
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false), // Hide top titles
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false), // Hide right titles
                ),
              ),
              borderData: FlBorderData(
                show: false,
                border: Border.all(
                  color: const Color(0xff37434d),
                ),
              ),
              minX: 0,
              maxX: 3, // 4 weeks (Week 0, Week 1, Week 2, Week 3)
              minY: minY, // Set minY to 06:00
              maxY: maxY, // Set maxY to 12:00
              lineBarsData: [
                LineChartBarData(
                  spots: _createSpots(),
                  isCurved: false,
                  color: Color(0xFFFFC754),
                  barWidth: 2,
                  isStrokeCapRound: false,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (FlSpot spot, double xPercentage,
                        LineChartBarData bar, int index) {
                      return FlDotCirclePainter(
                        radius: 2,
                        color: Colors.white,
                        strokeWidth: 2,
                        strokeColor: Color.fromARGB(255, 255, 255, 255),
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: false,
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      int hours = spot.y.toInt();
                      int minutes = ((spot.y - hours) * 60).toInt();

                      String timeText =
                          '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';

                      return LineTooltipItem(
                        '$timeText\n',
                        const TextStyle(
                          color: Color(0xFFFFC754),
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  List<FlSpot> _createSpots() {
    List<FlSpot> spots = [];

    for (int i = 0; i < widget.data.length; i++) {
      if (widget.data[i] != null) {
        double yValue = widget.data[i]!;

        // Menyesuaikan yValue ke dalam rentang 02:00 hingga 12:00
        if (yValue < 2.0) {
          yValue = 2.0; // Menempatkan di jam 02:00 jika sebelum 02:00
        } else if (yValue > 12.0) {
          yValue = 12.0; // Menempatkan di jam 12:00 jika setelah 12:00
        }

        print(
            'Week $i: Adjusted yValue = $yValue'); // Debugging: see the yValue after adjustment
        spots.add(FlSpot(i.toDouble(), yValue));
      }
    }

    return spots;
  }
}
