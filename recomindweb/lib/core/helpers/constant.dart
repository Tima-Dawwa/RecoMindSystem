import 'package:recomindweb/core/helpers/service_locator.dart';
import 'package:recomindweb/features/Authentication/view%20model/auth_service.dart';
final ngrok ='${getIt.get<AuthService>().token}';