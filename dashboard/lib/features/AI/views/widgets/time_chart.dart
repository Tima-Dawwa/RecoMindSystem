import 'package:dashboard/core/utils/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TimeChart extends StatelessWidget {
  const TimeChart({super.key, required this.title, required this.xAxis});
  final String title;
  final List<String> xAxis;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.35,
      height: MediaQuery.of(context).size.height * 0.4,
      child: ScatterChart(
        ScatterChartData(
          minX: 0,
          maxX: 4,
          minY: 0,
          maxY: 4, //the biggest time , modify it to int
          backgroundColor: Themes.text.withAlpha(25),
          borderData: FlBorderData(
            border: Border.all(color: Themes.text, width: 1.5),
          ),
          scatterTouchData: ScatterTouchData(
            enabled: true,
            touchTooltipData: ScatterTouchTooltipData(
              tooltipBorderRadius: BorderRadius.circular(10),
              tooltipPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              getTooltipColor: (touchedSpot) {
                return Themes.text;
              },
              getTooltipItems: (touchedSpots) {
                return ScatterTooltipItem(
                  touchedSpots.y.toString(),
                  textStyle: TextStyle(color: Themes.bg, fontSize: 15),
                  bottomMargin: 10,
                );
              },
            ),
          ),
          scatterSpots: [
            ScatterSpot(
              1,
              2,
              dotPainter: FlDotCirclePainter(color: Themes.primary, radius: 7),
            ),
            ScatterSpot(
              2,
              1,
              dotPainter: FlDotCirclePainter(
                color: Themes.secondary,
                radius: 7,
              ),
            ),
            ScatterSpot(
              3,
              3,
              dotPainter: FlDotCirclePainter(color: Themes.third, radius: 7),
            ),
          ],
          titlesData: FlTitlesData(
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      value == 0
                          ? ''
                          : value == 1
                          ? xAxis[0]
                          : value == 2
                          ? xAxis[1]
                          : value == 3
                          ? xAxis[2]
                          : value == 4
                          ? ''
                          : '',
                      style: TextStyle(color: Themes.text, fontSize: 16),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: Text(
                "Seconds",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      value == 0
                          ? '0'
                          : value == 1
                          ? '1'
                          : value == 2
                          ? '2'
                          : value == 3
                          ? '3'
                          : value == 4
                          ? '4'
                          : '',
                      style: TextStyle(color: Themes.text, fontSize: 12),
                    ),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, _) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      value == 2 ? title : "",
                      style: TextStyle(
                        color: Themes.text,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
