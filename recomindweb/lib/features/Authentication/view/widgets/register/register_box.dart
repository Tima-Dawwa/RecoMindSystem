import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';

class RegisterBox extends StatelessWidget {
  const RegisterBox({
    super.key,
    required this.content,
    required this.height,
    required this.desktop,
  });
  final Widget content;
  final double height;
  final bool desktop;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: desktop ? null : height,
      child: AspectRatio(
        aspectRatio: desktop ? 5 / 5.5 : 9 / 5,
        child: Container(
          margin:
              desktop
                  ? EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05,
                    right: 0,
                    bottom: 20,
                    top: 20,
                  )
                  : EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 0),
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Themes.primary.withAlpha(80), blurRadius: 5),
            ],
          ),
          child: content,
        ),
      ),
    );
  }
}
