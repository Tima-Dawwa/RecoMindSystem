import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/core/Widgets/custom_button.dart';
import 'package:recomindweb/core/Widgets/custom_textfield.dart';
import 'package:recomindweb/core/helpers/validators.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Authentication/view%20model/forget%20password%20cubit/forget_password_cubit.dart';
import 'package:recomindweb/features/Authentication/view%20model/forget%20password%20cubit/forget_password_stpes_state.dart';
import 'package:recomindweb/features/Authentication/view/widgets/forget%20password/verification_screen.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  String? email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "assets/Images/forget-password.jpg",
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
          ),
          Center(
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Themes.primary.withAlpha(80), blurRadius: 5),
                ],
              ),
              child: BlocListener<
                ForgotPasswordCubit,
                ForgotPasswordStepsState
              >(
                listener: (context, state) {
                  if (state is SuccessStepState) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VerifyCodePage(message: state.message),
                      ),
                    );
                  } else if (state is FailureStepState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.failure.errMessage)),
                    );
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Forgot Password',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Themes.bg,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Enter your email and we’ll send you a 6-digit code to reset your password.',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Themes.bg),
                    ),
                    const SizedBox(height: 24),
                    CustomTextfield(
                      controller: _emailController,
                      validator: validateEmail,
                      hint: 'Email address',
                      onChanged: (value) {
                        email = value;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 40,
                      child: CustomButton(
                        text: 'Send Code',
                        press: () {
                          final cubit = context.read<ForgotPasswordCubit>();
                          cubit.updateEmail(email!);
                          cubit.sendResetCode();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
