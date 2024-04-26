import 'package:cell_req/300/SveepForm/SveepFormHome.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
export 'package:flutter_pdfview/flutter_pdfview.dart';
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
  bool isLoading = true;
  final name = TextEditingController();
  final phone = TextEditingController();
  final long = TextEditingController();
  final lat = TextEditingController();
  final remarks = TextEditingController();

  CustomForm customForm = CustomForm();

  Future<void> loadInitialData() async {
    try {
      var support = await Support.init();
      var uuid = await support.getString('uuid');

      var payload = {
        "id": widget.idData.toString(),
        "phone": uuid.toString(),
      };

      var response = await apiController.getDataMapById(
          context, "get_all_data_by_id", payload);
      data = response;
      name.text = data!['name'].toString();
      phone.text = data!['contact_no'].toString();
      lat.text = data!['latitude'].toString();
      long.text = data!['longitude'].toString();
      remarks.text = data!['remarks'].toString();
    } catch (e) {
      // print(e);
    }

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
                MaterialPageRoute(builder: (context) => SveepFormHome()),
              );
            },
          ),
        ),
        body: data['photo'] == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Container(
                    alignment: Alignment.center,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Header(
                            headerTitle: "Details",
                            color: Color.fromARGB(255, 63, 81, 181),
                            radius: 10,
                            textFontSize: 18,
                            textWeight: FontWeight.bold,
                          ),
                          customForm.textFormField(
                            readOnly: true,
                            field_name: "Name",
                            controller: name,
                            customValidator: validator.validateText,
                            keyboardType: TextInputType.text,
                          ),
                          customForm.textFormField(
                            readOnly: true,
                            maxLength: 10,
                            field_name: "Phone",
                            controller: phone,
                            customValidator: validator.validatePhone,
                            keyboardType: TextInputType.phone,
                          ),
                          customForm.tableSection(children: [
                            customForm.tableRowFieldBase64(
                                fieldName: "Pdf",
                                base64Data: data['photo'],
                                context: context,
                                fileType: "pdf"),
                          ]),
                          customForm.textFormField(
                            readOnly: true,
                            field_name: "Longitude",
                            controller: long,
                            keyboardType: TextInputType.text,
                            customValidator: validator.validateText,
                          ),
                          customForm.textFormField(
                            readOnly: true,
                            field_name: "latitude",
                            controller: lat,
                            keyboardType: TextInputType.text,
                            customValidator: validator.validateText,
                          ),
                          customForm.textFormField(
                            readOnly: true,
                            field_name: "Remarks",
                            controller: remarks,
                            customValidator: validator.validateText,
                            keyboardType: TextInputType.text,
                          ),
                          // Container(
                          //   margin: EdgeInsets.all(10),
                          //   child: CustomElevatedButton(
                          //       onPressed: () async {
                          //         Map<String, dynamic> formData = {};
                          //         var support = await Support.init();
                          //         String? uuid =
                          //             await support.getString('uuid');
                          //         formData = {
                          //           "id": widget.idData.toString(),
                          //           "name": name.text.trim().toString(),
                          //           "phone": phone.text.trim().toString(),
                          //           "designation":
                          //               designation.text.trim().toString(),
                          //           "ac": sel_place_name.toString(),
                          //           "email": email.text.trim().toString(),
                          //           "role_id": sel_user_role.toString(),
                          //           "password": password.text.trim().toString(),
                          //           "is_active": data['is_active'].toString(),
                          //         };

                          //         if (await apiController.uploadData(
                          //             formData, "updateUser", context)) {
                          //           Navigator.push(
                          //             context,
                          //             MaterialPageRoute(
                          //                 builder: (context) => ApiDataList()),
                          //           );
                          //           ;
                          //         }
                          //       },
                          //       color: Colors.green,
                          //       height: 5,
                          //       width: 25,
                          //       radius: 10,
                          //       buttonText: "Update"),
                          // )
                        ]))));
  }

  Future<String> _saveFile(Uint8List bytes, String filename) async {
    Directory tempDir = await getTemporaryDirectory();
    String filePath = '${tempDir.path}/$filename';
    File file = File(filePath);
    await file.writeAsBytes(bytes);
    return filePath;
  }
}
