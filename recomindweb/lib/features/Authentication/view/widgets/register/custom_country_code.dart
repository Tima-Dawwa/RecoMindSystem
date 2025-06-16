import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Authentication/view%20model/auth%20cubit/auth_cubit.dart';

// ignore: must_be_immutable
class CustomCountryCode extends StatefulWidget {
  const CustomCountryCode({super.key});

  @override
  State<CustomCountryCode> createState() => _CustomCountryCodeState();
}

class _CustomCountryCodeState extends State<CustomCountryCode> {
  bool init = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Themes.bg.withAlpha(80),
      ),
      child: CountryCodePicker(
        padding: const EdgeInsets.all(0),
        showFlagMain: false,
        flagWidth: 38,
        textStyle: TextStyle(
          fontSize: 16,
          color: init ? Themes.text.withAlpha(120) : Themes.text,
        ),
        dialogTextStyle: const TextStyle(fontSize: 16),
        dialogSize: Size.fromRadius(MediaQuery.of(context).size.height * 0.4),
        searchStyle: const TextStyle(fontSize: 16),
        searchDecoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Themes.primary),
          ),
        ),
        boxDecoration: BoxDecoration(
          color: Themes.bg,
          borderRadius: BorderRadius.circular(15),
        ),
        initialSelection: '+963',
        onInit: (value) {
          BlocProvider.of<AuthCubit>(context).code = value.toString();
        },
        onChanged: (value) {
          BlocProvider.of<AuthCubit>(context).code = value.toString();
          setState(() {
            init = false;
          });
        },
      ),
    );
  }
}
