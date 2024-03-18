import '../Helper/index.dart';

class ApiListDispose extends StatefulWidget {
  const ApiListDispose({super.key, this.idData});
  final idData;

  @override
  State<ApiListDispose> createState() => _ApiListDisposeState();
}

class _ApiListDisposeState extends State<ApiListDispose> {
  Map<String, dynamic>? user_details;
  var data;
  final validator = Validator();
  final apiController = ApiController();
  bool isLoading = true;
  var details;
  EdgeInsetsGeometry kRowPadding =
      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0);
  CustomForm customForm = CustomForm();

  Future<void> loadInitialData(data) async {
    Map<String, dynamic> payload = jsonDecode(data);
    details = await apiController.getDataListById(
        context, "view_dispose_list", payload);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadInitialData(widget.idData);
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
                "Data List",
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

    return Scaffold(
      bottomNavigationBar: nicBottomBar(),
      appBar: AppBar(
        title: Container(
          child: Text(
            "Data List",
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
            buildCell("Quantity", flex: 1, color: Colors.white),
            VerticalDivider(),
            buildCell("Req. To", flex: 2, color: Colors.white),
            VerticalDivider(),
            buildCell("Req. By", flex: 2, color: Colors.white),
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
              "${data['item_name']}",
              flex: 2,
            ),
            VerticalDivider(),
            buildCell(
              "${data['quantity']}",
              flex: 1,
            ),
            VerticalDivider(),
            buildCell(
              "${data['requested_to_cell_name']}",
              flex: 2,
            ),
            VerticalDivider(),
            buildCell(
              "${data['requested_by_cell_name']}",
              flex: 2,
            ),
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
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ApiDetails(
          //         idData: data['id']), // Assuming SaveView is defined elsewhere
          //   ),
          // );
        },
      ),
    );
  }
}
