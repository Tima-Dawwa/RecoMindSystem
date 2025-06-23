import 'package:dashboard/core/utils/theme.dart';
import 'package:dashboard/core/widgets/custom_button.dart';
import 'package:dashboard/core/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPageBody extends StatefulWidget {
  const LoginPageBody({super.key});

  @override
  State<LoginPageBody> createState() => _LoginPageBodyState();
}

class _LoginPageBodyState extends State<LoginPageBody> {
  GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? email, password;
  bool obsecureText = true;
  bool open = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Themes.primary.withAlpha(80), blurRadius: 5),
          ],
        ),
        child: Form(
          key: formKey,
          autovalidateMode: autovalidateMode,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Welcome",
                style: TextStyle(
                  fontSize: 35,
                  color: Themes.bg,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              SizedBox(
                child: CustomTextfield(
                  hint: 'Email',
                  type: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                child: CustomTextfield(
                  hint: 'Password',
                  obscure: obsecureText,
                  onChanged: (value) {
                    password = value;
                  },
                  suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        open = !open;
                        obsecureText = !obsecureText;
                      });
                    },
                    icon: Icon(
                      open ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                      size: 20,
                      color: open ? Themes.bg : Themes.text.withAlpha(100),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              CustomButton(text: "Confirm", press: loginTap),
            ],
          ),
        ),
      ),
    );
  }

  void loginTap() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      // BlocProvider.of<AuthCubit>(
      //   context,
      // ).login(email: email!, password: password!);
    } else {
      autovalidateMode = AutovalidateMode.always;
      setState(() {});
    }
  }
}
