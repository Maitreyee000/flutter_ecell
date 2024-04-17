import 'index.dart';

class Middleware extends StatefulWidget {
  const Middleware({super.key});

  @override
  State<Middleware> createState() => _MiddlewareState();
}

class _MiddlewareState extends State<Middleware> {
  Future<void> start() async {
    var support = await Support.init();
    String? uuid = await support.getString('uuid');
    bool justLoggedIn = await support.getBool('justLoggedIn') ?? false;
    try {
      if (uuid != null) {
        if (justLoggedIn) {
          await FileManager().deleteAllFiles();
          await support.setBool('justLoggedIn', false);
          if (await loadData(uuid)) {
            navigateTo(Home());
          } else {
            logoutAndShowMessage();
            navigateTo(Login());
          }
        } else {
          navigateTo(Home());
        }
      } else {
        logoutAndShowMessage();
        navigateTo(Login());
      }
    } catch (e) {
      logoutAndShowMessage();
      navigateTo(Login());
    }
  }

  Future<bool> loadData(String? uuid) async {
    var support = await Support.init();
    String? _token = await support.getString('token');
    String? statusCode = await support.getString('statusCode');
    //api_urls
    return true;
  }

  void logoutAndShowMessage() {
    Logout.logoutFun();
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

    Future<void> requestPermissions() async {
      if (await Permission.storage.request().isGranted) {
        // Permission granted. You can now access the file system directories.
      } else {
        // Permission denied.
      }
    }

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      requestPermissions();
      start();
    });
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
            ),
          ],
        ),
      ),
    );
  }
}
