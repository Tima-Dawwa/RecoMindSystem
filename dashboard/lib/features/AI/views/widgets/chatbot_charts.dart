import 'package:dashboard/core/utils/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChatbotCharts extends StatefulWidget {
  const ChatbotCharts({super.key, required this.title});
  final String title;

  @override
  State<ChatbotCharts> createState() => _ChatbotChartsState();
}

class _ChatbotChartsState extends State<ChatbotCharts> {
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
                  toY: 0.92,
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
                  toY: 0.87,
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
                  toY: 0.33,
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
                  toY: 0.57,
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
                  toY: 0.98,
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
                  toY: 0.46,
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
                  toY: 0.73,
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
                          : value == 0.6
                          ? '0.6'
                          : value == 0.8
                          ? '0.8'
                          : '1.0',
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
