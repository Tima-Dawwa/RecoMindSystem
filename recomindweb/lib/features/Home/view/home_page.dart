import 'package:flutter/material.dart';
import 'package:recomindweb/core/Widgets/custom_appbar.dart';
import 'package:recomindweb/core/responsive_layout.dart';
import 'package:recomindweb/features/Home/view/widgets/home_page_body.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(),
      body: ResponsiveLayout(
        mobileBody: HomePageBody(desktop: false),
        desktopBody: HomePageBody(desktop: true),
      ),
    );
  }
}
