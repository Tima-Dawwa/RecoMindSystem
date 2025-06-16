import 'package:flutter/material.dart';
import 'package:recomindweb/core/responsive_layout.dart';
import 'package:recomindweb/features/Home/view/widgets/home_page_body.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.logged});
  final bool logged;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: HomePageBody(desktop: false, logged: logged),
        desktopBody: HomePageBody(desktop: true, logged: logged),
      ),
    );
  }
}
