import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/core/Widgets/custom_button.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key, required this.desktop, required this.logged});
  final bool desktop;
  final bool logged;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.centerEnd,
      children: [
        Container(
          height: desktop ? 100 : 50,
          width: double.infinity,
          padding: EdgeInsets.all(desktop ? 15 : 10),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Images/bar.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Image.asset(
                  'assets/Images/logo.png',
                  height: 150,
                  width: 150,
                  alignment: Alignment.topCenter,
                ),
              ),
              Row(
                children: [
                  if (!logged)
                    CustomButton(
                      text: "Login",
                      width: desktop ? 100 : 80,
                      height: desktop ? 32 : 25,
                      size: desktop ? 20 : 15,
                      borderRadius: 40,
                      press: () {
                        Get.toNamed('/login', preventDuplicates: false);
                      },
                    ),
                  SizedBox(width: 20),
                  Icon(
                    Icons.shopping_cart_outlined,
                    color: Themes.bg,
                    size: desktop ? 30 : 22,
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(
                      Icons.local_shipping_outlined,
                      size: desktop ? 30 : 22,
                    ),
                    color: Themes.bg,
                    onPressed: () {
                      Get.toNamed('/orders', preventDuplicates: false);
                    },
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.favorite_outline_rounded,
                    color: Themes.bg,
                    size: desktop ? 30 : 22,
                  ),
                  if (logged) SizedBox(width: 10),
                  if (logged)
                    Icon(
                      FontAwesomeIcons.circleUser,
                      color: Themes.bg,
                      size: desktop ? 30 : 22,
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}