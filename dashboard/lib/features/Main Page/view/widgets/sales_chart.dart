import 'package:dashboard/core/utils/theme.dart';
import 'package:dashboard/features/Main%20Page/model/sales_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SalesChart extends StatefulWidget {
  const SalesChart({super.key, required this.sales});
  final List<SalesModel> sales;

  @override
  State<SalesChart> createState() => _SalesChartState();
}

class _SalesChartState extends State<SalesChart> {
  List<FlSpot> spots = [];
  @override
  void initState() {
    super.initState();
    spots = List.generate(widget.sales.length, (index) {
      return FlSpot(index + 1, widget.sales[index].sales);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.45,
      child: LineChart(
        LineChartData(
          maxX: widget.sales.length.toDouble(),
          minX: 0,
          minY: 0,
          // maxY: 3000000,
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
              color: Themes.secondary,
              isCurved: true,
              curveSmoothness: 0.10,
              preventCurveOverShooting: true,
              shadow: Shadow(color: Themes.secondary),
              belowBarData: BarAreaData(
                show: true,
                color: Themes.text.withAlpha(40),
              ),
              spots: spots,
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
                          ? widget.sales[0].month
                          : value == 2
                          ? widget.sales[1].month
                          : value == 3
                          ? widget.sales[2].month
                          : value == 4
                          ? widget.sales[3].month
                          : value == 5
                          ? widget.sales[4].month
                          : value == 6
                          ? widget.sales[5].month
                          : value == 7
                          ? widget.sales[6].month
                          : value == 8
                          ? widget.sales[7].month
                          : value == 9
                          ? widget.sales[8].month
                          : value == 10
                          ? widget.sales[9].month
                          : value == 11
                          ? widget.sales[10].month
                          : value == 12
                          ? widget.sales[11].month
                          : '',
                      style: TextStyle(color: Themes.text, fontSize: 14),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: Text(
                "Profits",
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
                          ? '0'
                          : value == 1000000
                          ? '1M'
                          : value == 2000000
                          ? '2M'
                          : value == 3000000
                          ? '3M'
                          : value == 4000000
                          ? '4M'
                          : value == 5000000
                          ? '5M'
                          : value == 6000000
                          ? '6M'
                          : value == 7000000
                          ? '7M'
                          : value == 8000000
                          ? '8M'
                          : value == 9000000
                          ? '9M'
                          : value == 10000000
                          ? '10M'
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
                reservedSize: 38,
                getTitlesWidget: (value, _) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      value == 6 ? 'Sales' : "",
                      style: TextStyle(
                        color: Themes.text,
                        fontSize: 25,
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
