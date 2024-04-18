import 'package:cell_req/100/RegistrationForm/RegistrationFormHome.dart';
import 'package:cell_req/100/RegistrationForm/ViewList/api_data_list.dart';

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
  final password = TextEditingController();
  var dropdown_cell_name;
  var sel_cell_name;

  bool isPasswordVisible = false; // Initially password is not visible
  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  CustomForm customForm = CustomForm();

  Future<void> loadInitialData() async {
    var support = await Support.init();
    String? uuid = await support.getString('uuid');
    var id = {"id": widget.idData.toString()};
    var payload = {"phone": uuid.toString()};
    dropdown_cell_name = await apiController.getDataListById(
        context, "get_dropdown_cell_list", payload);

    var response =
        await apiController.getDataMapById(context, "get_user_data", id);
    data = response;

    name.text = data!['name'].toString();
    phone.text = data!['phone'].toString();
    sel_cell_name = data['cell_id'].toString();
    setState(() {
      isLoading = false;
    });
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
                MaterialPageRoute(builder: (context) => RegistrationFormHome()),
              );
            },
          ),
        ),
        body: data == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Container(
                    alignment: Alignment.center,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Header(
                            headerTitle: "User Info",
                            color: Color.fromARGB(255, 63, 81, 181),
                            radius: 10,
                            textFontSize: 18,
                            textWeight: FontWeight.bold,
                          ),
                          customForm!.dropDown(
                            "  Select Cell Name",
                            "Select",
                            (value) {
                              sel_cell_name = value;
                              setState(() {});
                            },
                            width: width * .8,
                            mappedData: dropdown_cell_name,
                            initialValue: sel_cell_name,
                          ),
                          customForm.textFormField(
                            field_name: "Name",
                            controller: name,
                            keyboardType: TextInputType.text,
                            customValidator: validator.validateText,
                          ),
                          customForm.textFormField(
                              maxLength: 10,
                              field_name: "Login id (Phone Number)",
                              controller: phone,
                              keyboardType: TextInputType.number,
                              customValidator: validator.validatePhone),
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
                          Header(
                            headerTitle: "Change Password",
                            color: Color.fromARGB(255, 63, 81, 181),
                            radius: 10,
                            textFontSize: 18,
                            textWeight: FontWeight.bold,
                          ),
                          customForm.textFormField(
                            isRequired: false,
                            field_name: "Change Password",
                            controller: password,
                            keyboardType: TextInputType.text,
                            isPassword: true,
                            isPasswordVisible:
                                isPasswordVisible, // Use the visibility state
                            togglePasswordVisibility: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: CustomElevatedButton(
                                onPressed: () async {
                                  Map<String, dynamic> formData = {};
                                  var support = await Support.init();
                                  String? uuid =
                                      await support.getString('uuid');
                                  formData = {
                                    "id": widget.idData.toString(),
                                    "name": name.text.trim().toString(),
                                    "cell_id": sel_cell_name.trim().toString(),
                                    "phone": phone.text.trim().toString(),
                                    "password": password.text.trim().toString(),
                                    "is_active": data['is_active'].toString(),
                                    "updated_by": uuid?.trim().toString(),
                                  };

                                  if (await apiController.uploadData(
                                      formData, "update_user", context)) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ApiDataList()),
                                    );
                                  }
                                },
                                color: Colors.green,
                                height: 5,
                                width: 25,
                                radius: 10,
                                buttonText: "Update"),
                          )
                        ]))));
  }
}
