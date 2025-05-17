import 'package:flutter/material.dart';
import 'package:recomindweb/features/Authentication/view/widgets/auth_box.dart';
import 'package:recomindweb/features/Authentication/view/widgets/register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "assets/auth_bg.jpg",
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: AuthBox(content: RegisterForm(), height: 0.9, width: 0.4,)
           ),
        ],
      ),
    );
  }
}
