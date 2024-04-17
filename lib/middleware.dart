import 'index.dart';

class Middleware extends StatefulWidget {
  @override
  State<Middleware> createState() => _MiddlewareState();
}

class _MiddlewareState extends State<Middleware> {
  Future<void> start() async {
    var support = await Support.init();
    String? statusCode = await support.getString('statusCode');
    String? uuid = await support.getString('uuid');
    String? token = await support.getString('token');
    bool justLoggedIn = await support.getBool('justLoggedIn') ?? false;

    if (token != null && uuid != null) {
      try {
        final jwt = JWT.decode(token);
        if (jwt.payload['exp'] != null) {
          final expiryTime =
              DateTime.fromMillisecondsSinceEpoch(jwt.payload['exp'] * 1000);
          if (expiryTime.isBefore(DateTime.now())) {
            logoutAndShowMessage();
            navigateTo(Login());
          } else {
            Navigator.pushReplacementNamed(context, statusCode!);
          }
        }
      } on JWTException catch (e) {
        logoutAndShowMessage();
        navigateTo(Login());
      }
    } else {
      navigateTo(Login());
    }
  }

  void logoutAndShowMessage() {
    Logout.promptLogout(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Your session has expired. Please log in again.'),
      ),
    );
  }

  void navigateTo(Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  void initState() {
    super.initState();
    checkDeviceSecurity();
  }

  Future<void> checkDeviceSecurity() async {
    // await start();
    bool isJailbroken = await FlutterJailbreakDetection.jailbroken;
    bool isDeveloperMode = await FlutterJailbreakDetection.developerMode;
    bool isSignatureValid = await PlatformService.checkAppSignature();

    if (isJailbroken || isSignatureValid == false || isDeveloperMode) {
      Navigator.pushReplacementNamed(context, "404");
    } else {
      await start();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFe4eff4),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.15,
            ),
            Center(
              child: Image.asset(
                'lib/assets/loading.gif',
                scale: 1,
              ),
            )
          ],
        ),
      ),
    );
  }
}
