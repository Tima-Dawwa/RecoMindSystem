import 'package:go_router/go_router.dart';
import 'package:recomindweb/features/Authentication/view/login_page.dart';
import 'package:recomindweb/features/ChatBot/chatbot.dart';
import 'package:recomindweb/features/ForgetPassword/forget_password.dart';
import 'package:recomindweb/features/Show_All_Products/presentation/views/all_products_page.dart';
import 'package:recomindweb/features/product_details/view/product_details_page.dart';
import 'package:recomindweb/product_test.dart';

final GoRouter router = GoRouter(
  routes: [
    // GoRoute(
    //   path: '/',
    //   builder: (context, state) => const HomePage(),
    // ),
    GoRoute(path: '/', builder: (context, state) => AllProductsPage()),
    GoRoute(path: '/product_details',builder: (context, state) => ProductDetailsPage(), ),
    GoRoute(path: '/login', builder: (context, state) => LoginPage()),
    GoRoute(path: '/forgot-password',builder: (context, state) => ForgotPasswordPage(),),
    GoRoute(path: '/all-products',builder: (context, state) => AllProductsPage(),),
  ],
);
