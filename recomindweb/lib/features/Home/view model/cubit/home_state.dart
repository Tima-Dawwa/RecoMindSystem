import 'package:recomindweb/core/helpers/failure.dart';

abstract class HomeState {}

class InitialHomeState extends HomeState {}

class LoadingHomeState extends HomeState {}

class SuccessHomeState extends HomeState {}

class LoadingProfileState extends HomeState {}

class SuccessProfileState extends HomeState {}

class LoadingCitiesState extends HomeState {}

class SuccessCitiesState extends HomeState {}

class FailureHomeState extends HomeState {
  final Failure failure;
  FailureHomeState({required this.failure});
}


