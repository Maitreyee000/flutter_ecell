import '../index.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController uuid = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>(); //whats this
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
                          "Cell Requirement System",
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
                  key: _formKey, //where is form key defined exactly
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Terms and Conditions'),
                                    content: const SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text('1. Introduction\n\n'
                                              'Welcome to our application. By accessing or using our application, you agree to be bound by these terms and conditions. If you do not agree with any part of these terms, you are prohibited from using or accessing this application.\n\n'
                                              '2. Intellectual Property Rights\n\n'
                                              'Under these Terms, [Your Company Name] and/or its licensors own all the intellectual property rights and materials contained in this application. You are granted a limited license only for purposes of viewing the material contained on this application.\n\n'
                                              '3. Restrictions\n\n'
                                              'You are specifically restricted from all of the following:\n'
                                              '- publishing any application material in any other media;\n'
                                              '- selling, sublicensing, and/or otherwise commercializing any application material;\n'
                                              '- publicly performing and/or showing any application material;\n'
                                              '- using this application in any way that is or may be damaging to this application;\n'
                                              '- using this application in any way that impacts user access to this application;\n'
                                              '- using this application contrary to applicable laws and regulations, or in a way that causes, or may cause, harm to the application, or to any person or business entity;\n'
                                              '- engaging in any data mining, data harvesting, data extracting, or any other similar activity in relation to this application, or while using this application.\n\n'
                                              '4. Your Content\n\n'
                                              'In these terms and conditions, "Your Content" shall mean any audio, video, text, images, or other material you choose to display on this application. By displaying Your Content, you grant [Your Company Name] a non-exclusive, worldwide, irrevocable, sublicensable license to use, reproduce, adapt, publish, translate, and distribute it in any and all media.\n\n'
                                              'Your Content must be your own and must not be infringing on any third party\'s rights. [Your Company Name] reserves the right to remove any of Your Content from this application at any time, and for any reason, without notice.\n\n'
                                              '5. No warranties\n\n'
                                              'This application is provided "as is," with all faults, and [Your Company Name] makes no express or implied representations or warranties, of any kind related to this application or the materials contained on this application. Also, nothing contained on this application shall be interpreted as advising you.\n\n'
                                              '6. Limitation of liability\n\n'
                                              'In no event shall [Your Company Name], nor any of its officers, directors, and employees, be held liable for anything arising out of or in any way connected with your use of this application whether such liability is under contract, tort or otherwise, and [Your Company Name], including its officers, directors, and employees shall not be liable for any indirect, consequential, or special liability arising out of or in any way related to your use of this application.\n\n'
                                              '7. Indemnification\n\n'
                                              'You hereby indemnify to the fullest extent [Your Company Name] from and against any and/or all liabilities, costs, demands, causes of action, damages, and expenses arising in any way related to your breach of any of the provisions of these terms.\n\n'
                                              '8. Severability\n\n'
                                              'If any provision of these terms is found to be invalid under any applicable law, such provisions shall be deleted without affecting the remaining provisions herein.\n\n'
                                              '9. Variation of Terms\n\n'
                                              '[Your Company Name] is permitted to revise these terms at any time as it sees fit, and by using this application you are expected to review such terms on a regular basis to ensure you understand all terms and conditions governing use of this application.\n\n'
                                              '10. Assignment\n\n'
                                              '[Your Company Name] is allowed to assign, transfer, and subcontract its rights and/or obligations under these terms without any notification or consent required. However, you are not allowed to assign, transfer, or subcontract any of your rights and/or obligations under these terms.\n\n'
                                              '11. Entire Agreement\n\n'
                                              'These terms constitute the entire agreement between [Your Company Name] and you in relation to your use of this application, and supersede all prior agreements and understandings.\n\n')
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
                              "Read and Accept Terms & Conditions",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          Checkbox(
                            value: acceptedTerms,
                            onChanged: (bool? value) {
                              setState(() {
                                acceptedTerms = value!;
                              });
                            },
                          ),
                        ],
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
                    ],
                  )))
        ])));
  }
}
