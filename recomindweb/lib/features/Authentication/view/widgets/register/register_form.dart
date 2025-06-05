import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:recomindweb/features/Authentication/view/widgets/register/custom_country_code.dart';
import 'package:recomindweb/features/Authentication/view/widgets/register/custom_date_picker.dart';
import 'package:recomindweb/features/Authentication/view/widgets/register/gender_picker.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  ScrollController controller = ScrollController();
  TextEditingController date = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? email, password, confirmPassword, number, firstName, lastName;
  bool obsecureText = true;
  bool open = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is SuccessAuthState) {
          print("go to home");
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
                    "Hello !",
                    style: TextStyle(
                      color: Themes.bg,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: CustomTextfield(
                            hint: "First name",
                            type: TextInputType.name,
                            validator: validateName,
                            onChanged: (value) {
                              firstName = value;
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: CustomTextfield(
                            hint: "Last name",
                            type: TextInputType.name,
                            validator: validateName,
                            onChanged: (value) {
                              lastName = value;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 15),

                  SizedBox(
                    height: 40,
                    child: CustomTextfield(
                      hint: "Email",
                      validator: validateEmail,
                      type: TextInputType.emailAddress,
                      onChanged: (value) {
                        email = value;
                      },
                    ),
                  ),

                  SizedBox(height: 15),

                  SizedBox(
                    height: 40,
                    child: CustomTextfield(
                      hint: "Password",
                      validator: validatePassword,
                      obscure: true,
                      onChanged: (value) {
                        password = value;
                      },
                    ),
                  ),

                  SizedBox(height: 15),

                  SizedBox(
                    height: 40,
                    child: CustomTextfield(
                      hint: "Confirm password",
                      validator: validatePassword,
                      obscure: true,
                      onChanged: (value) {
                        confirmPassword = value;
                      },
                    ),
                  ),

                  SizedBox(height: 15),
                  GenderPicker(),
                  SizedBox(height: 15),
                  CustomDatePicker(),
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
                            onChanged: (value) {
                              number = value;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 15),

                  (state is LoadingAuthState)
                      ? CustomLoading()
                      : CustomButton(text: "Confirm", press: registerTap),
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
      },
    );
  }

  void registerTap() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      BlocProvider.of<AuthCubit>(context).register(
        email: email!,
        password: password!,
        firstName: firstName!,
        lastName: lastName!,
        confirmPassword: confirmPassword!,
        number: number!,
      );
    } else {
      autovalidateMode = AutovalidateMode.always;
      setState(() {});
    }
  }
}
