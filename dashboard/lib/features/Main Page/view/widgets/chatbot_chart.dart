import 'package:dashboard/core/utils/theme.dart';
import 'package:dashboard/features/Main%20Page/model/chatbot_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChatbotChart extends StatefulWidget {
  const ChatbotChart({super.key, required this.chatbot});
  final ChatbotModel chatbot;
  @override
  State<ChatbotChart> createState() => _ChatbotChartState();
}

class _ChatbotChartState extends State<ChatbotChart> {
  double image = 0;
  double text = 0;
  double both = 0;
  @override
  void initState() {
    super.initState();
    int sum = widget.chatbot.both + widget.chatbot.image + widget.chatbot.text;
    image = (widget.chatbot.image * 100) / sum;
    text = (widget.chatbot.text * 100) / sum;
    both = (widget.chatbot.both * 100) / sum;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'Chatbot Inputs Usage',
          style: TextStyle(
            color: Themes.text,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.height * 0.5,
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 0,
              sectionsSpace: 5,
              sections: [
                PieChartSectionData(
                  title: 'Image\n%${image.toStringAsFixed(2)}',
                  titleStyle: TextStyle(
                    color: Themes.bg,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  value: image,
                  color: Themes.primary,
                  radius: 150,
                ),
                PieChartSectionData(
                  title: 'Text\n%${text.toStringAsFixed(2)}',
                  titleStyle: TextStyle(
                    color: Themes.bg,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  value: text,
                  color: Themes.secondary,
                  radius: 150,
                ),
                PieChartSectionData(
                  title: 'Text&Image\n%${both.toStringAsFixed(2)}',
                  titleStyle: TextStyle(
                    color: Themes.bg,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  value: both,
                  color: Themes.third,
                  radius: 150,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
