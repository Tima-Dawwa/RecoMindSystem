import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:recomindweb/core/Widgets/custom_button.dart';
import 'package:recomindweb/core/Widgets/custom_text_button.dart';
import 'package:recomindweb/core/Widgets/custom_textfield.dart';
import 'package:recomindweb/core/helpers/validators.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Authentication/view/login_page.dart';
import 'package:recomindweb/features/Authentication/view/register_page.dart';
import 'package:recomindweb/features/Authentication/view/widgets/register/custom_country_code.dart';
import 'package:recomindweb/features/Authentication/view/widgets/register/gender_picker.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();
    GlobalKey<FormState> formKey = GlobalKey();
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: SingleChildScrollView(
        controller: controller,
        child: Form(
          key: formKey,
          autovalidateMode: autovalidateMode,
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
                  hint: "Name",
                  type: TextInputType.name,
                  validator: validateName,
                ),
              ),

              SizedBox(height: 15),

              SizedBox(
                height: 40,
                child: CustomTextfield(
                  hint: "Email",
                  validator: validateEmail,
                  type: TextInputType.emailAddress,
                ),
              ),

              SizedBox(height: 15),

              SizedBox(
                height: 40,
                child: CustomTextfield(
                  hint: "Password",
                  validator: validatePassword,
                  obscure: true,
                ),
              ),

              SizedBox(height: 15),

              SizedBox(
                height: 40,
                child: CustomTextfield(
                  hint: "Confirm password",
                  validator: validatePassword,
                  obscure: true,
                ),
              ),

              SizedBox(height: 15),

              GenderPicker(),

              SizedBox(height: 15),

              SizedBox(
                height: 40,
                child: CustomTextfield(hint: "Age", type: TextInputType.number),
              ),

              SizedBox(height: 15),

              Row(
                children: [
                  CustomCountryCode(),
                  SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: CustomTextfield(
                        hint: "Phone number",
                        validator: validateNumber,
                        type: TextInputType.phone,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 15),

              CustomButton(text: "Confirm", press: () {}),

              SizedBox(height: 15),

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
        ),
      ),
    );
  }
}
