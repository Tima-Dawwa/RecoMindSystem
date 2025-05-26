import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:recomindweb/core/Widgets/custom_button.dart';
import 'package:recomindweb/core/Widgets/custom_text_button.dart';
import 'package:recomindweb/core/Widgets/custom_textfield.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Authentication/view/login_page.dart';
import 'package:recomindweb/features/Authentication/view/register_page.dart';
import 'package:recomindweb/features/ForgetPassword/forget_password.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key, required this.desktop});
  final bool desktop;
  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: SingleChildScrollView(
        controller: controller,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Welcome Back !",
              style: TextStyle(
                color: Themes.bg,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: desktop ? 50 : 10),

            SizedBox(
              height: 40,
              child: CustomTextfield(
                hint: "Email",
                type: TextInputType.emailAddress,
              ),
            ),

            SizedBox(height: desktop ? 25 : 10),

            SizedBox(
              height: 40,
              child: CustomTextfield(hint: "Password", obscure: true),
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: CustomTextButton(
                text: "Forget your password ?",
                color: Themes.bg.withAlpha(120),
                weight: FontWeight.normal,
                press: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.scale,
                      alignment: Alignment.center,
                      duration: Duration(milliseconds: 600),
                      curve: Curves.fastEaseInToSlowEaseOut,
                      child: ForgotPasswordPage(),
                      childCurrent: LoginPage(),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: desktop ? 50 : 20),

            CustomButton(text: "Confirm", press: () {}),

            SizedBox(height: desktop ? 25 : 10),

            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Dont't have an account ?",
                    style: TextStyle(color: Themes.bg, fontSize: 14),
                  ),
                  CustomTextButton(
                    text: "Sign up",
                    press: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          alignment: Alignment.center,
                          duration: Duration(milliseconds: 1000),
                          curve: Curves.fastEaseInToSlowEaseOut,
                          child: RegisterPage(),
                          childCurrent: LoginPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
