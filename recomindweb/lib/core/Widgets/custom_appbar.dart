import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:recomindweb/core/Widgets/custom_button.dart';
import 'package:recomindweb/features/Authentication/view/login_page.dart';
import 'package:recomindweb/core/theme.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.centerEnd,
      children: [
        AppBar(
          backgroundColor: Themes.primary,
          elevation: 2,
          title: Text(
            "TRENDOVA",
            style: TextStyle(color: Themes.bg, fontSize: 30),
          ),
          // Image.asset("assets/Images/logo.png", height: 35, width: 150),
          actions: [
            CustomButton(
              text: "Login",
              width: 100,
              height: 32,
              borderRadius: 40,
              borderColor: Themes.bg,
              press: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.scale,
                    alignment: Alignment.center,
                    duration: Duration(milliseconds: 800),
                    curve: Curves.fastLinearToSlowEaseIn,
                    child: LoginPage(),
                    childCurrent: CustomAppbar(),
                  ),
                );
              },
            ),
            SizedBox(width: 30),
            Icon(Icons.shopping_cart_outlined, color: Themes.bg, size: 25),
            SizedBox(width: 10),
            Icon(Icons.local_shipping_outlined, color: Themes.bg, size: 25),
            SizedBox(width: 10),
            Icon(Icons.favorite_outline_rounded, color: Themes.bg, size: 25),
            SizedBox(width: 10),
            // Icon(FontAwesomeIcons.circleUser, color: Themes.bg, size: 30),
            // SizedBox(width: 10),
          ],
        ),
        // SizedBox(
        //   width: 60,
        //   child: ExpansionTile(
        //     showTrailingIcon: false,
        //     tilePadding: const EdgeInsets.symmetric(horizontal: 10),
        //     childrenPadding: const EdgeInsets.all(10),
        //     title: Icon(Icons.settings, size: 30, color: Themes.bg),
        //     backgroundColor: Themes.bg,
        //     collapsedBackgroundColor: Themes.primary,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(20),
        //     ),
        //     collapsedShape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(20),
        //     ),
        //     expansionAnimationStyle: AnimationStyle(
        //       curve: Curves.fastOutSlowIn,
        //       duration: const Duration(seconds: 1),
        //     ),
        //     children: [Icon(Icons.settings, color: Themes.primary, size: 30)],
        //   ),
        // ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}
