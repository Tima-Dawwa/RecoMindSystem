import 'package:dashboard/core/utils/theme.dart';
import 'package:dashboard/features/Main%20Page/model/chatbot_model.dart';
import 'package:dashboard/features/Main%20Page/model/countries_model.dart';
import 'package:dashboard/features/Main%20Page/model/favorites_model.dart';
import 'package:dashboard/features/Main%20Page/model/interactions_model.dart';
import 'package:dashboard/features/Main%20Page/model/notification_model.dart';
import 'package:dashboard/features/Main%20Page/model/orders_model.dart';
import 'package:dashboard/features/Main%20Page/model/sales_model.dart';
import 'package:dashboard/features/Main%20Page/view%20model/cubit/main_cubit.dart';
import 'package:dashboard/features/Main%20Page/view/widgets/chatbot_chart.dart';
import 'package:dashboard/features/Main%20Page/view/widgets/countries_charts.dart';
import 'package:dashboard/features/Main%20Page/view/widgets/favorites_chart.dart';
import 'package:dashboard/features/Main%20Page/view/widgets/interactions_table.dart';
import 'package:dashboard/features/Main%20Page/view/widgets/notifications_box.dart';
import 'package:dashboard/features/Main%20Page/view/widgets/orders_table.dart';
import 'package:dashboard/features/Main%20Page/view/widgets/sales_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPageBody extends StatefulWidget {
  const MainPageBody({super.key});

  @override
  State<MainPageBody> createState() => _MainPageBodyState();
}

class _MainPageBodyState extends State<MainPageBody>
    with SingleTickerProviderStateMixin {
  OverlayEntry? overlayEntry;
  final LayerLink layerLink = LayerLink();
  late AnimationController animationController;
  late Animation<Offset> slideAnimation;

  ScrollController scrollController = ScrollController();
  List<SalesModel> sales = [];
  List<OrdersModel> orders = [];
  List<InteractionsModel> interactions = [];
  List<FavoritesModel> favorites = [];
  List<CountriesModel> countries = [];
  List<NotificationModel> notifications = [];
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

    animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    slideAnimation = Tween<Offset>(
      begin: Offset(0, -0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void toggleOverlay(BuildContext context) {
    if (overlayEntry == null) {
      overlayEntry = createOverlayEntry(context);
      Overlay.of(context).insert(overlayEntry!);
      animationController.forward();
    } else {
      closeOverlay();
    }
  }

  void closeOverlay() async {
    await animationController.reverse();
    overlayEntry?.remove();
    overlayEntry = null;
  }

  OverlayEntry createOverlayEntry(BuildContext context) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    return OverlayEntry(
      builder:
          (context) => GestureDetector(
            onTap: closeOverlay,
            behavior: HitTestBehavior.translucent,
            child: Stack(
              children: [
                Positioned.fill(child: Container()),
                Positioned(
                  top: offset.dy + 70,
                  right: 20,
                  width: 500,
                  height: 450,
                  child: Material(
                    color: Colors.transparent,
                    child: SlideTransition(
                      position: slideAnimation,
                      child: Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(10),
                        child: NotificationsBox()
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Padding(
        padding: EdgeInsets.only(right: 30, left: 10, top: 15, bottom: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dashboard Statistics',
                  style: TextStyle(
                    color: Themes.text,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CompositedTransformTarget(
                  link: layerLink,
                  child: IconButton(
                    onPressed: () => toggleOverlay(context),
                    icon: Icon(
                      Icons.notifications,
                      size: 40,
                      color: Themes.primary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 20),
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

  Future<void> getNotifications() async {
    await BlocProvider.of<MainCubit>(context).getNotifications();
  }
}
