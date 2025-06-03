import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/core/helpers/custom_shared_preferences.dart';
import 'package:recomindweb/features/Authentication/view%20model/auth%20cubit/auth_states.dart';
import 'package:recomindweb/features/Authentication/view%20model/auth_service.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit(this.authService) : super(InitialAuthState());

  final AuthService authService;
  CustomSharedPreferences preferences = CustomSharedPreferences();

  Future<void> login({required String email, required String password}) async {
    emit(LoadingAuthState());
    var response = await authService.login(email: email, password: password);
    response.fold(
      (failure) {
        emit(FailureAuthState(failure: failure));
      },
      (res) async {
        final token = res['token'];
        print("token $token");
        await preferences.saveToken(token);
        emit(SuccessAuthState());
      },
    );
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String number,
    required String code,
    required String gender,
    required String birthDate,
  }) async {
    emit(LoadingAuthState());
    var response = await authService.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      number: number,
      code: code,
      gender: gender,
      birthDate: birthDate,
    );
    response.fold(
      (failure) {
        emit(FailureAuthState(failure: failure));
      },
      (res) async {
        final token = res['token'];
        print("token $token");
        await preferences.saveToken(token);
        emit(SuccessAuthState());
      },
    );
  }
}
