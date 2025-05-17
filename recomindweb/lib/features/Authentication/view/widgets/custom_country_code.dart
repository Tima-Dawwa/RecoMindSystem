import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';

class CustomCountryCode extends StatelessWidget {
  const CustomCountryCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Themes.bg.withAlpha(80),
      ),
      child: CountryCodePicker(
        showFlagMain: false,
        flagWidth: 38,
        initialSelection: '+963',
        searchStyle: const TextStyle(fontSize: 16),
        dialogTextStyle: const TextStyle(fontSize: 16),
        padding: const EdgeInsets.all(0),
        textStyle: const TextStyle(
          fontSize: 16,
          color: Color.fromARGB(120, 34, 1, 53),
        ),
        dialogSize: Size.fromRadius(
          MediaQuery.of(context).size.height * 0.4,
        ),
        searchDecoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Themes.primary),
          ),
        ),
        boxDecoration: BoxDecoration(
          color: Themes.bg,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
