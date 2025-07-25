import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/core/helper/validators.dart';
import 'package:dashboard/core/utils/theme.dart';
import 'package:dashboard/core/widgets/custom_button.dart';
import 'package:dashboard/core/widgets/custom_textfield.dart';
import 'package:dashboard/features/Authentication/view%20model/auth%20cubit/auth_cubit.dart';
import 'package:dashboard/features/Authentication/view%20model/auth%20cubit/auth_states.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class LoginPageBody extends StatefulWidget {
  const LoginPageBody({super.key});

  @override
  State<LoginPageBody> createState() => _LoginPageBodyState();
}

class _LoginPageBodyState extends State<LoginPageBody> {
  GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? username, password;
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
        child: BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {
            if (state is SuccessAuthState) {
              context.go('/dashboard');
            }
          },
          builder: (context, state) {
            return Form(
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
                      hint: 'Admin name',
                      type: TextInputType.name,
                      validator: validateName,
                      onChanged: (value) {
                        username = value;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    child: CustomTextfield(
                      hint: 'Password',
                      obscure: obsecureText,
                      validator: validatePassword,
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
                          open
                              ? FontAwesomeIcons.eye
                              : FontAwesomeIcons.eyeSlash,
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
            );
          },
        ),
      ),
    );
  }

  void loginTap() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      BlocProvider.of<AuthCubit>(
        context,
      ).login(username: username!, password: password!);
    } else {
      autovalidateMode = AutovalidateMode.always;
      setState(() {});
    }
  }
}
