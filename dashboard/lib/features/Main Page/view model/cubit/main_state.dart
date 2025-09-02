import 'package:dashboard/core/helper/failure.dart';

abstract class MainState {}

class MainInitialState extends MainState {}

class NotificationsLoadingState extends MainState {}

class MainLoadingState extends MainState {}

class MainSuccessState extends MainState {}

class NotificationsSuccessState extends MainState {}

class MainFailureState extends MainState {
  final Failure failure;

  MainFailureState({required this.failure});
}
