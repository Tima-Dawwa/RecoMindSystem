import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:recomindweb/core/Widgets/custom_loading.dart';
import 'package:recomindweb/features/Show_All_Products/model/all_products_model.dart';
import 'package:recomindweb/features/Show_All_Products/view%20model/cubit/all_products_cubit.dart';
import 'package:recomindweb/features/Show_All_Products/view%20model/cubit/all_products_state.dart';
import 'package:recomindweb/features/Show_All_Products/view/widgets/fliter_department.dart';
import 'package:recomindweb/features/Show_All_Products/view/widgets/gird_all_products.dart';

class ContentAllProducts extends StatefulWidget {
  const ContentAllProducts({super.key, required this.type});
  final String type;

  @override
  State<ContentAllProducts> createState() => _ContentAllProductsState();
}

class _ContentAllProductsState extends State<ContentAllProducts> {
  final List<String> categories = ["New", "Trend"];
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    getAll();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllProductsCubit, AllProductsState>(
      builder: (context, state) {
        if (state is AllProductsLoadingState) {
          return Center(child: CustomLoading());
        } else if (state is AllProductsSuccessState ||
            state is AllProductsFilterState) {
          List<AllProductsModel> allProducts =
              BlocProvider.of<AllProductsCubit>(context).allProducts;
          int count =
              BlocProvider.of<AllProductsCubit>(context).countAllProducts;

          return allProducts.isEmpty
              ? Center(child: Text("No Products"))
              : Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        FilterDepartment(
                          categories: categories,
                          currentPage: _currentPage,
                          type: widget.type,
                        ),
                        GridAllProducts(allProducts: allProducts),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 100,
                      vertical: 8,
                    ),
                    child: NumberPaginator(
                      numberPages: (count == 0) ? 1 : (count / 50).ceil(),
                      initialPage: _currentPage,
                      onPageChange: (int index) {
                        setState(() {
                          _currentPage = index;
                          getAll();
                        });
                      },
                      child: SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                            PrevButton(),
                            Expanded(child: NumberContent()),
                            NextButton(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
        } else {
          return Text("Failure");
        }
      },
    );
  }

  void getAll() {
    BlocProvider.of<AllProductsCubit>(
      context,
    ).getAllProducts(page: _currentPage + 1, type: widget.type);
  }
}
