import 'package:recomindweb/core/helpers/failure.dart';

abstract class LoginStates {}

class InitialLoginState extends LoginStates {}

class SuccessLoginState extends LoginStates {}

class LoadingLoginState extends LoginStates {}

class FailureLoginState extends LoginStates {
  final Failure failure;
  FailureLoginState({required this.failure});
}