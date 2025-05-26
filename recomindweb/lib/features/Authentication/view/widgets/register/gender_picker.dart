import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';

class GenderPicker extends StatelessWidget {
  const GenderPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Themes.bg.withAlpha(80),
      ),
      child: DropdownButton(
        onChanged: (value) {},
        icon: SizedBox(),
        underline: SizedBox(),
        dropdownColor: Themes.bg,
        borderRadius: BorderRadius.circular(10),
        style: TextStyle(color: Themes.text, fontSize: 16),
        menuMaxHeight: 150,
        items: [
          DropdownMenuItem(
            value: "1",
            child: Row(
              children: [
                Icon(Icons.male, color: Themes.text, size: 25),
                SizedBox(width: 10),
                Text(
                  "Male",
                  style: TextStyle(
                    color: Themes.text,
                    fontSize: 16,
                    fontFamily: 'CoconNext',
                  ),
                ),
              ],
            ),
          ),
          DropdownMenuItem(
            value: "2",
            child: Row(
              children: [
                Icon(Icons.female, color: Themes.text, size: 25),
                SizedBox(width: 10),
                Text(
                  "Female",
                  style: TextStyle(
                    color: Themes.text,
                    fontSize: 16,
                    fontFamily: 'CoconNext',
                  ),
                ),
              ],
            ),
          ),
        ],
        hint: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            "Gender",
            style: TextStyle(
              color: Themes.text.withAlpha(120),
              fontSize: 16,
              fontFamily: 'CoconNext',
            ),
          ),
        ),
      ),
    );
  }
}
