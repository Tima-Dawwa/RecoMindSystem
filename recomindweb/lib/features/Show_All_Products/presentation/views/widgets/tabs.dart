// import 'package:flutter/material.dart';
// import 'package:recomindweb/core/theme.dart';

// const tabsStyle = TextStyle(color: Colors.white, fontSize: 15);

// class Tabs extends StatelessWidget {
//   const Tabs({super.key, required this.tabController});

//   final TabController tabController;

//   @override
//   Widget build(BuildContext context) {
//     return
//     // Card(
//     //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//     //   // elevation: 5,
//     //   child:
//     Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Themes.bg,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: TabBar(
//         indicatorSize: TabBarIndicatorSize.label,
//         indicator: UnderlineTabIndicator(
//           borderSide: BorderSide(width: 4),
//           insets: EdgeInsets.symmetric(horizontal: 3),
//         ),
//         // BoxDecoration(
//         //   borderRadius: const BorderRadius.all(Radius.circular(12)),
//         //   color: Themes.primary,
//         // ),
//         unselectedLabelColor: const Color.fromARGB(221, 93, 92, 92),
//         labelColor: Themes.primary,
//         controller: tabController,
//         isScrollable: false,
//         labelPadding: EdgeInsets.symmetric(horizontal: 10),
//         tabs: const [
//           Tab(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
//               child: DecoratedBox(
//                 decoration: BoxDecoration(
//                   color: Colors.grey, // Background for unselected tab
//                   borderRadius: BorderRadius.all(Radius.circular(8)),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   child: Text('One Way'),
//                 ),
//               ),
//             ),
//           ),
//           Tab(
//             child: Text(
//               ' Two Way ',
//               //style: tabsStyle,
//             ),
//           ),
//           Tab(
//             child: Text(
//               ' Three Way ',
//               //style: tabsStyle,
//             ),
//           ),
//           Tab(
//             child: Text(
//               ' Four Way ',
//               //style: tabsStyle,
//             ),
//           ),
//         ],
//       ),
//       // ),
//     );
//   }
// }

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recomindweb/core/theme.dart';

class Tabs extends StatelessWidget {
  const Tabs({super.key, required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return ButtonsTabBar(
      controller: tabController,
      unselectedBackgroundColor: Themes.bg,
      unselectedLabelStyle: TextStyle(color: Colors.grey),
      backgroundColor: Themes.primary,
      splashColor: Colors.purpleAccent,
      contentPadding: EdgeInsets.symmetric(horizontal: 50),
      tabs: [
        Tab(icon: Icon(FontAwesomeIcons.male), text: "man"),
        Tab(icon: Icon(FontAwesomeIcons.female), text: "woman"),
        Tab(icon: Icon(FontAwesomeIcons.baby), text: "baby"),
        Tab(icon: Icon(Icons.man), text: "man"),
      ],
    );
  }
}
