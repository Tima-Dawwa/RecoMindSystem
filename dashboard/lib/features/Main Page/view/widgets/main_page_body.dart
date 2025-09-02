import 'package:dashboard/core/utils/theme.dart';
import 'package:dashboard/features/Main%20Page/model/chatbot_model.dart';
import 'package:dashboard/features/Main%20Page/model/countries_model.dart';
import 'package:dashboard/features/Main%20Page/model/favorites_model.dart';
import 'package:dashboard/features/Main%20Page/model/interactions_model.dart';
import 'package:dashboard/features/Main%20Page/model/orders_model.dart';
import 'package:dashboard/features/Main%20Page/model/sales_model.dart';
import 'package:dashboard/features/Main%20Page/view%20model/cubit/main_cubit.dart';
import 'package:dashboard/features/Main%20Page/view/widgets/chatbot_chart.dart';
import 'package:dashboard/features/Main%20Page/view/widgets/countries_charts.dart';
import 'package:dashboard/features/Main%20Page/view/widgets/favorites_chart.dart';
import 'package:dashboard/features/Main%20Page/view/widgets/interactions_table.dart';
import 'package:dashboard/features/Main%20Page/view/widgets/orders_table.dart';
import 'package:dashboard/features/Main%20Page/view/widgets/sales_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPageBody extends StatefulWidget {
  const MainPageBody({super.key});

  @override
  State<MainPageBody> createState() => _MainPageBodyState();
}

class _MainPageBodyState extends State<MainPageBody> {
  ScrollController scrollController = ScrollController();
  List<SalesModel> sales = [];
  List<OrdersModel> orders = [];
  List<InteractionsModel> interactions = [];
  List<FavoritesModel> favorites = [];
  List<CountriesModel> countries = [];
  ChatbotModel? chatbot;

  @override
  void initState() {
    super.initState();
    sales = BlocProvider.of<MainCubit>(context).sales;
    orders = BlocProvider.of<MainCubit>(context).orders;
    interactions = BlocProvider.of<MainCubit>(context).interactions;
    favorites = BlocProvider.of<MainCubit>(context).favorites;
    countries = BlocProvider.of<MainCubit>(context).countries;
    chatbot = BlocProvider.of<MainCubit>(context).chatbot;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Padding(
        padding: EdgeInsets.only(right: 30, left: 10, top: 15, bottom: 15),
        child: Column(
          children: [
            Center(
              child: Text(
                'Dashboard Statistics',
                style: TextStyle(
                  color: Themes.text,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 30),
            SalesChart(sales: sales),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FavoritesChart(favorites: favorites),
                ChatbotChart(chatbot: chatbot!),
              ],
            ),
            SizedBox(height: 40),
            CountriesCharts(countries: countries),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InteractionsTable(interactions: interactions),
                OrdersTable(orders: orders),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
