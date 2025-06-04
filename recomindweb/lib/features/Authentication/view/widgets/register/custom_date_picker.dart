import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Authentication/view%20model/auth%20cubit/auth_cubit.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({super.key});

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  TextEditingController date = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickeddate = await Themes.customDatePicker(context: context);
        if (pickeddate != null) {
          setState(() {
            DateFormat outputFormat = DateFormat('yyyy-MM-dd');
            date.text = outputFormat.format(pickeddate);
            BlocProvider.of<AuthCubit>(context).birthDate = date.text;
          });
        }
      },
      child: Container(
        height: 40,
        width: double.infinity,
        padding: EdgeInsets.only(left: 10, top: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Themes.bg.withAlpha(80),
        ),
        child: Text(
          BlocProvider.of<AuthCubit>(context).birthDate ?? 'Birth date',
          style:
              BlocProvider.of<AuthCubit>(context).birthDate == null
                  ? TextStyle(color: Themes.text.withAlpha(120), fontSize: 16)
                  : TextStyle(color: Themes.text, fontSize: 16),
        ),
      ),
    );
  }
}
