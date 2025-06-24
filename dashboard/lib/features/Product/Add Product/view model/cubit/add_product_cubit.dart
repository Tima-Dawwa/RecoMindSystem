import 'package:dashboard/features/Product/Add%20Product/Model/product_add.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/features/Product/Add%20Product/view%20model/add_product_service.dart';
import 'package:dashboard/features/Product/Add%20Product/view%20model/cubit/add_product_cubit_states.dart';
import 'package:dashboard/core/helper/failure.dart';
class AddProductCubit extends Cubit<AddProductState> {
  final AddProductService addProductService;

  AddProductCubit(this.addProductService) : super(InitialAddProduct());

  Future<void> addProduct(ProductFormData product) async {
    emit(LoadingAddProduct());

    final result = await addProductService.addProduct(
      name: product.name,
      details: product.details,
      type: product.type,
      department: product.department,
      color: product.color,
      gender: product.gender,
      price: product.price,
      quantity: product.quantity,
      appearance: product.appearance,
      images: product.images,
    );

    result.fold((failure) => emit(FailureAddProduct(failure: failure)), (data) {
      try {
      
        final message = data["message"];
        emit(SuccessAddProduct(message: message));
      } catch (e) {
        emit(
          FailureAddProduct(
            failure: Failure(
              errTitle: "Parsing Error",
              errMessage: e.toString(),
            ),
          ),
        );
      }
    });
  }
}
