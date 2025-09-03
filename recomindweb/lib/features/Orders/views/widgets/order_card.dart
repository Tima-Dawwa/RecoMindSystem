import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/core/Widgets/custom_text_button.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Orders/view%20model/cubit/orders_cubit.dart';
import 'package:recomindweb/features/Orders/views/order_details.dart';

class OrderCard extends StatefulWidget {
  const OrderCard({
    super.key,
    required this.state,
    required this.orderNum,
    required this.price,
    required this.items,
    required this.date,
    required this.id,
  });
  final String state;
  final String id;
  final String orderNum;
  final String price;
  final String items;
  final String date;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.symmetric(
            vertical: BorderSide(
              color: widget.state == 'delivery' ? Themes.text : Themes.primary,
              width: 2.5,
            ),
            horizontal: BorderSide(
              color: widget.state == 'delivery' ? Themes.text : Themes.primary,
              width: 1,
            ),
          ),
        ),
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 2,
          color: Themes.bg,
          surfaceTintColor:
              widget.state == 'delivery' ? Themes.text : Themes.primary,
          shadowColor: Themes.text,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order #${widget.id.substring(19, 23)}',
                      style: TextStyle(fontSize: 30, color: Themes.text),
                    ),
                    Text(
                      widget.state.toUpperCase(),
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color:
                            widget.state == 'delivery'
                                ? Themes.text
                                : Themes.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_month,
                      size: 22,
                      color: Themes.text.withAlpha(150),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Sent in ${widget.date.substring(0, 10)}',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 25,
                        color: Themes.text.withAlpha(150),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.boxesStacked,
                      size: 23,
                      color: Themes.text,
                    ),
                    SizedBox(width: 10),
                    Text(
                      '${widget.items} Items',
                      style: TextStyle(fontSize: 25, color: Themes.text),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.moneyCheckDollar,
                      size: 23,
                      color: Themes.secondary,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Total bill \$${widget.price}',
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
                      press: () async {
                        await getOrderDetails();
                        Get.to(OrderDetailsPage());
                        // .toNamed('/order_details', preventDuplicates: false);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getOrderDetails() async {
    await BlocProvider.of<OrdersCubit>(context).getOneOrder(orderId: widget.id);
  }
}
