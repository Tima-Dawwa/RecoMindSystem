import 'package:flutter/material.dart';
import 'package:recomindweb/core/responsive_layout.dart';
import 'package:recomindweb/core/helpers/custom_shared_preferences.dart';
import 'package:recomindweb/features/Home/view/widgets/home_page_body.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CustomSharedPreferences prefs = CustomSharedPreferences();
  bool logged = false;

  @override
  void initState() {
    super.initState();
    isLogged();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: HomePageBody(desktop: false, logged: logged),
        desktopBody: HomePageBody(desktop: true, logged: logged),
      ),
    );
  }

  Future<void> isLogged() async {
    if (await prefs.logged()) {
      setState(() {
        logged = true;
      });
    } else {
      setState(() {
        logged = false;
      });
    }
  }
}
