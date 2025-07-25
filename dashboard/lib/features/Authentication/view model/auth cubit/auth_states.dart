import 'package:dashboard/core/helper/failure.dart';

abstract class AuthStates {}

class InitialAuthState extends AuthStates {}

class SuccessAuthState extends AuthStates {}

class LoadingAuthState extends AuthStates {}

class FailureAuthState extends AuthStates {
  final Failure failure;
  FailureAuthState({required this.failure});
}
