import 'package:dashboard/dashboard.dart';
import 'package:dashboard/features/Main%20Page/main_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/dashboard', builder: (context, state) => Dashboard()),
    GoRoute(path: '/main_page', builder: (context, state) => MainPageScreen()),
    // '/product/add': (context) => AddProductScreen(),
    // '/product/manage': (context) => ManageProductsScreen(),
    // '/orders': (context) => OrderPageScreen(),
    // '/ai_page': (context) => AIPageScreen(),
  ],
);
