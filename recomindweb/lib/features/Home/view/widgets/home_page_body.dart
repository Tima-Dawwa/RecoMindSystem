import 'package:flutter/material.dart';
import 'package:recomindweb/features/Home/view/widgets/custom_appbar.dart';
import 'package:recomindweb/features/Home/view/widgets/categories.dart';
import 'package:recomindweb/features/Home/view/widgets/advertisements_scroller.dart';
import 'package:recomindweb/features/Home/view/widgets/chatbot_bar.dart';
import 'package:recomindweb/features/Home/view/widgets/home_page_footer.dart';
import 'package:recomindweb/features/Home/view/widgets/recommendations.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key, required this.desktop, required this.logged});
  final bool desktop;
  final bool logged;
  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();
    return Stack(
      children: [
        SingleChildScrollView(
          controller: controller,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: desktop ? 60 : 35),
              ChatbotBar(desktop: desktop),
              AdvertisementsScroller(),
              Categories(desktop: desktop),
              Recommendations(),
              HomePageFooter(desktop: desktop),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: CustomAppbar(desktop: desktop, logged: logged),
        ),
      ],
    );
  }
}
