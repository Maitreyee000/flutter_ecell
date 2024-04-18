import 'package:cell_req/100/ReportGeneration/api_list_dispose.dart';
import 'package:cell_req/100/ReportGeneration/api_list_requirments.dart';
import 'package:external_path/external_path.dart' as ExtStorage;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../Helper/index.dart';

class RequirementsForm extends StatefulWidget {
  const RequirementsForm({super.key});

  @override
  State<RequirementsForm> createState() => _CellFormState();
}

class _CellFormState extends State<RequirementsForm> {
  final customForm = CustomForm();

  final item_name = TextEditingController();
  final qty = TextEditingController();
  final apiController = ApiController();
  final validator = Validator();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final cell_no = TextEditingController();
  final cell_name = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  DateTime? startDate2;
  DateTime? endDate2;

  bool? isLoading;

  String localPath = '';
  Key pdfKey = UniqueKey();

  Future<void> downloadPDF(Map<String, dynamic> data, String endpoint) async {
    final String pdfDownloadUrl =
        '${Miscellaneous().getAddress()}/pdf/$endpoint';
    var support = await Support.init();
    String? token = await support.getString('token');
    EasyLoading.show(status: "Downloading....");

    try {
      final response = await http.post(
        Uri.parse(pdfDownloadUrl),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 250) {
        final bytes = response.bodyBytes;
        String path =
            await ExtStorage.ExternalPath.getExternalStoragePublicDirectory(
                ExtStorage.ExternalPath.DIRECTORY_DOWNLOADS);
        Directory downloadDirectory = Directory(path);

        if (!await downloadDirectory.exists()) {
          await downloadDirectory.create(recursive: true);
        }

        int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
        String fileName = 'report_$currentTimeMillis.pdf';
        final file = File('${downloadDirectory.path}/$fileName');

        await file.writeAsBytes(bytes);
        _updateUIForNewPDF(file.path);
        EasyLoading.showSuccess("Successful\nPath: ${file.path}",
            duration: const Duration(seconds: 2));
      } else {
        var responseBody = jsonDecode(response.body);
        _handleTokenRelatedErrors(responseBody);
      }
    } catch (e) {
      _handleDownloadError(e);
    }
  }

  void _updateUIForNewPDF(String path) {
    setState(() {
      localPath = path;
      pdfKey = UniqueKey(); // Refresh the PDFView when a new file is loaded
    });
    EasyLoading.showSuccess("File is stored in $localPath",
        duration: const Duration(seconds: 5));
  }

  void _handleTokenRelatedErrors(dynamic responseBody) {
    if (responseBody is Map &&
        (responseBody['status'] == 'Token is Invalid' ||
            responseBody['status'] == 'Token is Expired' ||
            responseBody['status'] == 'Authorization Token not found')) {
      Logout.logoutFun();
      EasyLoading.showError(
          'Token is invalid or expired. Please log in again.');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Login()), // Update with actual Login Screen Widget
      );
    } else {
      EasyLoading.showError("Error: Unexpected response",
          duration: const Duration(seconds: 2));
    }
  }

  void _handleDownloadError(dynamic error) {
    String errorMessage = "An error occurred";
    if (error is SocketException) {
      errorMessage = "Network Error: $error";
    } else if (error is TimeoutException) {
      errorMessage = "Network Timeout: $error";
    } else {
      errorMessage = "Error: $error";
    }
    EasyLoading.showError(errorMessage, duration: const Duration(seconds: 2));
  }

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
              "Report Generation",
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
                        headerTitle: "Download Requirement Detail",
                        color: Color.fromARGB(255, 63, 81, 181),
                        radius: 10,
                        textFontSize: 18,
                        textWeight: FontWeight.bold,
                      ),
                      customForm.tableSection(children: [
                        customForm.dateRangeFieldGroup(
                          context: context,
                          startFieldName: 'Start Date',
                          endFieldName: 'End Date',
                          startDate: startDate,
                          endDate: endDate,
                          onStartChanged: (selectedStartDate) {
                            setState(() {
                              startDate = selectedStartDate;

                              if (endDate != null &&
                                  endDate!.isBefore(startDate!)) {
                                endDate = startDate;
                              }
                            });
                          },
                          onEndChanged: (selectedEndDate) {
                            setState(() {
                              endDate = selectedEndDate;
                            });
                          },
                        ),
                      ]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomElevatedButton(
                            color: Color(0xff112948),
                            buttonText: 'Download',
                            height: 5,
                            width: 35,
                            onPressed: () async {
                              if (startDate == null || endDate == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Please select both start and end dates.'),
                                  ),
                                );
                              } else if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                var support = await Support.init();
                                String? uuid = await support.getString('uuid');
                                var data = {
                                  'start': DateFormat('yyyy-MM-dd')
                                      .format(startDate!),
                                  'end':
                                      DateFormat('yyyy-MM-dd').format(endDate!),
                                  'requested_by': uuid.toString(),
                                };

                                downloadPDF(data, "download_requirement_list");
                              }
                            },
                            radius: 8,
                            textFontSize: 16,
                          ),
                          CustomElevatedButton(
                            color: Color(0xff112948),
                            buttonText: 'View',
                            height: 5,
                            width: 35,
                            onPressed: () async {
                              if (startDate == null || endDate == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Please select both start and end dates.'),
                                  ),
                                );
                              } else {
                                var support = await Support.init();
                                String? uuid = await support.getString('uuid');
                                var data = {
                                  'start': DateFormat('yyyy-MM-dd')
                                      .format(startDate!),
                                  'end':
                                      DateFormat('yyyy-MM-dd').format(endDate!),
                                  'requested_by': uuid.toString(),
                                };
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ApiListRequirement(
                                      idData: jsonEncode(data),
                                    ),
                                  ),
                                );
                              }
                            },
                            radius: 8,
                            textFontSize: 16,
                          ),
                        ],
                      ),
                      Header(
                        headerTitle: "Download Dispose Detail",
                        color: Color.fromARGB(255, 63, 81, 181),
                        radius: 10,
                        textFontSize: 18,
                        textWeight: FontWeight.bold,
                      ),
                      customForm.tableSection(children: [
                        customForm.dateRangeFieldGroup(
                          context: context,
                          startFieldName: 'Start Date',
                          endFieldName: 'End Date',
                          startDate: startDate2,
                          endDate: endDate2,
                          onStartChanged: (selectedStartDate) {
                            setState(() {
                              startDate2 = selectedStartDate;

                              if (endDate2 != null &&
                                  endDate2!.isBefore(startDate2!)) {
                                endDate2 = startDate;
                              }
                            });
                          },
                          onEndChanged: (selectedEndDate) {
                            setState(() {
                              endDate2 = selectedEndDate;
                            });
                          },
                        ),
                      ]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomElevatedButton(
                            color: Color(0xff112948),
                            buttonText: 'Download',
                            height: 5,
                            width: 35,
                            onPressed: () async {
                              if (startDate2 == null || endDate2 == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Please select both start and end dates.'),
                                  ),
                                );
                              } else if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                var support = await Support.init();
                                String? uuid = await support.getString('uuid');
                                var data = {
                                  'start': DateFormat('yyyy-MM-dd')
                                      .format(startDate2!),
                                  'end': DateFormat('yyyy-MM-dd')
                                      .format(endDate2!),
                                  'requested_by': uuid.toString(),
                                };

                                downloadPDF(data, "download_dispose_list");
                              }
                            },
                            radius: 8,
                            textFontSize: 16,
                          ),
                          CustomElevatedButton(
                            color: Color(0xff112948),
                            buttonText: 'View',
                            height: 5,
                            width: 35,
                            onPressed: () async {
                              if (startDate2 == null || endDate2 == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Please select both start and end dates.'),
                                  ),
                                );
                              } else {
                                var support = await Support.init();
                                String? uuid = await support.getString('uuid');
                                var data = {
                                  'start': DateFormat('yyyy-MM-dd')
                                      .format(startDate2!),
                                  'end': DateFormat('yyyy-MM-dd')
                                      .format(endDate2!),
                                  'requested_by': uuid.toString(),
                                };

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ApiListDispose(
                                            idData: jsonEncode(data),
                                          )),
                                );
                              }
                            },
                            radius: 8,
                            textFontSize: 16,
                          ),
                        ],
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
