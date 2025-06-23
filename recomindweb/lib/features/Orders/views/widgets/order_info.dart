import 'package:flutter/widgets.dart';
import 'package:recomindweb/core/theme.dart';

class OrderInfo extends StatelessWidget {
  const OrderInfo({
    super.key,
    required this.state,
    required this.orderNum,
    required this.price,
    required this.desktop,
  });

  final String state;
  final String orderNum;
  final String price;
  final bool desktop;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                // color:
                //     state == 'Delivered'
                //         ? Themes.text.withAlpha(50)
                //         : Themes.primary.withAlpha(50),
                borderRadius: BorderRadius.circular(38),
              ),
              child: Text(
                state,
                style: TextStyle(
                  fontSize: desktop ? 30 : 20,
                  color: state == 'Delivered' ? Themes.text : Themes.primary,
                  fontStyle: FontStyle.italic,
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
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Order sent in : 5 JUN 2025  8:28 pm',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: desktop ? 25 : 18,
                color: Themes.text.withAlpha(150),
              ),
            ),
            // Text(
            //   "10 Items",
            //   style: TextStyle(fontSize: desktop ? 25 : 18, color: Themes.text),
            // ),
          ],
        ),
        SizedBox(height: 20),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Products cost : \$606",
              style: TextStyle(fontSize: desktop ? 22 : 18, color: Themes.text),
            ),
            SizedBox(height: 10),
            Text(
              "Shipping cost : \$22",
              style: TextStyle(fontSize: desktop ? 22 : 18, color: Themes.text),
            ),
            SizedBox(height: 10),
            Text(
              "Total bill : \$628",
              style: TextStyle(
                fontSize: desktop ? 22 : 18,
                color: Themes.secondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
