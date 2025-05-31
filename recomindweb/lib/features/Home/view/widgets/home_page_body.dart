import 'package:flutter/material.dart';
import 'package:recomindweb/features/Home/view/widgets/categories.dart';
import 'package:recomindweb/features/Home/view/widgets/advertisements_scroller.dart';
import 'package:recomindweb/features/Home/view/widgets/chatbot_bar.dart';
import 'package:recomindweb/features/Home/view/widgets/home_page_footer.dart';
import 'package:recomindweb/features/Home/view/widgets/recommendations.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key, required this.desktop});
  final bool desktop;
  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();
    return SingleChildScrollView(
      controller: controller,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ChatbotBar(desktop: desktop),
          AdvertisementsScroller(),
          Categories(desktop: desktop),
          Recommendations(),
          HomePageFooter(desktop: desktop),
        ],
      ),
    );
  }
}
