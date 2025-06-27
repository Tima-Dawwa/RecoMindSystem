import 'package:dashboard/features/Product/Manage%20Existing%20Product/Product%20Details%20Mangment/model/product_Model.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/Product%20Details%20Mangment/view%20model/cubit/product_managment_states.dart';
import 'package:dashboard/features/Product/Manage%20Existing%20Product/Product%20Details%20Mangment/view%20model/manage_product_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageProductCubit extends Cubit<ManageProductStates> {
  final ManageProductService manageProductService;
  ProductModel? currentProduct;

  ManageProductCubit(this.manageProductService) : super(InitialManageProduct());

  Future<void> getProduct({required String id}) async {
    emit(LoadingManageProduct());

    final result = await manageProductService.getOneProduct(id: id);

    result.fold((failure) => emit(FailureManageProduct(failure: failure)), (
      product,
    ) {
      currentProduct = product;
      emit(SuccessManageProduct());
    });
  }

  Future<void> updateProduct({
    required String id,
    String? name,
    String? details,
    String? type,
    String? department,
    String? color,
    String? gender,
    double? price,
    int? quantity,
    String? appearance,
    double? discountPrice,
   required List<String>imagesToKeep,
    List<String>? newImages,
  }) async {
    emit(LoadingManageProduct());

    final result = await manageProductService.updateProduct(
      id: id,
      name: name,
      details: details,
      type: type,
      department: department,
      color: color,
      gender: gender,
      discountedPrice: discountPrice,
      price: price,
      quantity: quantity,
      appearance: appearance,
      imagesToKeep: imagesToKeep,
      newImages: newImages,
    );

    result.fold((failure) => emit(FailureManageProduct(failure: failure)), (
      product,
    ) {
      currentProduct = product;
      emit(SuccessManageProduct());
    });
  }

  void reset() {
    currentProduct = null;
    emit(InitialManageProduct());
  }

  bool get hasProduct => currentProduct != null;

  ProductModel? get product => currentProduct;
}
