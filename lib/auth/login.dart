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
  final customForm = CustomForm(); //defined in widgets.dart
  final validator = Validator();
  var sel_user_role;
  var user_role = [
    {"opt_id": "200", "opt_name": "Nodal Officer"},
    {"opt_id": "300", "opt_name": "Sveep User"},
    {"opt_id": "100", "opt_name": "Admin"}
  ];

  @override
  void initState() {
    super.initState();

    if (user_role.isNotEmpty) {
      sel_user_role = user_role.first['opt_id'].toString();
    }
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
                color: Color(0xff112948),
                width: width,
                height: height * 0.3,
              ),
              SizedBox(
                child: Transform.rotate(
                  angle: 3.14159 / 4, // Rotating 45 degrees
                  child: Container(
                    margin:
                        EdgeInsets.only(top: height * 0.22, left: width * 0.37),
                    color: Color(0xff112948),
                    width: width * 0.1,
                    height: height * 0.07,
                  ),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: height * 0.05),
                        child: Image.asset(
                          'lib/assets/ashok.png',
                          scale: 7,
                        )),
                    SizedBox(height: height * 0.01),
                    Text(
                      "Cell Requirement System",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold),
                    ),
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
                      Text(
                        "Welcome",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
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
                      customForm!.dropDown(
                        //what is custom form doing though?
                        "  Select User Type",
                        "Select",
                        (value) {
                          sel_user_role = value;
                          setState(() {});
                        },
                        width: width * 0.9,
                        mappedData: user_role,
                        initialValue: sel_user_role,
                      ),
                      SizedBox(height: height * 0.01),
                      if (sel_user_role == "100") ...[
                        customForm.textFormField(
                          field_name: "Phone",
                          controller: uuid,
                          maxLength: 10,
                          keyboardType: TextInputType.phone,
                          customValidator: validator.validatePhone,
                        ),
                      ],
                      if (sel_user_role == "200") ...[
                        customForm.textFormField(
                          field_name: "Phone",
                          controller: uuid,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          customValidator: validator.validatePhone,
                        ),
                      ],
                      if (sel_user_role == "300") ...[
                        customForm.textFormField(
                          field_name: "Phone",
                          controller: uuid,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          customValidator: validator.validatePhone,
                        ),
                      ],
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
                        child: Center(
                          child: CustomElevatedButton(
                            color: Color(0xff02306b),
                            buttonText: 'Login',
                            height: 6.5,
                            width: 30,
                            onPressed: () {
                              ApiControllerMain()
                                  .login(
                                      uuid.text.toString(),
                                      password.text.toString(),
                                      sel_user_role.toString(),
                                      context)
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
                                    support.setString("statusCode", statusCode);
                                    support.setString('token', token);
                                    support.setString('name', name.toString());
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
