import 'package:flutter/material.dart';
import 'package:recomindweb/features/Authentication/view/widgets/register/register_box.dart';
import 'package:recomindweb/features/Authentication/view/widgets/register/register_form.dart';

class RegisterPageBody extends StatelessWidget {
  const RegisterPageBody({
    super.key,
    required this.desktop,
    required this.h,
    required this.image,
    required this.imageAlign,
    required this.boxAlign,
  });

  final bool desktop;
  final double h;
  final String image;
  final AlignmentGeometry imageAlign;
  final AlignmentGeometry boxAlign;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: imageAlign,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                "assets/Images/$image.jpg",
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return Align(
                alignment: boxAlign,
                child: RegisterBox(
                  height: constraints.maxHeight * h,
                  desktop: desktop,
                  content: RegisterForm(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
