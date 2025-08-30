import 'package:dashboard/core/widgets/side_bar.dart';
import 'package:go_router/go_router.dart';
// import 'package:dashboard/features/Authentication/view/login_page.dart';

final GoRouter router = GoRouter(
  routes: [
    // GoRoute(path: '/', builder: (context, state) => LoginPage()),dashboard
    GoRoute(path: '/', builder: (context, state) => SideBar()),
  ],
);
