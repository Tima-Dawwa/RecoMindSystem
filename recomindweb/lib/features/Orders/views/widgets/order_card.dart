import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recomindweb/core/Widgets/custom_text_button.dart';
import 'package:recomindweb/core/theme.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.state,
    required this.orderNum,
    required this.price,
    required this.items,
  });
  final String state;
  final String orderNum;
  final String price;
  final String items;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 2,
        color: Themes.bg,
        surfaceTintColor: state == 'delivered' ? Themes.text : Themes.primary,
        shadowColor: Themes.text,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order #$orderNum',
                    style: TextStyle(fontSize: 28, color: Themes.text),
                  ),
                  Text(
                    state,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color:
                          state == 'delivered' ? Themes.text : Themes.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                '18 JUN 2025  8:28 pm',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 23,
                  color: Themes.text.withAlpha(150),
                ),
              ),
              SizedBox(height: 10),
              Text(
                '$items Items',
                style: TextStyle(fontSize: 23, color: Themes.text),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$$price',
                    style: TextStyle(fontSize: 25, color: Themes.secondary),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(flex: 1),
                  CustomTextButton(
                    text: "view details",
                    weight: FontWeight.normal,
                    size: 18,
                    color: Themes.text.withAlpha(150),
                    press: () {
                      context.go('/order-datails');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
