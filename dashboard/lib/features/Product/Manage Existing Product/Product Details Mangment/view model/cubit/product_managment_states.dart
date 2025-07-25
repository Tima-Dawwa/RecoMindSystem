import 'package:dashboard/core/helper/failure.dart';

class ManageProductStates {}

class InitialManageProduct extends ManageProductStates {}

class LoadingManageProduct extends ManageProductStates {}

class SuccessManageProduct extends ManageProductStates {}

class FailureManageProduct extends ManageProductStates {
  final Failure failure;

  FailureManageProduct({required this.failure});
}
