import 'package:cell_req/300/SveepForm/ViewDetails/api_details.dart';

import '../../../300/Helper/index.dart';
import 'package:http/http.dart' as http;

class ApiDataList extends StatefulWidget {
  const ApiDataList({super.key, this.adata});
  final adata;
  @override
  State<ApiDataList> createState() => _ApiDataListState();
}

class _ApiDataListState extends State<ApiDataList> {
  dynamic details;
  bool isLoading = true;
  EdgeInsetsGeometry kRowPadding =
      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0);
  final apiController = ApiController();
  TextStyle kTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 15);

  Future<void> loadInitialData() async {
    var support = await Support.init();
    var uuid = await support.getString("uuid");
    var data = {"phone": uuid.toString()};

    details = await apiController.getDataListById(
        context, "get_all_list_by_district", data);

    setState(() {
      isLoading = false;
    });
  }

  Future<void> showLoading() async {
    await loadInitialData();
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;

    showLoading();
  }

  @override
  Widget build(BuildContext context) {
    // Ensure you handle the isLoading state appropriately
    if (isLoading) {
      return Scaffold(
          bottomNavigationBar: nicBottomBar(),
          appBar: AppBar(
            title: Container(
              child: Text(
                "User List",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            backgroundColor: Color(0xff112948),
            leading: GestureDetector(
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: Center(child: CircularProgressIndicator()));
    }

    // Logic corrected: Entire column now conditional on details being non-empty
    return Scaffold(
      bottomNavigationBar: nicBottomBar(),
      appBar: AppBar(
        title: Container(
          child: Text(
            "Sveep Uploaded Data List",
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
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: details == null || details!.isEmpty
            ? Center(
                child: Text(
                  "No Data Available",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              )
            : Column(
                children: [
                  buildTableHeader(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: details?.length ?? 0,
                      itemBuilder: (context, index) => buildTableRow(index),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget buildTableHeader() {
    return Card(
      color: const Color.fromARGB(255, 0, 0, 0),
      child: Padding(
        padding: kRowPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildCell("Sl",
                flex: 1, textAlign: TextAlign.left, color: Colors.white),
            VerticalDivider(),
            buildCell("Name", flex: 2, color: Colors.white),
            VerticalDivider(),
            buildCell("Remark", flex: 2, color: Colors.white),
            VerticalDivider(),
            buildCell("Action", color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget buildTableRow(int index) {
    final data = details![index];
    Color kOddRowColor = Colors.white;
    Color kEvenRowColor = Color.fromARGB(255, 231, 229, 229);
    Color rowColor = index % 2 == 0 ? kEvenRowColor : kOddRowColor;
    return Card(
      color: rowColor, // Apply the row color here
      child: Padding(
        padding: kRowPadding,
        child: Row(
          children: [
            buildCell('${index + 1}', textAlign: TextAlign.left),
            VerticalDivider(),
            buildCell(
              "${data['name']}",
              flex: 2,
            ),
            VerticalDivider(),
            buildCell(
              "${data['remarks']}",
              flex: 2,
            ),
            VerticalDivider(),
            buildActionCell(data),
          ],
        ),
      ),
    );
  }

  Widget buildCell(String text,
      {int flex = 1,
      TextAlign textAlign = TextAlign.center,
      Color color = Colors.black}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: textAlign,
        style:
            TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color),
      ),
    );
  }

  Widget buildActionCell(data) {
    // Define the action cell with an icon button
    return Expanded(
      child: IconButton(
        icon: Icon(
          Icons.arrow_circle_right_outlined,
          size: 30,
          color: Colors.blue,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ApiDetails(
                  idData: data['id']), // Assuming SaveView is defined elsewhere
            ),
          );
        },
      ),
    );
  }
}
