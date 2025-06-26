import 'package:dashboard/features/AI/views/widgets/time_chart.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/core/utils/theme.dart';
import 'package:dashboard/features/AI/views/widgets/chatbot_charts.dart';
import 'package:dashboard/features/AI/views/widgets/recommindations_charts.dart';

class AiPageBody extends StatelessWidget {
  const AiPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              "AI Tools Performance",
              style: TextStyle(
                fontSize: 38,
                color: Themes.text,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Chatbot :",
              style: TextStyle(
                fontSize: 28,
                color: Themes.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "The charts show the percentage of average performance accuracy of the chatbot's results for each day in the last week",
              style: TextStyle(fontSize: 22, color: Themes.text),
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ChatbotCharts(title: "Text input"),
                ChatbotCharts(title: "Image input"),
                ChatbotCharts(title: "Text & Image input"),
              ],
            ),
            SizedBox(height: 50),
            Text(
              "Recommindations :",
              style: TextStyle(
                fontSize: 28,
                color: Themes.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "The charts show the percentage of average performance accuracy of the recommendation system results for each day in the last week",
              style: TextStyle(fontSize: 22, color: Themes.text),
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RecommindationsCharts(
                  title: 'Content',
                  lineColor: Themes.primary,
                ),
                RecommindationsCharts(
                  title: 'Collaborative',
                  lineColor: Themes.secondary,
                ),
                RecommindationsCharts(title: 'Hybrid', lineColor: Themes.third),
              ],
            ),
            SizedBox(height: 50),
            Text(
              "Time Calculations :",
              style: TextStyle(
                fontSize: 28,
                color: Themes.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "The charts show the average response time for each AI tool system and are updated daily",
              style: TextStyle(fontSize: 22, color: Themes.text),
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TimeChart(
                  title: 'Recommendations',
                  xAxis: ['Content', 'Collaborative', 'Hybrid'],
                ),
                TimeChart(title: 'Chatbot', xAxis: ['Image', 'Text', 'Both']),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

//السطر الاول 3 مخططات
//content , collab , hy

//السطر الثاني 3 مخططات
//نسبة دقة التشات بوت الوسطى في كل يوم في الاسبوع الاخير
//مخطط لكل نوع من انواع الاسئلة للتشات

//السطر الثالث
//مخططين جنب بعض كل مخطط عبارة عن مقارنة زمنية لوحدة
