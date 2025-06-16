import 'package:go_router/go_router.dart';
import 'package:recomindweb/core/helpers/custom_shared_preferences.dart';
import 'package:recomindweb/features/Authentication/view/login_page.dart';
import 'package:recomindweb/features/Authentication/view/register_page.dart';
import 'package:recomindweb/features/ChatBot/chatbot.dart';
import 'package:recomindweb/features/Authentication/view/forget_password.dart';
import 'package:recomindweb/features/Orders/views/order_details.dart';
import 'package:recomindweb/features/Orders/views/orders_page.dart';
import 'package:recomindweb/features/Show_All_Products/presentation/views/all_products_page.dart';
import 'package:recomindweb/features/product_details/view/product_details_page.dart';
import 'package:recomindweb/features/Home/view/home_page.dart';

CustomSharedPreferences prefs = CustomSharedPreferences();
bool logged = prefs.logged();

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => HomePage(logged: logged)),
    GoRoute(path: '/login', builder: (context, state) => LoginPage()),
    GoRoute(path: '/orders', builder: (context, state) => OrdersPage()),
    GoRoute(path: '/chatbot', builder: (context, state) => ChatWindow()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/all-products',
      builder: (context, state) => AllProductsPage(),
    ),
    GoRoute(
      path: '/product-details',
      builder: (context, state) => ProductDetailsPage(),
    ),
    GoRoute(
      path: '/order-details',
      builder: (context, state) => OrderDetailsPage(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => ForgotPasswordPage(),
    ),
  ],
);
