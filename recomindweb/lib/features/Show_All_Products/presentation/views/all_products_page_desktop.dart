import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Show_All_Products/presentation/views/widgets/tabs.dart';

class AllProductsPageDesktopLayout extends StatelessWidget {
  const AllProductsPageDesktopLayout({super.key, required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(scale: 5, "assets/photo11.jpg", fit: BoxFit.fill),
        Text("3aaaaaaaaaaaaaaaaaaaaaa"),
        Column(
          children: [
            Tabs(tabController: tabController),
            SizedBox(height: 15),
            TabbarView(tabController: tabController),
          ],
        ),
      ],
    );
  }
}

class Views extends StatelessWidget {
  const Views({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(color: Themes.primary, child: Text("SSSS")),
       GridView.builder(gridDelegate: gridDelegate, itemBuilder: itemBuilder)
      ],
    );
  }
}

class TabbarView extends StatelessWidget {
  const TabbarView({super.key, required this.tabController});

  final TabController tabController;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: TabBarView(
        controller: tabController,
        children: [Views(), Views(), Views(), Views()],
      ),
    );
  }
}
