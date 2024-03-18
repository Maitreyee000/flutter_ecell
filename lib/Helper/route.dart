// route.dart

import '../index.dart';
import '../100/Helper/middleware.dart' as m_100;
import '../200/Helper/middleware.dart' as m_200;
import '../300/Helper/middleware.dart' as m_300;

class RouteManager {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '100':
        return MaterialPageRoute(builder: (context) => m_100.Middleware());
      case '200':
        return MaterialPageRoute(builder: (context) => m_200.Middleware());
      case '300':
        return MaterialPageRoute(builder: (context) => m_300.Middleware());
      default:
        return MaterialPageRoute(builder: (context) => Login());
    }
  }
}
