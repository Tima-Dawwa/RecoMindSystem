import 'package:dashboard/features/AI/model/statistics_model.dart';
import 'package:dashboard/features/AI/model/time_model.dart';
import 'package:dashboard/features/AI/view%20model/cubit/ai_statistics_cubit.dart';
import 'package:dashboard/features/AI/views/widgets/time_chart.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/core/utils/theme.dart';
import 'package:dashboard/features/AI/views/widgets/chatbot_charts.dart';
import 'package:dashboard/features/AI/views/widgets/recommindations_charts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AiPageBody extends StatefulWidget {
  const AiPageBody({super.key});

  @override
  State<AiPageBody> createState() => _AiPageBodyState();
}

class _AiPageBodyState extends State<AiPageBody> {
  List<StatisticsModel> recommendationS = [];
  List<TimeModel> recommendationT = [];
  List<StatisticsModel> chatbotS = [];
  List<TimeModel> chatbotT = [];

  @override
  void initState() {
    super.initState();
    chatbotS = BlocProvider.of<AiStatisticsCubit>(context).chatbotS;
    chatbotT = BlocProvider.of<AiStatisticsCubit>(context).chatbotT;
    recommendationS =
        BlocProvider.of<AiStatisticsCubit>(context).recommendationS;
    recommendationT =
        BlocProvider.of<AiStatisticsCubit>(context).recommendationT;
  }

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
              "The charts show the percentage of average similarity of the chatbot's results for each day in the last week",
              style: TextStyle(fontSize: 22, color: Themes.text),
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ChatbotCharts(
                  title: "${chatbotS[0].type} input",
                  chatbotStatistics: chatbotS[0],
                ),
                ChatbotCharts(
                  title: "${chatbotS[1].type} input",
                  chatbotStatistics: chatbotS[1],
                ),
                ChatbotCharts(
                  title: "${chatbotS[2].type} input",
                  chatbotStatistics: chatbotS[2],
                ),
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
              "The charts show the percentage of average similarity of the recommendation system results for each day in the last week",
              style: TextStyle(fontSize: 22, color: Themes.text),
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RecommindationsCharts(
                  title: recommendationS[0].type,
                  lineColor: Themes.primary,
                  recommindationStatistics: recommendationS[0],
                ),
                RecommindationsCharts(
                  title: recommendationS[1].type,
                  lineColor: Themes.secondary,
                  recommindationStatistics: recommendationS[1],
                ),
                RecommindationsCharts(
                  title: recommendationS[2].type,
                  lineColor: Themes.third,
                  recommindationStatistics: recommendationS[2],
                ),
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
                  time: recommendationT,
                ),
                TimeChart(
                  title: 'Chatbot',
                  xAxis: ['Image', 'Text', 'Both'],
                  time: chatbotT,
                ),
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
