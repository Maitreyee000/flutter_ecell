import './Helper/index.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  var name;

  start() async {
    var support = await Support.instance;
    name = await support.getString('name');
    setState(() {});
  }

  _logout(BuildContext context) async {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Logout",
      desc: "Do you want to Logout ?",
      buttons: [
        DialogButton(
            child: Text(
              "Yes",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              Logout.promptLogout(context);
              setState(() {});
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (BuildContext context) => Login(),
                ),
                (Route<dynamic> route) => false,
              );
            },
            color: Colors.green),
        DialogButton(
            child: Text(
              "No",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.of(context).pop(false),
            color: Colors.red)
      ],
    ).show();
  }

  void initState() {
    super.initState();

    start();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Drawer(
      child: Container(
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Color(0xFF1a434d),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  )),
              margin: EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Image.asset(
                      'lib/assets/ashok.png',
                      scale: 8,
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 5, bottom: 20),
                      child: Text(
                        '${name}',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      )),
                ],
              ),
            ),
            ListTile(
              title: Text(
                'Home',
                style: _drawListTile(),
              ),
              leading: Icon(
                Icons.home,
                color: _iconColorDrawer(),
              ),
              onTap: () => index_redirect(context, () => Home()),
            ),
            // ListTile(
            //   title: Text(
            //     'Phone Directory',
            //     style: _drawListTile(),
            //   ),
            //   leading: Icon(
            //     Icons.phone,
            //     color: _iconColorDrawer(),
            //   ),
            //   // onTap: () =>
            //   //     index_redirect(context, () => PhoneDirectoryFormHome()),
            // ),
            // ListTile(
            //   title: Text(
            //     'Import Phone Directory',
            //     style: _drawListTile(),
            //   ),
            //   leading: Icon(
            //     Icons.install_mobile_rounded,
            //     color: _iconColorDrawer(),
            //   ),
            //   // onTap: () =>
            //   //     index_redirect(context, () => ImportPhoneDirectoryFormHome()),
            // ),
            // ListTile(
            //   title: Text(
            //     'User Management',
            //     style: _drawListTile(),
            //   ),
            //   leading: Icon(
            //     Icons.manage_accounts,
            //     color: _iconColorDrawer(),
            //   ),
            //   // onTap: () => index_redirect(context, () => UserManagementHome()),
            // ),
            Divider(),
            ListTile(
              title: Text(
                'Logout',
                style: _drawListTile(),
              ),
              leading: Icon(
                Icons.exit_to_app,
                color: _iconColorDrawer(),
              ),
              onTap: () {
                _logout(context);
              },
            ),
            ListTile(
              title: Text(
                'Back',
                style: _drawListTile(),
              ),
              leading: Icon(
                Icons.arrow_back,
                color: _iconColorDrawer(),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _drawListTile() {
    return TextStyle(color: Colors.blue, fontSize: 16);
  }

  Color _iconColorDrawer() {
    return Colors.blue;
  }

  index_redirect(context, Function pageBuilder) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => pageBuilder()));
  }
}
