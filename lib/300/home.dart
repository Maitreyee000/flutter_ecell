import 'package:cell_req/300/SveepForm/SveepForm.dart';
import 'package:cell_req/300/SveepForm/SveepFormHome.dart';

import '../300/Helper/index.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
              Logout.logoutFun();
              setState(() {});
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (BuildContext context) => Login(),
                ),
                (Route<dynamic> route) => false,
              );
              // SystemNavigator.pop();
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

  double curSlide = 1;
  List slides = [1, 2, 3];
  String? name;
  Future<void> loadData() async {
    var support = await Support.init();
    name = await support.getString('name');
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    List<Map<String, dynamic>> items = [
      {
        'icon': Icons.document_scanner_outlined,
        'text': 'Sveep Form',
        'pageName': SveepFormHome()
      },
    ];

    return Scaffold(
      bottomNavigationBar: nicBottomBar(),
      backgroundColor: Colors.white,
      drawer: SideBar(),
      appBar: AppBar(
        actions: [
          Container(
            margin: EdgeInsets.only(right: width * .05),
            child: GestureDetector(
              child: Icon(Icons.logout),
              onTap: () {
                _logout(context);
              },
            ),
          )
        ],
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff112948),
        title: Container(
          margin: EdgeInsets.only(left: width * 0.15),
          child: const Text(
            "eCell System",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: width,
                  height: height * 0.05,
                  decoration: BoxDecoration(
                    color: Color(0xff112948),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    top: height * 0.02,
                  ),
                  width: width,
                  height: height * 0.055,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100)),
                ),
              ],
            ),
            // Container(
            //   width: width,
            //   child: Center(
            //     child: CarouselSlider(
            //       options: CarouselOptions(
            //         onPageChanged: (value, reason) {
            //           setState(() {
            //             curSlide = value.toDouble();
            //           });
            //         },
            //         height: MediaQuery.of(context).size.height * .22,
            //         viewportFraction: 1,
            //         autoPlay: true,
            //         autoPlayInterval: const Duration(seconds: 4),
            //         autoPlayAnimationDuration: const Duration(seconds: 2),
            //         autoPlayCurve: Curves.ease,
            //         enlargeCenterPage: true,
            //       ),
            //       items: slides.map((i) {
            //         return Image.asset(
            //           "lib/assets/slide-$i.jpg",
            //           fit: BoxFit.cover, // This line was changed
            //         );
            //       }).toList(),
            //     ),
            //   ),
            // ),
            Container(
              width: width * 0.7,
              height: height * 0.27,
              margin: const EdgeInsets.only(right: 15, left: 15),
              decoration: BoxDecoration(
                color: Color(0xFF1a434d),
                borderRadius: BorderRadius.circular(10),
              ),
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
                      margin: EdgeInsets.only(
                        top: 5,
                      ),
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

            Container(
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    alignment: Alignment.topCenter,
                    color: Color(0xff015495),
                    height: 100,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: const Text(
                        "Selection Menu",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 60, horizontal: 20),
                    height: (height * 0.12) * (items.length / 3).ceil(),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: groupItems(items, 3).map((group) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: group.map((item) {
                            return Expanded(
                              child: CustomRow(
                                icon: item['icon'],
                                text: item['text'],
                                pageName:
                                    item['pageName'], // This should be a Widget
                              ),
                            );
                          }).toList(),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget nicBottomBar() {
    return Container(
      child: Image.asset(
        'lib/assets/bottomLogo.png',
      ),
    );
  }

  List<List<Map<String, dynamic>>> groupItems(
      List<Map<String, dynamic>> items, int groupSize) {
    List<List<Map<String, dynamic>>> grouped = [];
    for (var i = 0; i < items.length; i += groupSize) {
      var end = (i + groupSize < items.length) ? i + groupSize : items.length;
      grouped.add(items.sublist(i, end));
    }
    return grouped;
  }
}

class CustomRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Widget? pageName;

  CustomRow({required this.icon, required this.text, required this.pageName});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => pageName!));
          },
          child: Column(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 35,
              ),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        )
      ],
    );
  }
}
