import 'package:flutter/material.dart';
import 'package:recomindweb/core/responsive_layout.dart';
import 'package:recomindweb/features/Authentication/view/widgets/login/login_page_body.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: LoginPageBody(
        h: 0.6,
        desktop: false,
        image: 'mobile',
        imageAlign: AlignmentDirectional.topCenter,
        boxAlign: AlignmentDirectional.bottomCenter,
      ),

      desktopBody: LoginPageBody(
        h: 0.75,
        desktop: true,
        image: 'desktop',
        imageAlign: AlignmentDirectional.centerStart,
        boxAlign: AlignmentDirectional.centerStart,
      ),
    );
  }
}
