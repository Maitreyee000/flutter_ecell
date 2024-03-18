import 'package:cell_req/200/RequirementForm/RequirementFormHome.dart';

import 'package:cell_req/200/Helper/index.dart';

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
    var support = await Support.instance;
    var uuid = await support.getString("uuid");
    var data = {"phone": uuid.toString()};

    details = await apiController.getDataListById(
        context, "get_all_requirements", data);

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
                "Cell Request",
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => RequirementFormHome(),
                  ),
                );
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
            "Cell Request",
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
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => Home(),
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: details == null || details!.isEmpty
            ? Center(
                child: Text(
                  "No Data Avalable",
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
            buildCell("Item Name", flex: 2, color: Colors.white),
            VerticalDivider(),
            buildCell("Qty.", flex: 1, color: Colors.white),
            VerticalDivider(),
            buildCell("Requested By", flex: 2, color: Colors.white),
            VerticalDivider(),
            buildCell("Dispose", color: Colors.white, flex: 2),
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
            buildCell("${data['item_name']}", flex: 2),
            VerticalDivider(),
            buildCell(
              "${data['quantity']}",
              flex: 2,
            ),
            VerticalDivider(),
            buildCell(
              "${data['requested_by']}",
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
      flex: 2,
      child: IconButton(
        icon: Icon(
          Icons.delete,
          size: 30,
          color: Colors.blue,
        ),
        onPressed: () async {
          data = {"id": data['id'].toString()};
          if (await ApiController().uploadData(data, "dispose", context)) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => ApiDataList(),
              ),
            );
          }
        },
      ),
    );
  }
}
