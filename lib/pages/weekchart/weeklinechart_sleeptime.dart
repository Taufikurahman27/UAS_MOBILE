import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class SleepLineChart extends StatefulWidget {
  final List<double?> data;
  final DateTime startDate;

  SleepLineChart({required this.data, required this.startDate});

  @override
  _SleepLineChartState createState() => _SleepLineChartState();
}

class _SleepLineChartState extends State<SleepLineChart> {
  @override
  Widget build(BuildContext context) {
    final double minY = 20.0; // 20:00 (8 PM)
    final double maxY = 30.0; // 30.0 berarti 06:00 (6 AM keesokan harinya)

    return LayoutBuilder(
      builder: (context, constraints) {
        double chartWidth = constraints.maxWidth * 0.9;
        double chartHeight = constraints.maxHeight * 0.5;

        if (constraints.maxHeight.isInfinite) {
          chartHeight = 200;
        }

        double fontSize = MediaQuery.of(context).size.width * 0.02;

        return Padding(
          padding: const EdgeInsets.all(16.0),
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
                        DateTime date =
                            widget.startDate.add(Duration(days: value.toInt()));
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
                        int hours = value.toInt();
                        int minutes = ((value - hours) * 60).toInt();

                        if (hours >= 24) {
                          hours -= 24;
                        }

                        String text =
                            '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
                        return Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(text,
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
                    color: Color(0xFFFF5999),
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
                    preventCurveOverShooting: true,
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        double originalY = _getOriginalYValue(spot.x.toInt());
                        int hours = originalY.toInt();
                        int minutes = ((originalY - hours) * 60).toInt();

                        if (hours >= 24) {
                          hours -= 24;
                        }

                        String timeText =
                            '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';

                        return LineTooltipItem(
                          '$timeText\n',
                          const TextStyle(
                            color: Colors.pink,
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
    double minY = 20.0;
    double maxY = 30.0;

    List<FlSpot> spots = [];

    for (int i = 0; i < widget.data.length; i++) {
      if (widget.data[i] != null) {
        double yValue = widget.data[i]!;
        double adjustedY = yValue;

        // Mengatur nilai yValue menjadi format 24 jam
        if (yValue < 6) {
          yValue += 24;
        }

        // Batas untuk visualisasi
        if (yValue < minY) {
          adjustedY = minY; // Letakkan pada batas bawah (20:00)
        } else if (yValue > maxY) {
          adjustedY = maxY; // Letakkan pada batas atas (06:00)
        } else {
          adjustedY = yValue; // Tetap gunakan nilai asli
        }

        spots.add(FlSpot(i.toDouble(), adjustedY));
      }
    }

    return spots;
  }

  double _getOriginalYValue(int index) {
    double? originalY = widget.data[index];
    if (originalY != null) {
      if (originalY < 6) {
        return originalY +
            24.0; // Konversi dari 0-6 ke 24-30 untuk representasi
      } else if (originalY >= 20) {
        return originalY; // Nilai asli dalam batas 20-30
      } else {
        return originalY; // Nilai asli untuk jam lainnya
      }
    }
    return 20.0; // Nilai default jika tidak ada data
  }
}
