import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Authentication/view%20model/auth%20cubit/auth_cubit.dart';

// ignore: must_be_immutable
class GenderPicker extends StatefulWidget {
  const GenderPicker({super.key});

  @override
  State<GenderPicker> createState() => _GenderPickerState();
}

class _GenderPickerState extends State<GenderPicker> {
  final genders = ['Male', 'Female'];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Themes.bg.withAlpha(80),
      ),
      child: DropdownButton<String>(
        value: BlocProvider.of<AuthCubit>(context).gender,
        onChanged: (value) {
          setState(() {
            BlocProvider.of<AuthCubit>(context).gender = value;
          });
        },
        items: genders.map(buildItems).toList(),
        icon: SizedBox(),
        underline: SizedBox(),
        dropdownColor: Themes.bg,
        borderRadius: BorderRadius.circular(10),
        style: TextStyle(color: Themes.text, fontSize: 16),
        menuMaxHeight: 150,
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

  DropdownMenuItem<String> buildItems(String item) {
    return DropdownMenuItem(
      value: item,
      child: Row(
        children: [
          SizedBox(width: 8),
          Icon(Icons.female, color: Themes.text, size: 25),
          SizedBox(width: 5),
          Text(
            item,
            style: TextStyle(
              color: Themes.text,
              fontSize: 16,
              fontFamily: 'CoconNext',
            ),
          ),
        ],
      ),
    );
  }
}
