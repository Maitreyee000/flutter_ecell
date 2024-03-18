import 'package:cell_req/100/CellForm/CellForm.dart';
import 'package:cell_req/100/CellForm/ViewList/api_data_list.dart';

import './../Helper/index.dart';

class CellFormHome extends StatefulWidget {
  const CellFormHome({super.key});

  @override
  State<CellFormHome> createState() => _HomeState();
}

class _HomeState extends State<CellFormHome> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    List<Map<String, dynamic>> items = [
      {
        'icon': Icons.add_box_rounded,
        'text': 'Cell\nForm',
        'pageName': CellForm()
      },
      {
        'icon': Icons.cloud_download_rounded,
        'text': "View\nData",
        'pageName': ApiDataList()
      },
    ];

    return Scaffold(
      bottomNavigationBar: nicBottomBar(),
      backgroundColor: Colors.white,
      drawer: Drawer(
        backgroundColor: Colors.white,
      ),
      appBar: AppBar(
        title: Container(
          child: Text(
            "Cell Registration",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        backgroundColor: Color(0xff112948),
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => Home()),
              (Route<dynamic> route) => false,
            );
          },
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
            Container(
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    alignment: Alignment.topCenter,
                    color: Color(0xff015495),
                    height: 100,
                    child: Container(
                      margin: EdgeInsets.all(20),
                      child: Text(
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
                    margin: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
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
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ))
      ],
    );
  }
}
