import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recomindweb/core/Widgets/custom_button.dart';
import 'package:recomindweb/core/theme.dart';

class Filters extends StatefulWidget {
  const Filters({super.key});

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  List<String> sortBy = ['date_asc', 'date_desc', 'price_asc', 'price_desc'];
  List<Widget> types = [
    Row(
      children: [
        Icon(FontAwesomeIcons.arrowDownShortWide, color: Themes.primary),
        SizedBox(width: 10),
        Text(
          'oldest to newest',
          style: TextStyle(color: Themes.text, fontSize: 20),
        ),
      ],
    ),
    Row(
      children: [
        Icon(FontAwesomeIcons.arrowDownWideShort, color: Themes.primary),
        SizedBox(width: 10),
        Text(
          'newest to oldest',
          style: TextStyle(color: Themes.text, fontSize: 20),
        ),
      ],
    ),
    Row(
      children: [
        Icon(FontAwesomeIcons.arrowDown91, color: Themes.primary),
        SizedBox(width: 10),
        Text(
          'price highest to lowest',
          style: TextStyle(color: Themes.text, fontSize: 20),
        ),
      ],
    ),
    Row(
      children: [
        Icon(FontAwesomeIcons.arrowDown19, color: Themes.primary),
        SizedBox(width: 10),
        Text(
          'price lowest to highest',
          style: TextStyle(color: Themes.text, fontSize: 20),
        ),
      ],
    ),
  ];

  String? currentSortBy;
  @override
  void initState() {
    super.initState();
    // currentSortBy = '';
    //= BlocProvider.of<OrdersCubit>(context).sortBy;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: sortTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Text(
              "Sort by  ",
              style: TextStyle(color: Themes.primary, fontSize: 25),
            ),
            Icon(FontAwesomeIcons.retweet, color: Themes.primary),
          ],
        ),
      ),
    );
  }

  void sortTap() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Choose a sort type :',
            style: TextStyle(color: Themes.text, fontSize: 25),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...List.generate(sortBy.length, (index) {
                return RadioListTile(
                  title: types[index],
                  activeColor: Themes.primary,
                  selected: currentSortBy == sortBy[index],
                  value: sortBy[index],
                  groupValue: currentSortBy,
                  onChanged: (value) {
                    setState(() {
                      currentSortBy = value.toString();
                      // BlocProvider.of<OrdersCubit>(context).sortBy =
                      //     currentSortBy;
                    });
                  },
                );
              }),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: "Reset",
                    color: WidgetStatePropertyAll(Themes.secondary),
                    height: 30,
                    size: 20,
                    press: () {},
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: CustomButton(
                    text: "Apply",
                    height: 30,
                    size: 20,
                    press: () {},
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
