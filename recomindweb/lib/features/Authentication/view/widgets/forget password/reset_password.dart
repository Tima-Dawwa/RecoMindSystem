import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/core/Widgets/custom_button.dart';
import 'package:recomindweb/core/Widgets/custom_textfield.dart';
import 'package:recomindweb/core/helpers/validators.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Authentication/view%20model/forget%20password%20cubit/forget_password_cubit.dart';
import 'package:recomindweb/features/Authentication/view%20model/forget%20password%20cubit/forget_password_stpes_state.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordCubit, ForgotPasswordStepsState>(
      listener: (context, state) {
        if (state is LoadingStepState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        }

        if (state is SuccessStepState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          Navigator.popUntil(context, (route) => route.isFirst);
        } else if (state is FailureStepState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.failure.errMessage)));
        }
      },
      child: Scaffold(
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
                    BoxShadow(
                      color: Themes.primary.withAlpha(80),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'New Password',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Themes.bg,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Set a strong password you haven’t used before.',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Themes.bg),
                    ),
                    const SizedBox(height: 24),
                    CustomTextfield(
                      controller: _passwordController,
                      validator: validatePassword,
                      obscure: true,
                      hint: 'New Password',
                    ),
                    const SizedBox(height: 16),
                    CustomTextfield(
                      controller: _confirmController,
                      validator: validatePassword,
                      obscure: true,
                      hint: 'Confirm Password',
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 40,
                      child: CustomButton(
                        text: 'Reset Password',
                        press: _submit,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    final password = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();

    if (password.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }
    if (password != confirm) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }
    context.read<ForgotPasswordCubit>().resetPassword(password, confirm);
  }
}
