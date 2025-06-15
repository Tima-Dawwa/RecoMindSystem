import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';

class PreviousOrders extends StatelessWidget {
  const PreviousOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(15),
          //   border: Border.all(color: Themes.secondary),
          //   color: Colors.transparent,
          // ),
          width: double.infinity,
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.all(20),
          child: Card(
            elevation: 2,
            color: Themes.bg,
            surfaceTintColor: Themes.text,
            shadowColor: Themes.text,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order #4683',
                        style: TextStyle(fontSize: 30, color: Themes.text),
                      ),
                      Text(
                        'delieverd',
                        style: TextStyle(fontSize: 25, color: Themes.text),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    '18 JUN 2025  8:28 pm',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 25,
                      color: Themes.text.withAlpha(120),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$683',
                        style: TextStyle(fontSize: 28, color: Themes.primary),
                      ),
                      Text(
                        '33 Items',
                        style: TextStyle(fontSize: 25, color: Themes.text),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
