import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
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
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Themes.primary, Themes.bg],
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "TRENDOVA",
                style: TextStyle(color: Themes.bg, fontSize: desktop ? 30 : 20),
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
                        context.go('/login');
                      },
                    ),
                  SizedBox(width: 20),
                  Icon(
                    Icons.shopping_cart_outlined,
                    color: Themes.bg,
                    size: desktop ? 30 : 22,
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.local_shipping_outlined,
                    color: Themes.bg,
                    size: desktop ? 30 : 22,
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
        // SizedBox(
        //   width: 50,
        //   child: ExpansionTile(
        //     showTrailingIcon: false,
        //     tilePadding: const EdgeInsets.symmetric(horizontal: 5),
        //     childrenPadding: const EdgeInsets.all(10),
        //     title: Icon(Icons.person, size: 30, color: Themes.bg),
        //     backgroundColor: Themes.bg,
        //     collapsedBackgroundColor: Colors.transparent,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(20),
        //     ),
        //     collapsedShape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(20),
        //     ),
        //     expansionAnimationStyle: AnimationStyle(
        //       curve: Curves.fastOutSlowIn,
        //       duration: const Duration(milliseconds: 500),
        //     ),
        //     children: [
        //       Icon(Icons.settings, color: Themes.primary, size: 30),
        //       Icon(Icons.settings, color: Themes.primary, size: 30),
        //       Icon(Icons.settings, color: Themes.primary, size: 30),
        //       Icon(Icons.settings, color: Themes.primary, size: 30),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
