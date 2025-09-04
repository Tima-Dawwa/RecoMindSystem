import 'package:dashboard/core/utils/theme.dart';
import 'package:dashboard/features/Main%20Page/model/countries_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CountriesCharts extends StatefulWidget {
  const CountriesCharts({super.key, required this.countries});
  final List<CountriesModel> countries;

  @override
  State<CountriesCharts> createState() => _CountriesChartsState();
}

class _CountriesChartsState extends State<CountriesCharts> {
  List<ScatterSpot> spots = [];
  @override
  void initState() {
    super.initState();
    spots = List.generate(widget.countries.length, (index) {
      return ScatterSpot(
        index + 1,
        widget.countries[index].users.toDouble(),
        dotPainter: FlDotCirclePainter(color: Themes.third, radius: 10),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.45,
      child: ScatterChart(
        ScatterChartData(
          minX: 0,
          maxX: widget.countries.length.toDouble() + 1,
          minY: 0,
          // maxY: 20,
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
          scatterSpots: spots,
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
                          ? widget.countries[0].country
                          : value == 2
                          ? widget.countries[1].country
                          : value == 3
                          ? widget.countries[2].country
                          : value == 4
                          ? widget.countries[3].country
                          : value == 5
                          ? widget.countries[4].country
                          : value == 6
                          ? widget.countries[5].country
                          : value == 7
                          ? widget.countries[6].country
                          : value == 8
                          ? widget.countries[7].country
                          : value == 9
                          ? widget.countries[8].country
                          : value == 10
                          ? widget.countries[9].country
                          : '',
                      style: TextStyle(color: Themes.text, fontSize: 12),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: Text(
                "Users",
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
                reservedSize: 30,
                getTitlesWidget: (value, _) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      value == 5 ? 'Countries' : "",
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
