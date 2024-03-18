import '../300/Helper/index.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final customForm = CustomForm();
  final User_ID = TextEditingController();
  final User_Name = TextEditingController();
  final Designation = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    User_ID.text = "Admin123";
    User_Name.text = "Prithwish";
    Designation.text = "Director";
    setState(() {});
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
            // Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (context) => Home()));
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
                    "USER ID Admin123",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Color(0xff112948),
                      ),
                      // Define the shape and outline
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                              width: 3,
                              color: Colors.white), // Outline color set here
                        ),
                      ),
                    ),
                    onPressed:
                        null, // Replace null with your function for the button action
                    child: Text(
                      "LOG-OUT",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              child: Column(
                children: [
                  customForm.textFormField(
                    readOnly: true,
                    field_name: "User ID",
                    controller: User_ID,
                    // customValidator: validator.validateText
                  ),
                  customForm.textFormField(
                    readOnly: true,
                    field_name: "User Name",
                    controller: User_Name,
                    // customValidator: validator.validateText
                  ),
                  customForm.textFormField(
                    readOnly: true,
                    field_name: "Designation",
                    controller: Designation,
                    // customValidator: validator.validateText
                  ),
                  SizedBox(
                    width: width * 0.8,
                    height: height * 0.066,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.white,
                        ),
                        // Define the shape and outline
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                                width: 1,
                                color: Colors.black), // Outline color set here
                          ),
                        ),
                      ),
                      onPressed:
                          null, // Replace null with your function for the button action
                      child: Text(
                        "Change Password",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
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
