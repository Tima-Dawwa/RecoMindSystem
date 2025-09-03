import 'package:flutter/material.dart';
import 'package:recomindweb/features/Show_All_Products/model/all_products_model.dart';
import 'package:recomindweb/features/Show_All_Products/view/widgets/all_product_card/all_product_card.dart';

class GridAllProducts extends StatefulWidget {
  const GridAllProducts({super.key, required this.allProducts});

  final List<AllProductsModel> allProducts;

  @override
  State<GridAllProducts> createState() => _GridAllProductsState();
}

class _GridAllProductsState extends State<GridAllProducts> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 280,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: widget.allProducts.length,
          itemBuilder: (context, index) {
            return AllProductCard(
              product: widget.allProducts[index],
              index: index,
              onTap: () {
              },
            );
          },
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:number_paginator/number_paginator.dart';
// import 'package:recomindweb/features/Show_All_Products/model/all_products_model.dart';
// import 'package:recomindweb/features/Show_All_Products/view%20model/cubit/all_products_cubit.dart';
// import 'package:recomindweb/features/Show_All_Products/view/widgets/all_product_card/all_product_card.dart';

// class GridAllProducts extends StatefulWidget {
//   const GridAllProducts({
//     super.key,
//     required this.price,
//     required this.type,
//     required this.allProducts,
//   });

//   final String type;
//   final double price;
//   final List<AllProductsModel> allProducts;

//   @override
//   State<GridAllProducts> createState() => _GridAllProductsState();
// }

// class _GridAllProductsState extends State<GridAllProducts> {
//   int _currentPage = 0;
//   final int _itemsPerPage = 15; // عدد المنتجات في كل صفحة

//   // late List<Product> dummyProducts;

//   @override
//   void initState() {
//     super.initState();
//     // BlocProvider.of<AllProductsCubit>(context).getAllProducts(page:_currentPage , )
//     // dummyProducts = List.generate(
//     //   10000,
//     //   (index) => Product(
//     //     name: 'Product ${index + 1}',
//     //     price: (index + 1) * 100.0,
//     //     rating: 4.0 + (index % 2 == 0 ? 0.5 : 0.0),
//     //     imageUrl: 'assets/main_image.jpg',
//     //     gender: 'male',
//     //     category: 'ss',
//     //     isFavorite: true,
//     //     isTrending: true,
//     //     tagType: '',
//     //   ),
//     // );
    
//   }

//   @override
//   Widget build(BuildContext context) {
//     // حساب بداية ونهاية المنتجات في الصفحة الحالية
//     final int startIndex = _currentPage * _itemsPerPage;
//     final int endIndex =
//         (_currentPage + 1) * _itemsPerPage > widget.allProducts.length
//             ? widget.allProducts.length
//             : (_currentPage + 1) * _itemsPerPage;

//     final List<AllProductsModel> currentPageItems = widget.allProducts.sublist(
//       startIndex,
//       endIndex,
//     );

//     return Expanded(
//       child: Column(
//         children: [
//           // شبكة المنتجات
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
//                   maxCrossAxisExtent: 280,
//                   childAspectRatio: 0.75,
//                   crossAxisSpacing: 16,
//                   mainAxisSpacing: 16,
//                 ),
//                 itemCount: currentPageItems.length,
//                 itemBuilder: (context, index) {
//                   return AllProductCard(
//                     product: widget.allProducts[index],
//                     onTap: () {
//                       // ScaffoldMessenger.of(context).showSnackBar(
//                       //   SnackBar(
//                       //     content: Text(
//                       //       'Selected product: ${currentPageItems[index].name}',
//                       //     ),
//                       //   ),
//                       // );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ),

//           // Paginator
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: NumberPaginator(
//               numberPages: (widget.allProducts.length / _itemsPerPage).ceil(),
//               initialPage: _currentPage,
//               onPageChange: (int index) {
//                 setState(() {
//                   _currentPage = index;
//                 });
//               },
//               child: SizedBox(
//                 height: 48,
//                 child: Row(
//                   children: [
//                     PrevButton(),
//                     Expanded(child: NumberContent()),
//                     NextButton(),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// //test