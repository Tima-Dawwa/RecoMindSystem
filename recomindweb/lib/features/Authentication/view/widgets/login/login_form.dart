// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:recomindweb/core/Widgets/custom_button.dart';
import 'package:recomindweb/core/Widgets/custom_loading.dart';
import 'package:recomindweb/core/Widgets/custom_text_button.dart';
import 'package:recomindweb/core/Widgets/custom_textfield.dart';
import 'package:recomindweb/core/helpers/validators.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Authentication/view%20model/auth%20cubit/auth_cubit.dart';
import 'package:recomindweb/features/Authentication/view%20model/auth%20cubit/auth_states.dart';
import 'package:recomindweb/features/Authentication/view/login_page.dart';
import 'package:recomindweb/features/Authentication/view/register_page.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.desktop});
  final bool desktop;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  ScrollController controller = ScrollController();
  GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? email, password;
  bool obsecureText = true;
  bool open = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (BuildContext context, AuthStates state) {
        if (state is SuccessAuthState) {
          context.go('/');
        }
      },
      builder: (context, state) {
        return Form(
          key: formKey,
          autovalidateMode: autovalidateMode,
          child: Padding(
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
                  SizedBox(height: widget.desktop ? 50 : 10),
                  SizedBox(
                    // height: 40,
                    child: CustomTextfield(
                      hint: "Email",
                      validator: validateEmail,
                      type: TextInputType.emailAddress,
                      onChanged: (value) {
                        email = value;
                        print("email : $email");
                      },
                    ),
                  ),
                  SizedBox(height: widget.desktop ? 25 : 10),
                  SizedBox(
                    // height: 40,
                    child: CustomTextfield(
                      hint: "Password",
                      obscure: obsecureText,
                      validator: validatePassword,
                      onChanged: (value) {
                        password = value;
                        print("password : $password");
                      },
                      suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            open = !open;
                            obsecureText = !obsecureText;
                          });
                        },
                        icon: Icon(
                          open
                              ? FontAwesomeIcons.eye
                              : FontAwesomeIcons.eyeSlash,
                          size: 20,
                          color: open ? Themes.bg : Themes.text.withAlpha(100),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomTextButton(
                      text: "Forget your password ?",
                      color: Themes.bg.withAlpha(120),
                      weight: FontWeight.normal,
                      press: () {
                       context.go('/forget-password');
                      },
                    ),
                  ),
                  SizedBox(height: widget.desktop ? 50 : 20),
                  (state is LoadingAuthState)
                      ? CustomLoading()
                      : CustomButton(text: "Confirm", press: loginTap),
                  SizedBox(height: widget.desktop ? 25 : 10),
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
          ),
        );
      },
    );
  }

  void loginTap() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      BlocProvider.of<AuthCubit>(
        context,
      ).login(email: email!, password: password!);
    } else {
      autovalidateMode = AutovalidateMode.always;
      setState(() {});
    }
  }
}
