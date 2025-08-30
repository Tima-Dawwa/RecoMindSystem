import 'package:dashboard/core/helper/failure.dart';

abstract class AiStatisticsState {}

class AiStatisticsInitial extends AiStatisticsState {}

class AiStatisticsSuccess extends AiStatisticsState {}

class AiStatisticsLoading extends AiStatisticsState {}

class AiStatisticsFailure extends AiStatisticsState {
  final Failure failure;
  AiStatisticsFailure({required this.failure});
}