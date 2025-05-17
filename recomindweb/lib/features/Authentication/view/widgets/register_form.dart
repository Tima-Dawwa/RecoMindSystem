import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:recomindweb/core/Widgets/custom_button.dart';
import 'package:recomindweb/core/Widgets/custom_text_button.dart';
import 'package:recomindweb/core/Widgets/custom_textfield.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Authentication/view/login_page.dart';
import 'package:recomindweb/features/Authentication/view/register_page.dart';
import 'package:recomindweb/features/Authentication/view/widgets/custom_country_code.dart';
import 'package:recomindweb/features/Authentication/view/widgets/gender_picker.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Hello !",
            style: TextStyle(
              color: Themes.bg,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 15),

          SizedBox(
            height: 40,
            child: CustomTextfield(
              hint: "Email",
              type: TextInputType.emailAddress,
            ),
          ),

          SizedBox(height: 20),

          SizedBox(
            height: 40,
            child: CustomTextfield(hint: "Password", obscure: true),
          ),

          SizedBox(height: 20),

          SizedBox(
            height: 40,
            child: CustomTextfield(hint: "Confirm password", obscure: true),
          ),

          SizedBox(height: 20),

          GenderPicker(),

          SizedBox(height: 20),

          SizedBox(
            height: 40,
            child: CustomTextfield(hint: "Age", type: TextInputType.number),
          ),

          SizedBox(height: 20),

          Row(
            children: [
              CustomCountryCode(),
              SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: CustomTextfield(
                    hint: "Phone number",
                    type: TextInputType.phone,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          CustomButton(text: "Confirm", press: () {}),

          SizedBox(height: 10),

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account ?",
                  style: TextStyle(color: Themes.bg, fontSize: 12),
                ),
                CustomTextButton(
                  text: "Login",
                  press: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        alignment: Alignment.center,
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.fastEaseInToSlowEaseOut,
                        child: LoginPage(),
                        childCurrent: RegisterPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
