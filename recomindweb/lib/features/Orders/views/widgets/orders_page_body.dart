import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Orders/views/widgets/filters.dart';
import 'package:recomindweb/features/Orders/views/widgets/order_card.dart';

class OrdersPageBody extends StatelessWidget {
  const OrdersPageBody({
    super.key,
    required this.ordersNum,
    required this.desktop,
  });
  final int ordersNum;
  final bool desktop;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Filters(),
          Divider(thickness: 1, color: Themes.text.withAlpha(50)),
          if (desktop)
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  mainAxisExtent: 265,
                ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return OrderCard(
                    state: 'Accepted',
                    orderNum: '3653',
                    price: '628',
                    items: '10',
                  );
                },
              ),
            ),
          if (!desktop)
            Expanded(
              child: ListView.builder(
                itemCount: ordersNum,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: OrderCard(
                      state: 'delivered',
                      orderNum: '3653',
                      price: '628',
                      items: '10',
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
    // Column(
    //   children: [
    // TabBar(
    //   tabAlignment: TabAlignment.fill,
    //   labelStyle: TextStyle(
    //     fontSize: 22,
    //     color: Themes.primary,
    //     fontWeight: FontWeight.w600,
    //   ),
    //   unselectedLabelStyle: TextStyle(
    //     fontSize: 18,
    //     color: Themes.text.withAlpha(180),
    //     fontWeight: FontWeight.w300,
    //   ),
    //   dividerHeight: 1.5,
    //   dividerColor: Themes.text.withAlpha(80),
    //   indicatorWeight: 3,
    //   indicatorColor: Themes.primary,
    //   indicatorSize: TabBarIndicatorSize.tab,
    //   indicatorAnimation: TabIndicatorAnimation.elastic,
    //   tabs: [
    //     Tab(
    //       child: Text(
    //         'Current',
    //         textAlign: TextAlign.center,
    //         style: TextStyle(fontFamily: 'CoconNext'),
    //       ),
    //     ),
    //     Tab(
    //       child: Text(
    //         'Previous',
    //         textAlign: TextAlign.center,
    //         style: TextStyle(fontFamily: 'CoconNext'),
    //       ),
    //     ),
    //   ],
    // ),
