import 'package:go_router/go_router.dart';
import 'package:recomindweb/features/Authentication/view/login_page.dart';
import 'package:recomindweb/features/ForgetPassword/forget_password.dart';
import 'package:recomindweb/features/product_details/view/product_details_page.dart';

final GoRouter router = GoRouter(
  routes: [
    // GoRoute(
    //   path: '/',
    //   builder: (context, state) => const HomePage(),
    // ),
       GoRoute(path: '/', builder: (context, state) => ProductDetailsPage()),
    GoRoute(path: '/login', builder: (context, state) => LoginPage()),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => ForgotPasswordPage(),
    ),
  ],
);
