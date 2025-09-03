import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/core/responsive_layout.dart';
import 'package:recomindweb/features/Show_All_Products/view%20model/cubit/all_products_cubit.dart';
import 'package:recomindweb/features/Show_All_Products/view%20model/cubit/all_products_state.dart';
import 'package:recomindweb/features/Show_All_Products/view/all_products_page_desktop.dart';
import 'package:recomindweb/features/Show_All_Products/view/all_products_page_mobile.dart';

class AllProductsPage extends StatefulWidget {
  const AllProductsPage({super.key, required this.gender});
  final String gender;
  
  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AllProductsCubit, AllProductsState>(
        listener: (context, state) {
          if (state is AllProductsFilterState) {
            final messenger = ScaffoldMessenger.of(context);
            messenger.clearSnackBars();
            messenger.showSnackBar(
              const SnackBar(content: Text("Filter applied")),
            );
          }
        },
        builder: (context, state) {
          return ResponsiveLayout(
            mobileBody: AllProductsPageMobileLayout(gender: widget.gender,),
            desktopBody: AllProductsPageDesktopLayout(gender: widget.gender,),
          );
        },
      ),
    );
  }
}
