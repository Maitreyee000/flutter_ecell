import 'package:cell_req/100/SveepForm/SveepFormHome.dart';
import '../Helper/index.dart';

class SveepForm extends StatefulWidget {
  const SveepForm({super.key});

  @override
  State<SveepForm> createState() => _SveepFormState();
}

class _SveepFormState extends State<SveepForm> {
  final customForm = CustomForm();
  final validator = Validator();
  final apiController = ApiController();
  final _formKey = GlobalKey<FormState>();
  final p_no = TextEditingController();
  final name = TextEditingController();
  final password = TextEditingController();
  bool isPasswordVisible = false;
  var sel_cell_name;
  List<dynamic>? dropdown_cell_name;

  Future<void> loadDataAndInitialize() async {
    EasyLoading.show(status: "Loading...");
    var support = await Support.init();
    // String? uuid = await support.getString('uuid');
    var data = {"phone": ""};

    setState(() {});
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    super.initState();

    loadDataAndInitialize();
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
              "Registration Form",
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
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
            customForm.textFormField(
              field_name: "Name",
              controller: name,
              keyboardType: TextInputType.text,
              customValidator: validator.validateText,
            ),
            customForm.textFormField(
                maxLength: 10,
                field_name: "Login id (Phone Number)",
                controller: p_no,
                keyboardType: TextInputType.number,
                customValidator: validator.validatePhone),
            customForm.textFormField(
              field_name: "Password",
              customValidator: validator.validatePassword,
              controller: password,
              isPassword: true,
              isPasswordVisible: isPasswordVisible,
              togglePasswordVisibility: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
              keyboardType: TextInputType.visiblePassword,
            ),
            CustomElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  var support = await Support.init();
                  // String? uuid = await support.getString('uuid');
                  var data = {
                    "phone": p_no.text.toString(),
                    "name": name.text.toString(),
                    "password": password.text.toString(),
                    "role_id": "300",
                  };

                  if (await apiController.uploadData(
                      data, "register_sveep", context)) {
                    Alert(
                      context: context,
                      type: AlertType.success,
                      desc: "Data Saved",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "ok",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () {
                            _formKey.currentState!.reset();
                            p_no.clear();
                            name.clear();
                            password.clear();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SveepFormHome()));
                          },
                          width: 120,
                        )
                      ],
                    ).show();
                  }
                }
              },
              height: 5,
              width: 45,
              buttonText: 'Create',
              radius: 20,
              textFontSize: 16,
              color: Color.fromARGB(255, 82, 165, 85),
            )
          ]),
        )));
  }
}
