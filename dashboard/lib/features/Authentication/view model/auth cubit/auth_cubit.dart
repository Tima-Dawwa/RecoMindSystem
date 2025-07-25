// ignore_for_file: avoid_print
import 'package:dashboard/core/helper/custom_shared_preferences.dart';
import 'package:dashboard/features/Authentication/view%20model/auth%20cubit/auth_states.dart';
import 'package:dashboard/features/Authentication/view%20model/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit(this.authService) : super(InitialAuthState());

  final AuthService authService;
  CustomSharedPreferences preferences = CustomSharedPreferences();
  String? code, gender, birthDate;
  Future<void> login({
    required String username,
    required String password,
  }) async {
    emit(LoadingAuthState());
    var response = await authService.login(
      username: username,
      password: password,
    );
    response.fold(
      (failure) {
        emit(FailureAuthState(failure: failure));
      },
      (res) async {
        final token = res['token'];
        await preferences.saveToken(token);
        if (await preferences.logged()) {
          emit(SuccessAuthState());
        } else {
          print('not logged');
        }
      },
    );
  }
}
