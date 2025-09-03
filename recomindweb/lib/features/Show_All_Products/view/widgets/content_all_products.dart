import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:recomindweb/core/Widgets/custom_loading.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Show_All_Products/model/all_products_model.dart';
import 'package:recomindweb/features/Show_All_Products/view%20model/cubit/all_products_cubit.dart';
import 'package:recomindweb/features/Show_All_Products/view%20model/cubit/all_products_state.dart';
import 'package:recomindweb/features/Show_All_Products/view/widgets/fliter_department.dart';
import 'package:recomindweb/features/Show_All_Products/view/widgets/gird_all_products.dart';

class ContentAllProducts extends StatefulWidget {
  const ContentAllProducts({
    super.key,
    required this.type,
    required this.onSearch,
    required this.gender,
  });
  final String type;
  final VoidCallback onSearch;
  final String gender;

  @override
  State<ContentAllProducts> createState() => _ContentAllProductsState();
}

class _ContentAllProductsState extends State<ContentAllProducts> {
  final List<String> categories = ["New", "Trend"];
  int _currentPage = 0;
  final TextEditingController controller = TextEditingController();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  GlobalKey<FormState> formKey = GlobalKey();
  String? searchText;
  @override
  void initState() {
    super.initState();
    bool test = BlocProvider.of<AllProductsCubit>(context).searchText;
    if (test) {
      getAll();
    }
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
              : Form(
                key: formKey,
                autovalidateMode: autovalidateMode,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 2,
                          child: TextFormField(
                            controller: controller,
                            onSaved: (newValue) => {searchText = newValue},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ' this field is required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                color: Themes.primary,
                              ),
                              hintText: 'Smart Search',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Themes.primary),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          height: 40,
                          width: 120,
                          child: ElevatedButton(
                            onPressed: smartSearch,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Themes.primary,
                              foregroundColor: Colors.white,
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: Text('search'),
                          ),
                        ),
                      ],
                    ),

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
                ),
              );
        } else {
          return Text("Failure");
        }
      },
    );
  }

  void getAll() {
    print(widget.gender);
    BlocProvider.of<AllProductsCubit>(context).getAllProducts(
      page: _currentPage + 1,
      type: widget.type,
      gender: widget.gender,
    );
  }

  void smartSearch() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      widget.onSearch();
      BlocProvider.of<AllProductsCubit>(context).smartSearch(searchText!);
    } else {
      autovalidateMode = AutovalidateMode.always;
      setState(() {});
    }
  }
}
