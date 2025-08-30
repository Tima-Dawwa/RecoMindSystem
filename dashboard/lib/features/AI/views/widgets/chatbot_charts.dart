import 'package:dashboard/core/utils/theme.dart';
import 'package:dashboard/features/AI/model/statistics_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChatbotCharts extends StatefulWidget {
  const ChatbotCharts({
    super.key,
    required this.title,
    required this.chatbotStatistics,
  });
  final String title;
  final StatisticsModel chatbotStatistics;

  @override
  State<ChatbotCharts> createState() => _ChatbotChartsState();
}

class _ChatbotChartsState extends State<ChatbotCharts> {
  List<double> values = [];
  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.chatbotStatistics.days.length; i++) {
      double value = 0;
      value =
          (widget.chatbotStatistics.days[i].value * 10000).truncate() / 10000;
      values.add(double.parse(value.toStringAsFixed(4)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.23,
      height: MediaQuery.of(context).size.height * 0.35,
      child: BarChart(
        BarChartData(
          minY: 0,
          maxY: 1,
          backgroundColor: Themes.text.withAlpha(25),
          gridData: FlGridData(drawVerticalLine: false),
          borderData: FlBorderData(
            border: Border.all(color: Themes.text, width: 1.5),
          ),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipMargin: 10,
              tooltipPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              tooltipBorderRadius: BorderRadius.circular(10),
              getTooltipColor: (touchedSpot) {
                return Themes.text;
              },
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  rod.toY.toString(),
                  TextStyle(color: Themes.bg, fontSize: 15),
                );
              },
            ),
          ),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: values[0],
                  width: 12,
                  color: Themes.primary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: values[1],
                  width: 12,
                  color: Themes.secondary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
                ),
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                  toY: values[2],
                  width: 12,
                  color: Themes.third,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
                ),
              ],
            ),
            BarChartGroupData(
              x: 3,
              barRods: [
                BarChartRodData(
                  toY: values[3],
                  width: 12,
                  color: Themes.text,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
                ),
              ],
            ),
            BarChartGroupData(
              x: 4,
              barRods: [
                BarChartRodData(
                  toY: values[4],
                  width: 12,
                  color: Themes.third,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
                ),
              ],
            ),
            BarChartGroupData(
              x: 5,
              barRods: [
                BarChartRodData(
                  toY: values[5],
                  width: 12,
                  color: Themes.secondary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
                ),
              ],
            ),
            BarChartGroupData(
              x: 6,
              barRods: [
                BarChartRodData(
                  toY: values[6],
                  width: 12,
                  color: Themes.primary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
                ),
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
                          ? 'Sun'
                          : value == 1
                          ? 'Mon'
                          : value == 2
                          ? 'Tus'
                          : value == 3
                          ? 'Wed'
                          : value == 4
                          ? 'Thu'
                          : value == 5
                          ? 'Fri'
                          : 'Sat',
                      style: TextStyle(color: Themes.text, fontSize: 14),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: Text(
                "Similarity",
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
                      value == 3 ? widget.title : "",
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
