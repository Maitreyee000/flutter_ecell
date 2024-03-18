import 'package:cell_req/100/CellForm/CellFormHome.dart';
import 'package:cell_req/100/CellForm/ViewList/api_data_list.dart';

import '../../Helper/index.dart';
import 'package:http/http.dart' as http;

class ApiDetails extends StatefulWidget {
  const ApiDetails({super.key, this.idData});
  final idData;

  @override
  State<ApiDetails> createState() => _ApiDetailsState();
}

class _ApiDetailsState extends State<ApiDetails> {
  Map<String, dynamic>? user_details;
  var data;
  final validator = Validator();
  final apiController = ApiController();
  final cell_id = TextEditingController();
  final cell_name = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  CustomForm customForm = CustomForm();

  bool isPasswordVisible = false;

  Future<void> loadInitialData() async {
    var id = {"cell_id": widget.idData.toString()};

    var response =
        await apiController.getDataMapById(context, "get_cell_details", id);
    data = response;

    cell_id.text = data!['cell_id'].toString();
    cell_name.text = data!['cell_name'].toString();
    setState(() {});
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
        appBar: AppBar(
          title: Container(
            child: Text(
              "View Details",
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ApiDataList()),
              );
            },
          ),
        ),
        body: data == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Container(
                    alignment: Alignment.center,
                    child: Form(
                      key: _formKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Header(
                              headerTitle: "Cell Info",
                              color: Color.fromARGB(255, 63, 81, 181),
                              radius: 10,
                              textFontSize: 18,
                              textWeight: FontWeight.bold,
                            ),
                            customForm.textFormField(
                              readOnly: false,
                              field_name: "Cell id",
                              controller: cell_id,
                              customValidator: validator.validateWholeNumber,
                              keyboardType: TextInputType.number,
                            ),
                            customForm.textFormField(
                              readOnly: false,
                              field_name: "Cell Name",
                              controller: cell_name,
                              customValidator: validator.validateText,
                              keyboardType: TextInputType.text,
                            ),
                            CustomForm().tableSection(children: [
                              customForm.radioButtonFieldGroup(
                                fieldName: 'Is Active',
                                options: ['false', 'true'],
                                groupValue: data['is_active'].toString() ??
                                    'null', // <-- Pass dynamic value here
                                onRadioChanged: (value) {
                                  data['is_active'] = value;
                                  setState(() {});
                                },
                              ),
                            ]),
                            CustomElevatedButton(
                              color: Color.fromARGB(255, 35, 110, 37),
                              buttonText: 'Update',
                              height: 5,
                              width: 35,
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  var support = await Support.instance;
                                  String? uuid =
                                      await support.getString('uuid');
                                  var payload = {
                                    "id": widget.idData.toString(),
                                    "cell_id": cell_id.text.toString(),
                                    "cell_name": cell_name.text.toString(),
                                    "is_active": data['is_active'].toString(),
                                    "updated_by": uuid.toString(),
                                  };
                                  if (await apiController.uploadData(
                                      payload, "update_cell", context)) {
                                    Navigator.pop(context);
                                    _formKey.currentState!.reset();
                                    cell_id.clear();
                                    cell_name.clear();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CellFormHome()));
                                  }
                                }
                              },
                              radius: 8,
                              textFontSize: 16,
                            ),
                          ]),
                    ))));
  }
}
