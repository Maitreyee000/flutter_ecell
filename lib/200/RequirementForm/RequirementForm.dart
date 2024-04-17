import 'package:cell_req/200/RequirementForm/RequirementFormHome.dart';
import '../Helper/index.dart';

class RequirementForm extends StatefulWidget {
  const RequirementForm({super.key});

  @override
  State<RequirementForm> createState() => _RequirementFormState();
}

class _RequirementFormState extends State<RequirementForm> {
  final customForm = CustomForm();

  final item_name = TextEditingController();
  final qty = TextEditingController();
  final apiController = ApiController();
  final validator = Validator();
  final _formKey = GlobalKey<FormState>();
  var data;
  var sel_cell;

  bool? isLoading;

  var dropdown_cell;
  List<Map<String, TextEditingController>> itemQuantities = [
    {
      "item_name": TextEditingController(),
      "quantity": TextEditingController(),
    },
  ];

  Map<String, dynamic> req = {
    "cell_name_id": null,
    "cell_req": [],
  };
  Future<void> loadInitialData() async {
    EasyLoading.show(status: "Loading...");
    var support = await Support.init();
    String? uuid = await support.getString('uuid');
    var data = {"phone": uuid.toString()};
    dropdown_cell =
        await apiController.getDataListById(context, "cell_list", data);

    setState(() {
      isLoading = false;
    });
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
        bottomNavigationBar: nicBottomBar(),
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Container(
            child: Text(
              "Requirement Form",
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
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                height: height * 0.05,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100)),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Header(
                        headerTitle: "Cell Name",
                        color: Color.fromARGB(255, 63, 81, 181),
                        radius: 10,
                        textFontSize: 18,
                        textWeight: FontWeight.bold,
                      ),
                      customForm!.dropDown(
                        "  Select Cell",
                        "Select",
                        (value) {
                          sel_cell = value;
                          onCellSelected(sel_cell);
                          setState(() {});
                        },
                        width: width * 0.81,
                        mappedData: dropdown_cell,
                        initialValue: sel_cell,
                      ),
                      Header(
                        headerTitle: "Requirements Page",
                        color: Color.fromARGB(255, 63, 81, 181),
                        radius: 10,
                        textFontSize: 18,
                        textWeight: FontWeight.bold,
                      ),
                      Column(
                        children: [
                          for (int i = 0; i < itemQuantities.length; i++)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                          'Item ${i + 1}'), // Displaying the item number
                                      customForm.textFormField(
                                        custWidth: 0.65,
                                        field_name: "Item Name",
                                        controller: itemQuantities[i]
                                            ["item_name"]!,
                                        keyboardType: TextInputType.text,
                                        customValidator: validator.validateText,
                                      ),
                                      customForm.textFormField(
                                        custWidth: 0.65,
                                        field_name: "Quantity",
                                        controller: itemQuantities[i]
                                            ["quantity"]!,
                                        keyboardType: TextInputType.number,
                                        customValidator:
                                            validator.validateWholeNumber,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.remove_circle_outline,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => removeItem(i),
                                )
                              ],
                            ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: CustomElevatedButton(
                              color: Color.fromARGB(255, 35, 110, 37),
                              buttonText: 'Upload',
                              height: 5,
                              width: 35,
                              onPressed: () async {
                                List<Map<String, dynamic>> cellReqs =
                                    itemQuantities.map((itemQuantity) {
                                  return {
                                    "item_name":
                                        itemQuantity["item_name"]!.text,
                                    "quantity": itemQuantity["quantity"]!.text,
                                  };
                                }).toList();

                                setState(() {
                                  req["cell_req"] = cellReqs;
                                });

                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  var support = await Support.init();
                                  String? uuid =
                                      await support.getString('uuid');
                                  var data = {
                                    "dynamic_data": req,
                                    "phone": uuid.toString(),
                                  };

                                  if (await apiController.uploadData(data,
                                      "cell_requirement_request", context)) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RequirementFormHome()));
                                  }
                                }
                              },
                              radius: 8,
                              textFontSize: 16,
                            ),
                          ),
                          Container(
                            child: CustomElevatedButton(
                              color: Color(0xff02306b),
                              buttonText: 'Add ',
                              height: 5,
                              width: 35,
                              onPressed: () async {
                                setState(() {
                                  itemQuantities.add({
                                    "item_name": TextEditingController(),
                                    "quantity": TextEditingController(),
                                  });
                                });
                              },
                              radius: 8,
                              textFontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ])));
  }

  void removeItem(int index) {
    setState(() {
      if (itemQuantities.length > 1) {
        // Prevent removing all items, ensure at least one remains
        itemQuantities.removeAt(index);
      } else {
        // Optional: Show a message that at least one item is required
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("At least one item is required."),
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void onCellSelected(String value) {
    setState(() {
      sel_cell = value;

      itemQuantities = [
        {
          "item_name": TextEditingController(),
          "quantity": TextEditingController(),
        }
      ];

      req["cell_name_id"] = value;

      req["cell_req"] = [];
    });
  }
}

Widget nicBottomBar() {
  return Container(
    child: Image.asset(
      'lib/assets/bottomLogo.png',
    ),
  );
}
