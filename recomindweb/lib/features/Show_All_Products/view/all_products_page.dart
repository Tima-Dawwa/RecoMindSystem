import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/core/Widgets/app_scafold.dart';
import 'package:recomindweb/core/responsive_layout.dart';
import 'package:recomindweb/features/Show_All_Products/model/all_products_model.dart';
import 'package:recomindweb/features/Show_All_Products/view%20model/cubit/all_products_cubit.dart';
import 'package:recomindweb/features/Show_All_Products/view%20model/cubit/all_products_state.dart';
import 'package:recomindweb/features/Show_All_Products/view/all_products_page_desktop.dart';
import 'package:recomindweb/features/Show_All_Products/view/all_products_page_mobile.dart';

class AllProductsPage extends StatefulWidget {
  const AllProductsPage({super.key});

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AllProductsCubit>(context).getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AllProductsCubit, AllProductsState>(
        builder: (context, state) {
          List<AllProductsModel> allProducts =
              BlocProvider.of<AllProductsCubit>(context).allProducts;
          return ResponsiveLayout(
            mobileBody: AllProductsPageMobileLayout(allProducts: allProducts),
            desktopBody: AllProductsPageDesktopLayout(allProducts: allProducts),
          );
        },
      ),
    );
  }
}
