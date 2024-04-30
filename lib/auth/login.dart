import '../index.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController uuid = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  bool acceptedTerms = false;
  final customForm = CustomForm();
  final validator = Validator();
  var sel_user_role;
  // var user_role = [
  //   {"opt_id": "200", "opt_name": "Nodal Officer"},
  //   {"opt_id": "300", "opt_name": "Sveep User"},
  //   {"opt_id": "100", "opt_name": "Admin"}
  // ];

  @override
  void initState() {
    super.initState();

    // if (user_role.isNotEmpty) {
    //   sel_user_role = user_role.first['opt_id'].toString();
    // }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
        bottomNavigationBar: nicBottomBar(),
        body: SingleChildScrollView(
            child: Column(children: [
          Stack(
            children: [
              Container(
                color: Colors.white,
                width: width,
                height: height * 0.4,
              ),
              Container(
                width: width,
                height: height * 0.06,
                margin: EdgeInsets.only(top: height * 0.35),
                color: Color(0xff112948),
              ),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: width,
                      height: height * 0.07,
                      color: Color(0xff112948),
                    ),
                    Container(
                        child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: width * 0.2),
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'lib/assets/ashok.png',
                                  scale: 6,
                                )),
                            Container(
                              alignment: Alignment.center,
                              child: Image.asset(
                                'lib/assets/sesa.png',
                                scale: 2.75,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Election Cell Requirement System",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color(0xff112948),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                    SizedBox(height: height * 0.01),
                  ],
                ),
              ),
            ],
          ),
          Container(
              margin: EdgeInsets.only(
                top: height * 0.01,
                left: width * 0.06,
                right: width * 0.06,
              ),
              padding: EdgeInsets.all(20),
              child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Welcome",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        "Please Login to your Account",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color(0xff112948),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: height * 0.02),
                      customForm.textFormField(
                        field_name: "Phone",
                        controller: uuid,
                        maxLength: 10,
                        keyboardType: TextInputType.phone,
                        customValidator: validator.validatePhone,
                      ),
                      SizedBox(height: height * 0.01),
                      customForm.textFormField(
                        field_name: "Password",
                        customValidator: validator.validatePassword,
                        controller: password,
                        isPassword:
                            true, // Indicate this field is for password input
                        isPasswordVisible:
                            isPasswordVisible, // Use the visibility state
                        togglePasswordVisibility: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        keyboardType: TextInputType
                            .visiblePassword, // Set keyboard type for passwords
                      ),
                      Container(
                        margin: EdgeInsets.only(left: width * 0.01),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: acceptedTerms,
                              onChanged: (bool? value) {
                                setState(() {
                                  acceptedTerms = value!;
                                });
                              },
                            ),
                            Text(
                              "I Agree to ",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Terms and Conditions'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            Text(
                                              'Terms of Use\n\n'
                                              'These terms of use govern your use of Election Cell Requirement System. Please read these terms and conditions (Terms) carefully before you use the Election Cell Requirement System platform and its services. By clicking on the "I Agree" button, you signify your acceptance of the Terms and your agreement to be bound by them. The Terms may be amended from time to time. In order to continue using the Election Cell Requirement System Platform, you will be required to read and accept the revised Terms.\n\n'
                                              'Though all efforts have been made to ensure the accuracy of the content on Election Cell Requirement System, the same should not be construed as a statement of law or used for any legal purposes. In case of any ambiguity or doubts, users are advised to verify/check with the concerned Ministry/Department/Organization and/or other source(s), and to obtain appropriate professional advice.\n\n'
                                              'Under no circumstances will the Government Ministry/Department/Organization be liable for any expense, loss or damage including, without limitation, indirect or consequential loss or damage, or any expense, loss or damage whatsoever arising from use, or loss of use, of data, arising out of or in connection with the use of Election Cell Requirement System.\n\n'
                                              'The service offered by Election Cell Requirement System is for your personal use only and not for commercial exploitation. You may not decompile, reverse engineer, disassemble, rent, lease, loan, sell, sublicense, or create derivative works from Election Cell Requirement System. Nor may you use any network monitoring or discovery software to determine the Application/site architecture, or extract information about usage, individual identities or users.\n\n'
                                              'Privacy Policy\n\n'
                                              'Please read this privacy policy before using Election Cell Requirement System. By using the mobile application or submitting the information on the mobile application, you agree that you are of the age of 18 years or above and you specifically consent to the use and transmission/transfer/sharing of your entered data or information according to the privacy policy. You shall be at liberty at any time to discontinue the use / transfer / transmission and sharing of any of your personal data or information, by writing to us and informing us of the same.',
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Close'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text(
                                "terms of use",
                                style: TextStyle(
                                  fontSize: 16,
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Center(
                          child: CustomElevatedButton(
                            color: Color(0xff02306b),
                            buttonText: 'Login',
                            height: 6.5,
                            width: 30,
                            onPressed: () {
                              if (!acceptedTerms) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Terms and Conditions'),
                                      content: Text(
                                          'Please accept the terms and conditions to proceed.'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                ApiControllerMain()
                                    .login(uuid.text.toString(),
                                        password.text.toString(), context)
                                    .then((result) {
                                  if (result.item1) {
                                    var statusCode =
                                        result.item2!["role"].toString();
                                    var token = result.item2!["token"];
                                    var name = result.item2!["name"];
                                    var cell_name = result.item2!["cell_name"];
                                    Support.instance.then((support) {
                                      support.setString(
                                          "uuid", uuid.text.toString());
                                      support.setBool("justLoggedIn", true);
                                      support.setString(
                                          "statusCode", statusCode);
                                      support.setString('token', token);
                                      support.setString(
                                          'name', name.toString());
                                      support.setString(
                                          'cell_name', cell_name.toString());
                                    });
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Middleware(),
                                      ),
                                    );
                                  }
                                });
                              }
                            },
                            radius: 8,
                            textFontSize: 18,
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: height * 0.075),
                          child: Text(
                            "District Election Office, Bijni",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  )))
        ])));
  }
}
