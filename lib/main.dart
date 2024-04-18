import 'index.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Timer? _rootTimer;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp());
    configLoading();
  });
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 100)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..maskColor = const Color(0x7F2196F3) // Use the desired color value

    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => AppRoot();
}

class AppRoot extends StatefulWidget {
  @override
  AppRootState createState() => AppRootState();
}

class AppRootState extends State<AppRoot> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initializeTimer();
  }

  void initializeTimer() {
    if (_rootTimer != null) _rootTimer!.cancel();
    // const time = Duration(seconds: 15);
    const time = Duration(minutes: 30);
    _rootTimer = Timer(time, logOutUser); // Call logOutUser without parentheses
  }

  void logOutUser() async {
    final prefs = await SharedPreferences.getInstance();

    Logout.logoutFun();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Phone has been idle for more than 30 minutes'),
      ),
    );

    navigatorKey.currentState!.pushReplacement(
      MaterialPageRoute(
        builder: (context) => Login(),
      ),
    );

    _rootTimer?.cancel();
    // Restart the timer here
    initializeTimer();
  }

// You'll probably want to wrap this function in a debounce
  void _handleUserInteraction([_]) {
    if (_rootTimer != null && !_rootTimer!.isActive) {
      // This means the user has been logged out
      return;
    }
    _rootTimer?.cancel();

    initializeTimer();
  }

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _handleUserInteraction,
      onPointerMove: _handleUserInteraction,
      onPointerUp: _handleUserInteraction,
      child: MaterialApp(
          onGenerateRoute: RouteManager.generateRoute,
          debugShowCheckedModeBanner: false,
          title: 'Cell Requirement System',
          theme: ThemeData(
            primarySwatch: createMaterialColor(Color(0xff1e3799)),
          ),
          navigatorKey: navigatorKey, // Use navigatorKey here
          home: Middleware(),
          builder: EasyLoading.init()),
    );
  }
}



// 

