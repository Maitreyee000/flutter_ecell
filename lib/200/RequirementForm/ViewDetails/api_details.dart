import 'package:cell_req/200/RequirementForm/RequirementFormHome.dart';
import 'package:cell_req/200/RequirementForm/ViewList/api_data_list.dart';

import 'package:cell_req/200/Helper/index.dart';
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
  final ac = TextEditingController();
  final designation = TextEditingController();
  final email = TextEditingController();
  final is_active = TextEditingController();
  final password = TextEditingController();
  var role_id;

  var sel_place_name;
  var sel_user_role;
  String? statusCode;
  bool isPasswordVisible = false; // Initially password is not visible
  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  CustomForm customForm = CustomForm();
  var place_name = [
    {"opt_id": "19", "opt_name": "Sidli Chirang"},
    {"opt_id": "20", "opt_name": "Bijni"}
  ];
  Future<void> loadInitialData() async {
    var support = await Support.instance;
    statusCode = await support.getString('statusCode');
    print(statusCode);

    var id = {"id": widget.idData.toString()};

    var response =
        await apiController.getDataMapById(context, "getUserById", id);
    data = response;

    name.text = data!['name'].toString();
    phone.text = data!['phone'].toString();
    designation.text = data!['designation'].toString();
    email.text = data!['email'].toString();

    sel_user_role = data!['role_id'].toString();
    if (data['ac'].toString() != "null") {
      sel_place_name = data['ac'].toString();
    }
    setState(() {
      isLoading = false;
    });
  }

  var user_role = [
    {"opt_id": "200", "opt_name": "User"},
    {"opt_id": "100", "opt_name": "Admin"}
  ];

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
                MaterialPageRoute(builder: (context) => RequirementFormHome()),
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
                          customForm.textFormField(
                            field_name: "Name",
                            controller: name,
                            customValidator: validator.validateText,
                            keyboardType: TextInputType.text,
                          ),
                          customForm.textFormField(
                            maxLength: 10,
                            field_name: "Phone",
                            controller: phone,
                            customValidator: validator.validatePhone,
                            keyboardType: TextInputType.phone,
                          ),
                          customForm.textFormField(
                            field_name: "Designation",
                            controller: designation,
                            keyboardType: TextInputType.text,
                            customValidator: validator.validateText,
                          ),
                          if (statusCode == "100")
                            customForm!.dropDown("  Select User Type", "Select",
                                (value) {
                              sel_user_role = value;
                              sel_place_name = null;
                              setState(() {});
                            },
                                width: width * 0.81,
                                mappedData: user_role,
                                initialValue: sel_user_role),
                          if (sel_user_role != "100")
                            customForm!.dropDown(
                              "  Select Assembly Constituency",
                              "Select",
                              (value) {
                                sel_place_name = value;
                                setState(() {});
                              },
                              width: width * 0.81,
                              mappedData: place_name,
                              initialValue: sel_place_name,
                            ),
                          customForm.textFormField(
                              field_name: "Email",
                              controller: email,
                              keyboardType: TextInputType.text,
                              customValidator: validator.validateEmail),
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
                                  var support = await Support.instance;
                                  String? uuid =
                                      await support.getString('uuid');
                                  formData = {
                                    "id": widget.idData.toString(),
                                    "name": name.text.trim().toString(),
                                    "phone": phone.text.trim().toString(),
                                    "designation":
                                        designation.text.trim().toString(),
                                    "ac": sel_place_name.toString(),
                                    "email": email.text.trim().toString(),
                                    "role_id": sel_user_role.toString(),
                                    "password": password.text.trim().toString(),
                                    "is_active": data['is_active'].toString(),
                                  };

                                  if (await apiController.uploadData(
                                      formData, "updateUser", context)) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ApiDataList()),
                                    );
                                    ;
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
