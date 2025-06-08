import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/features/product_details/view%20model/product%20details%20cubit/product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(InitialProductDetails());
}
