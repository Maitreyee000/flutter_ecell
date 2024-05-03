import './Helper/index.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final customForm = CustomForm();
  final validator = Validator();
  final name = TextEditingController();
  final phone = TextEditingController();
  final designation = TextEditingController();
  final password = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var user_name;
  var uuid;
  var response;
  bool isPasswordVisible = false; // Initially password is not visible
  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  final apiController = ApiController();

  Future<void> loadData() async {
    var support = await Support.init();
    user_name = await support.getString('name');
    // uuid = await support.getString('uuid');
    // var payload = {"phone": uuid.toString()};
    var payload = {"phone": ""};
    EasyLoading.show(status: "Loading...");
    var data =
        await apiController.getDataMapById(context, "get_admin_data", payload);
    setState(() {
      name.text = data!['name'].toString();
      // phone.text = data!['phone'].toString();
    });
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: nicBottomBar(),
      appBar: AppBar(
        title: Container(
          margin: EdgeInsets.only(left: width * 0.2),
          child: Text(
            "PROFILE",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Color(0xff112948),
        leading: IconButton(
          color: Colors.white,
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Home()));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: width,
              height: height * 0.35,
              decoration: BoxDecoration(
                color: Color(0xff112948),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 60,
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Text(
                    "USER ID $user_name",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  // ElevatedButton(
                  //   style: ButtonStyle(
                  //     backgroundColor: MaterialStateProperty.all(
                  //       Color(0xff112948),
                  //     ),
                  //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  //       RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10.0),
                  //         side: BorderSide(
                  //             width: 3,
                  //             color: Colors.white), // Outline color set here
                  //       ),
                  //     ),
                  //   ),
                  //   onPressed:
                  //       null, // Replace null with your function for the button action
                  //   child: Text(
                  //     "LOG-OUT",
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    customForm.textFormField(
                        field_name: "Name",
                        controller: name,
                        customValidator: validator.validateText),
                    customForm.textFormField(
                        maxLength: 10,
                        field_name: "Phone (Login ID)",
                        controller: phone,
                        customValidator: validator.validatePhone),
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
                        customValidator: validator.validatePassword),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: CustomElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              Map<String, dynamic> formData = {};
                              var support = await Support.init();
                              // String? uuid = await support.getString('uuid');
                              String? user_name =
                                  await support.getString('name');
                              formData = {
                                "name": name.text.trim().toString(),
                                "new_number": phone.text.trim().toString(),
                                // "old_number": uuid!.trim().toString(),
                                "password": password.text.trim().toString(),
                                "iv": "",
                              };
                              if (await apiController.uploadData(
                                  formData, "admin_update", context)) {
                                Logout.logoutFun();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('User Updated'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Session Expied'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()),
                                );
                              }
                            }
                          },
                          color: Colors.green,
                          height: 5,
                          width: 25,
                          radius: 10,
                          buttonText: "Update"),
                    )
                  ],
                ),
              ),
            )
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
}
