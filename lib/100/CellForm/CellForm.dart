import 'package:cell_req/100/CellForm/CellFormHome.dart';
import '../Helper/index.dart';

class CellForm extends StatefulWidget {
  const CellForm({super.key});

  @override
  State<CellForm> createState() => _CellFormState();
}

class _CellFormState extends State<CellForm> {
  final customForm = CustomForm();

  final item_name = TextEditingController();
  final qty = TextEditingController();
  final apiController = ApiController();
  final validator = Validator();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final cell_no = TextEditingController();
  final cell_name = TextEditingController();

  bool? isLoading;

  @override
  void initState() {
    super.initState();
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
              "Cell Registration Form",
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
                height: height * 0.05,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100)),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Header(
                        headerTitle: "Cell Registration",
                        color: Color.fromARGB(255, 63, 81, 181),
                        radius: 10,
                        textFontSize: 18,
                        textWeight: FontWeight.bold,
                      ),
                      customForm.textFormField(
                        field_name: "Cell No.",
                        controller: cell_no,
                        keyboardType: TextInputType.number,
                        customValidator: validator.validateWholeNumber,
                      ),
                      customForm.textFormField(
                        field_name: "Cell Name",
                        controller: cell_name,
                        keyboardType: TextInputType.text,
                        customValidator: validator.validateText,
                      ),
                      CustomElevatedButton(
                        color: Color.fromARGB(255, 35, 110, 37),
                        buttonText: 'Upload',
                        height: 5,
                        width: 35,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            var support = await Support.init();
                            // String? uuid = await support.getString('uuid');
                            var data = {
                              "cell_id": cell_no.text.toString(),
                              "cell_name": cell_name.text.toString(),
                            };
                            if (await apiController.uploadData(
                                data, "register_cell", context)) {
                              // ignore: use_build_context_synchronously
                              Alert(
                                context: context,
                                type: AlertType.success,
                                desc: "Data Saved",
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      "ok",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close the alert dialog
                                      _formKey.currentState!
                                          .reset(); // Reset the form to clear fields
                                      cell_no
                                          .clear(); // Clear the TextEditingController for 'slno'
                                      cell_name.clear();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CellFormHome()));
                                    },
                                    width: 120,
                                  )
                                ],
                              ).show();
                            }
                          }
                        },
                        radius: 8,
                        textFontSize: 16,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
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
