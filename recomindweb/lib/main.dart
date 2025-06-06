import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:recomindweb/core/go_router.dart';
import 'package:recomindweb/core/helpers/service_locator.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Authentication/view%20model/auth%20cubit/auth_cubit.dart';
import 'package:recomindweb/features/Authentication/view%20model/auth_service.dart';
import 'package:recomindweb/features/Authentication/view%20model/forget%20password%20cubit/forget_password_cubit.dart';
import 'package:recomindweb/features/Authentication/view%20model/forget_password_services.dart';

void main() async {
  await setup();
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(getIt.get<AuthService>())),
        BlocProvider(
          create:
              (context) =>
                  ForgotPasswordCubit(getIt.get<ForgetPasswordServices>()),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        title: 'Trendova',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Themes.primary,
          fontFamily: 'CoconNext',
          scaffoldBackgroundColor: Themes.bg,
        ),
      ),
    );
  }
}
