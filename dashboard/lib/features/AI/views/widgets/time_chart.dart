import 'package:dashboard/core/utils/theme.dart';
import 'package:dashboard/features/AI/model/time_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TimeChart extends StatefulWidget {
  const TimeChart({
    super.key,
    required this.title,
    required this.xAxis,
    required this.time,
  });
  final String title;
  final List<String> xAxis;
  final List<TimeModel> time;

  @override
  State<TimeChart> createState() => _TimeChartState();
}

class _TimeChartState extends State<TimeChart> {
  List<double> values = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.time.length; i++) {
      double value = 0;
      value = (widget.time[i].value * 10000).truncate() / 10000;
      values.add(double.parse(value.toStringAsFixed(4)));
    }
  }

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
              values[0],
              dotPainter: FlDotCirclePainter(color: Themes.primary, radius: 7),
            ),
            ScatterSpot(
              2,
              values[1],
              dotPainter: FlDotCirclePainter(
                color: Themes.secondary,
                radius: 7,
              ),
            ),
            ScatterSpot(
              3,
              values[2],
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
                          ? widget.time[0].type
                          : value == 2
                          ? widget.time[1].type
                          : value == 3
                          ? widget.time[2].type
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
                "Milliseconds",
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
                      value == 2 ? widget.title : "",
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
