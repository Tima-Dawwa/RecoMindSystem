import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/features/Authentication/view%20model/forget_password_services.dart';
import 'package:recomindweb/features/Authentication/view%20model/forget%20password%20cubit/forget_password_stpes_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordStepsState> {
  final ForgetPasswordServices forgetPasswordServices;
  String? _email;
  String? _code;

  ForgotPasswordCubit(this.forgetPasswordServices) : super(InitialStepState());

  void updateEmail(String email) {
    _email = email;
  }

  void sendResetCode() async {
    if (_email == null) return;
    emit(LoadingStepState());

    final result = await forgetPasswordServices.forgetPassword(email: _email!);
    result.fold((failure) => emit(FailureStepState(failure: failure)), (
      response,
    ) {
      final message = response['message'];
      emit(SuccessStepState(message: message));
    });
  }

  void verifyCode(String code) async {
    if (_email == null) return;
    emit(LoadingStepState());

    final result = await forgetPasswordServices.verifyToken(
      email: _email!,
      code: code,
    );

    result.fold((failure) => emit(FailureStepState(failure: failure)), (
      response,
    ) {
      _code = code;
      final message = response['message'] ;
      emit(SuccessStepState(message: message));
    });
  }

  void resetPassword(String password, String confirmPassword) async {
    if (_email == null || _code == null) return;
    emit(LoadingStepState());

    final result = await forgetPasswordServices.resetPassword(
      email: _email!,
      code: _code!,
      password: password,
      confirmPassword: confirmPassword,
    );

    result.fold(
      (failure) => emit(FailureStepState(failure: failure)),
      (response) =>
          emit(FinalStepState(message: "Password reset successfully")),
    );
  }
}
