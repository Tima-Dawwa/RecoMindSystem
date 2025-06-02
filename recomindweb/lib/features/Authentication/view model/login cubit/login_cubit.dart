import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/features/Authentication/view%20model/login%20cubit/login_states.dart';
import 'package:recomindweb/features/Authentication/view%20model/login_service.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit(this.loginService) : super(InitialLoginState());

  final LoginService loginService;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LoadingLoginState());
    var response = await loginService.login(
      email: email,
      password: password,
    );
    response.fold(
      (failure) {
        emit(FailureLoginState(failure: failure));
      },
      (res) {
        emit(SuccessLoginState());
      },
    );
  }
}
