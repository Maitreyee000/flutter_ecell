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
                                scale: 2.4,
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
                      Container(
                        child: Center(
                          child: CustomElevatedButton(
                            color: Color(0xff02306b),
                            buttonText: 'Login',
                            height: 6.5,
                            width: 30,
                            onPressed: () {
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
