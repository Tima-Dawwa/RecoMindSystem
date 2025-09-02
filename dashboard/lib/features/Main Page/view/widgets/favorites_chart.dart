import 'package:dashboard/core/utils/theme.dart' show Themes;
import 'package:dashboard/features/Main%20Page/model/favorites_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class FavoritesChart extends StatefulWidget {
  const FavoritesChart({super.key, required this.favorites});
  final List<FavoritesModel> favorites;

  @override
  State<FavoritesChart> createState() => _FavoritesChartState();
}

class _FavoritesChartState extends State<FavoritesChart> {
  List<BarChartGroupData> bars = [];

  @override
  void initState() {
    super.initState();
    bars = List.generate(widget.favorites.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: widget.favorites[index].favorites.toDouble(),
            width: 12,
            color: Themes.primary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.47,
      height: MediaQuery.of(context).size.height * 0.5,
      child: BarChart(
        BarChartData(
          minY: 0,
          maxY: 5,
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
          barGroups: bars,
          titlesData: FlTitlesData(
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, _) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      widget.favorites[value.toInt()].name.split(' ').length >=
                              2
                          ? '${widget.favorites[value.toInt()].name.split(' ').first.toLowerCase()}\n${widget.favorites[value.toInt()].name.split(' ').elementAt(1).toLowerCase()}'
                          : widget.favorites[value.toInt()].name
                              .split(' ')
                              .first,
                      style: TextStyle(color: Themes.text, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: Text(
                "Counts",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      value.toString(),
                      style: TextStyle(color: Themes.text, fontSize: 12),
                    ),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                getTitlesWidget: (value, _) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      value == 5 ? 'Favorite Products' : "",
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
