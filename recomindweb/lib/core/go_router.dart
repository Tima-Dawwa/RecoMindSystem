import 'package:get/get.dart';
import 'package:recomindweb/features/Authentication/view/login_page.dart';
import 'package:recomindweb/features/Authentication/view/register_page.dart';
import 'package:recomindweb/features/Cart/view/cart_page.dart';
import 'package:recomindweb/features/Authentication/view/forget_password.dart';
import 'package:recomindweb/features/Favourites/view/favourites_page.dart';
import 'package:recomindweb/features/Orders/views/order_details.dart';
import 'package:recomindweb/features/Orders/views/orders_page.dart';
import 'package:recomindweb/features/Show_All_Products/view/all_products_page.dart';
// import 'package:recomindweb/features/product_details/view/product_details_page.dart';

List<GetPage> routes = [
  GetPage(name: '/', page: () => CartPage()),

  GetPage(name: '/login', page: () => LoginPage()),
  GetPage(name: '/register', page: () => RegisterPage()),
  GetPage(name: '/forgot-password', page: () => ForgotPasswordPage()),

  GetPage(name: '/all-products', page: () => AllProductsPage()),

  // GetPage(name: '/product-details', page: () => ProductDetailsPage()),

  // GetPage(name: '/chatbot', page: () => ChatPage(serverUrl: "", token: "")),
  GetPage(name: '/orders', page: () => OrdersPage()),
  GetPage(name: '/order_details', page: () => OrderDetailsPage()),

  GetPage(name: '/cart', page: () => CartPage()),
  GetPage(name: '/favourites', page: () => FavouritesPage()),
];
