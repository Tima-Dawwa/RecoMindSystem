import 'package:flutter/material.dart';
import 'package:recomindweb/core/responsive_layout.dart';
import 'package:recomindweb/features/Authentication/view/widgets/register/register_page_body.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: RegisterPageBody(
          h: 0.6,
          desktop: false,
          image: 'mobile',
          imageAlign: AlignmentDirectional.topCenter,
          boxAlign: AlignmentDirectional.bottomCenter,
        ),

        desktopBody: RegisterPageBody(
          h: 0.9,
          desktop: true,
          image: 'desktop',
          imageAlign: AlignmentDirectional.centerStart,
          boxAlign: AlignmentDirectional.centerStart,
        ),
      ),
    );
  }
}
