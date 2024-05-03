import 'package:cell_req/200/Helper/index.dart';
import 'package:cell_req/200/RequirementForm/RequirementForm.dart';
import '../Helper/index.dart';

class RequirementFormHome extends StatefulWidget {
  const RequirementFormHome({super.key});

  @override
  State<RequirementFormHome> createState() => _HomeState();
}

class _HomeState extends State<RequirementFormHome> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    List<Map<String, dynamic>> items = [
      {
        'icon': Icons.add_box_rounded,
        'text': 'Submit\nRequirement',
        'pageName': RequirementForm()
      },
      // {
      //   'icon': Icons.cloud_download_rounded,
      //   'text': "View\nData",
      //   'pageName': ApiDataList(), // This is another widget to navigate to
      // },
      // {
      //   'icon': Icons.delete_forever,
      //   'text': "Delete Data",
      //   'action': () => deleteAlert(
      //       context), // Correctly pass a closure wrapping the function call
      // },
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
            "Requirement Section",
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Home()));
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
                    margin: EdgeInsets.symmetric(
                        vertical: height * 0.02, horizontal: width * 0.05),
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                        color: Color(0xff015495),
                        borderRadius: BorderRadius.circular(10)),
                    height: 100,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: const Text(
                        "Selection Menu",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
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
                                action: item.containsKey('action')
                                    ? item['action']
                                    : null,
                                pageName: item.containsKey('pageName')
                                    ? item['pageName']
                                    : null,
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
    for (int i = 0; i < items.length; i += groupSize) {
      int end = i + groupSize < items.length ? i + groupSize : items.length;
      grouped.add(items.sublist(i, end));
    }
    return grouped;
  }
}

deleteData(context) async {
  var support = await Support.init();
  // var uuid = await support.getString('uuid');
  var data = {"uuid": ""};
  var registrationSuccess =
      await ApiController().uploadData(data, "deleteDataById", context);

  return registrationSuccess;
}

deleteAlert(context) {
  {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Delete Data",
      desc: "Are you sure you want to delete the phone directory data?",
      buttons: [
        DialogButton(
            child: Text(
              "Yes",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () async {
              deleteData(context);
              Navigator.pop(context);
            },
            color: Colors.green),
        DialogButton(
            child: Text(
              "No",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.of(context)
                .pop(false), // Close the dialog without performing the action.
            color: Colors.red)
      ],
    ).show();
  }
}

class CustomRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Widget? pageName;
  final VoidCallback? action;

  CustomRow({
    required this.icon,
    required this.text,
    this.pageName,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (action != null) {
          action!();
        } else if (pageName != null) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => pageName!));
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
