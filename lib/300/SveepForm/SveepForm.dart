import '../Helper/index.dart';

class SveepForm extends StatefulWidget {
  const SveepForm({super.key});

  @override
  State<SveepForm> createState() => _SveepFormState();
}

class _SveepFormState extends State<SveepForm> {
  final customForm = CustomForm();

  final name = TextEditingController();
  final c_no = TextEditingController();
  final remark = TextEditingController();
  final apiController = ApiController();
  final validator = Validator();
  final _formKey = GlobalKey<FormState>();
  double? lat;
  double? long;
  dynamic image;
  bool isImageSelected = false;

  Future<void> requestPermissions() async {
    var status = await Permission.location.request();

    if (status == PermissionStatus.granted) {
    } else if (status == PermissionStatus.denied) {
    } else if (status == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermissions();
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
              "Sveep Form ",
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
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Stack(children: [
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
              height: height * 0.05,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100)),
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  Header(
                    headerTitle: "Sveep info",
                    color: Color.fromARGB(255, 63, 81, 181),
                    radius: 10,
                    textFontSize: 18,
                    textWeight: FontWeight.bold,
                  ),
                  customForm.textFormField(
                    field_name: "Name",
                    controller: name,
                    keyboardType: TextInputType.text,
                    customValidator: validator.validateAlphaNum,
                  ),
                  // customForm.textFormField(
                  //   field_name: "Contact No.",
                  //   maxLength: 10,
                  //   controller: c_no,
                  //   keyboardType: TextInputType.phone,
                  //   customValidator: validator.validatePhone,
                  // ),
                  customForm.tableSection(children: [
                    customForm.imageField(
                      field_name: "Photo",
                      onLocationSelected: (double latitude, double longitude,
                          String? imagePath) {
                        setState(() {
                          lat = latitude;
                          long = longitude;
                          image = imagePath;
                          isImageSelected = imagePath != null;
                        });
                      },
                    ),
                    if (lat != null)
                      CustomForm().textField(
                        field_name: 'Latitude',
                        field_val: "${lat}",
                      ),
                    if (long != null)
                      CustomForm().textField(
                        field_name: 'Longitude',
                        field_val: "${long}",
                      ),
                  ]),
                  customForm.textFormField(
                    field_name: "Remark",
                    controller: remark,
                    keyboardType: TextInputType.text,
                    customValidator: validator.validateAlphaNum,
                  ),
                  CustomElevatedButton(
                    onPressed: () async {
                      if (!isImageSelected) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Please select an image before submitting.')),
                        );
                        return;
                      }
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        var support = await Support.init();
                        // String? uuid = await support.getString('uuid');

                        // Assuming imagePath is available here and it's a String
                        String imagePath =
                            image; // Make sure 'image' is the path to your image
                        final bytes = await File(imagePath).readAsBytes();
                        String base64Image = base64Encode(bytes);

                        var data = {
                          "name": name.text.toString(),
                          // "contact_no": c_no.text.toString(),
                          "latitude": lat.toString(),
                          "longitude": long
                              .toString(), // Make sure to use 'long' for longitude
                          "remarks": remark.text.toString(),

                          "photo":
                              base64Image, // Add the base64 image string here
                        };

                        bool result = await apiController.uploadData(
                            data, "createSveepDetail", context);
                        if (result) {
                          Navigator.pop(context);
                          _formKey.currentState!.reset();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Something went wrong'),
                              duration: Duration(
                                  seconds: 3), // Adjust duration as needed
                              action: SnackBarAction(
                                label: 'Dismiss',
                                onPressed: () {},
                              ),
                            ),
                          );
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
              ),
            )
          ])
        ])));
  }
}

Widget nicBottomBar() {
  return Container(
    child: Image.asset(
      'lib/assets/bottomLogo.png',
    ),
  );
}
