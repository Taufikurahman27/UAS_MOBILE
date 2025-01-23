import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class SleepLineChart1 extends StatefulWidget {
  final List<double?> data;
  final DateTime startDate;

  SleepLineChart1({required this.data, required this.startDate});

  @override
  _SleepLineChart1State createState() => _SleepLineChart1State();
}

class _SleepLineChart1State extends State<SleepLineChart1> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double chartWidth = constraints.maxWidth * 0.9;
        double chartHeight = constraints.maxHeight * 0.5;

        if (constraints.maxHeight.isInfinite) {
          chartHeight = 200;
        }

        double fontSize = MediaQuery.of(context).size.width * 0.02;

        // Menentukan nilai minY dan maxY sesuai dengan rentang 02:00 hingga 12:00
        double minY = 2.0;
        double maxY = 12.0;

        // Menyiapkan label jam untuk sumbu Y
        List<double> yAxisLabels = [];
        for (double i = minY; i <= maxY; i += 2) {
          yAxisLabels.add(i);
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: chartWidth,
            height: chartHeight,
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
                        DateTime date = widget.startDate.add(Duration(days: value.toInt()));
                        String dayText = DateFormat('EEE').format(date);
                        return FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(dayText,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontSize: fontSize,
                              )),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        if (!yAxisLabels.contains(value)) return Container();

                        String hourText = '${value.toInt().toString().padLeft(2, '0')}:00';
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
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: false,
                  border: Border.all(
                    color: const Color(0xff37434d),
                  ),
                ),
                minX: 0,
                maxX: 6,
                minY: minY,
                maxY: maxY,
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
                        double originalY = widget.data[spot.x.toInt()]!;
                        int hours = originalY.toInt();
                        int minutes = ((originalY - hours) * 60).toInt();

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
      },
    );
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

        print('Hari ke-$i: Adjusted yValue = $yValue');
        spots.add(FlSpot(i.toDouble(), yValue));
      }
    }

    return spots;
  }
}
