import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recomindweb/core/theme.dart';

class OrderInfo extends StatelessWidget {
  const OrderInfo({
    super.key,
    required this.state,
    required this.orderNum,
    required this.price,
    required this.desktop,
    required this.date,
  });

  final bool desktop;
  final String state;
  final String price;
  final String date;
  final String orderNum;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #$orderNum',
                  style: TextStyle(
                    fontSize: desktop ? 35 : 28,
                    color: Themes.text,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  state.toUpperCase(),
                  style: TextStyle(
                    fontSize: desktop ? 35 : 20,
                    color: state == 'Delivered' ? Themes.text : Themes.primary,
                    fontWeight: FontWeight.w500,
                    shadows: [
                      Shadow(
                        color:
                            state == 'Delivered'
                                ? Themes.text.withAlpha(180)
                                : Themes.primary.withAlpha(180),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_month,
                size: 25,
                color: Themes.text.withAlpha(170),
              ),
              SizedBox(width: 10),
              Text(
                'Order sent in   ${date.substring(0, 10)}  |  ${date.substring(11, 16)}',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: desktop ? 28 : 18,
                  color: Themes.text.withAlpha(170),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(FontAwesomeIcons.tags, size: 25, color: Themes.text),
              SizedBox(width: 10),
              Text(
                "All products cost  \$606",
                style: TextStyle(
                  fontSize: desktop ? 25 : 18,
                  color: Themes.text,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.local_shipping, size: 25, color: Themes.text),
              SizedBox(width: 10),
              Text(
                "Shipping cost  \$20",
                style: TextStyle(
                  fontSize: desktop ? 25 : 18,
                  color: Themes.text,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.moneyCheckDollar,
                size: 22,
                color: Themes.secondary,
              ),
              SizedBox(width: 10),
              Text(
                "Total bill  \$$price",
                style: TextStyle(
                  fontSize: desktop ? 25 : 18,
                  color: Themes.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
