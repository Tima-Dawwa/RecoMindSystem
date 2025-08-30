import 'package:dashboard/core/utils/theme.dart';
import 'package:dashboard/features/AI/model/statistics_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RecommindationsCharts extends StatefulWidget {
  const RecommindationsCharts({
    super.key,
    required this.title,
    required this.lineColor,
    required this.recommindationStatistics,
  });
  final String title;
  final Color lineColor;
  final StatisticsModel recommindationStatistics;
  @override
  State<RecommindationsCharts> createState() => _RecommindationsChartsState();
}

class _RecommindationsChartsState extends State<RecommindationsCharts> {
  List<double> values = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.recommindationStatistics.days.length; i++) {
      double value = 0;
      value =
          (widget.recommindationStatistics.days[i].value * 10000).truncate() /
          10000;
      values.add(double.parse(value.toStringAsFixed(4)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.23,
      height: MediaQuery.of(context).size.height * 0.35,
      child: LineChart(
        LineChartData(
          maxX: 8,
          minX: 0,
          minY: 0.0,
          maxY: 1.0,
          backgroundColor: Themes.text.withAlpha(20),
          gridData: FlGridData(drawHorizontalLine: false),
          extraLinesData: ExtraLinesData(extraLinesOnTop: false),
          borderData: FlBorderData(
            border: Border.all(color: Themes.text, width: 1.5),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipMargin: 10,
              tooltipBorderRadius: BorderRadius.circular(10),
              tooltipPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              getTooltipColor: (touchedSpot) {
                return Themes.text;
              },
              getTooltipItems: (touchedSpots) {
                return [
                  LineTooltipItem(
                    touchedSpots[0].y.toString(),
                    TextStyle(color: Themes.bg, fontSize: 15),
                  ),
                ];
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              color: widget.lineColor,
              isCurved: true,
              curveSmoothness: 0.25,
              preventCurveOverShooting: true,
              shadow: Shadow(color: widget.lineColor),
              belowBarData: BarAreaData(
                show: true,
                color: Themes.text.withAlpha(40),
              ),
              spots: [
                FlSpot(0, 0),
                FlSpot(1, values[0]),
                FlSpot(2, values[1]),
                FlSpot(3, values[2]),
                FlSpot(4, values[3]),
                FlSpot(5, values[4]),
                FlSpot(6, values[5]),
                FlSpot(7,values[6]),
                FlSpot(8, 0),
              ],
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
                          ? 'Sun'
                          : value == 2
                          ? 'Mon'
                          : value == 3
                          ? 'Tus'
                          : value == 4
                          ? 'Wed'
                          : value == 5
                          ? 'Thu'
                          : value == 6
                          ? 'Fri'
                          : value == 7
                          ? 'Sat'
                          : '',
                      style: TextStyle(color: Themes.text, fontSize: 14),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: Text(
                "Accuracy",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      value == 0
                          ? '0.0'
                          : value == 0.2
                          ? '0.2'
                          : value == 0.4
                          ? '0.4'
                          : value == 0.8
                          ? '0.8'
                          : value == 1.0
                          ? '1.0'
                          : '0.6',
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
                      value == 4 ? widget.title : "",
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
