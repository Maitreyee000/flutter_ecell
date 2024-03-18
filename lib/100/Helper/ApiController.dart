import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:http/http.dart' as http;
import 'index.dart';

class ApiController {
  static var ipAddress = "${ApiControllerMain.staging}";

  Future<bool> fetchDataAndStore(String url, String fileName) async {
    var support = await Support.instance;
    String? token = await support.getString('token');

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        if (jsonResponse is List) {
          FileManager().writeData(jsonResponse, fileName);
          return true; // Return true if the fetch was successful
        } else {
          return false; // Return false or some other value to signify an error
        }
      } else {
        return false; // Return false or some other value to signify an error
      }
    } catch (e) {
      return false; // Return false or some other value to signify an error
    }
  }

  Future<List?> getDataListById(
      BuildContext context, String endpoint, Map<String, dynamic> data) async {
    var support = await Support.instance;

    String? token = await support.getString('token');
    String? uuid = await support.getString('uuid');
    String? statusCode = await support.getString('statusCode');

    var url = Uri.parse('${ipAddress}/$statusCode/${endpoint}');

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      var response = await http
          .post(url, headers: headers, body: jsonEncode(data))
          .timeout(const Duration(seconds: 30));
      var responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseBody is Map &&
            (responseBody['status'] == 'Token is Invalid' ||
                responseBody['status'] == 'Token is Expired' ||
                responseBody['status'] == 'Authorization Token not found')) {
          Logout.logoutFun();
          EasyLoading.showError(
              'Token is invalid or expired. Please log in again.');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        } else if (responseBody is List) {
          EasyLoading.showSuccess('Data is Loaded!',
              duration: const Duration(milliseconds: 500));

          return responseBody;
        }
      }
    } catch (e) {
      EasyLoading.showError('Failed to fetch data. Please try again.',
          duration: const Duration(milliseconds: 500));
      return null;
    }
    EasyLoading.showError('Failed to fetch data. Please try again.');
  }

  Future<bool> uploadData(
      Map<String, dynamic> data, String endpoint, BuildContext context) async {
    EasyLoading.show(status: 'Uploading...');

    Support support = await Support.instance;
    String? token = await support.getString('token');
    String? statusCode = await support.getString('statusCode');
    var url = Uri.parse('${ipAddress}/$statusCode/${endpoint}');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      http.Response response = await http
          .post(
            url,
            headers: headers,
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 30));
      Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == 'Token is Invalid' ||
            responseData['status'] == 'Token is Expired' ||
            responseData['status'] == 'Authorization Token not found') {
          await Logout.logoutFun();
          EasyLoading.showError(
              'Token is invalid or expired. Please log in again.',
              duration: const Duration(milliseconds: 500));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
          return false;
        }
        if (responseData.containsKey("msg") &&
            responseData["msg"] != null &&
            responseData["msg"] != "null" &&
            responseData["msg"].toString().trim().isNotEmpty) {
          EasyLoading.showSuccess(responseData["msg"],
              duration: const Duration(milliseconds: 500));
          return true;
        }

        EasyLoading.showSuccess('Successful!',
            duration: const Duration(milliseconds: 500));
        return true;
      } else {
        if (responseData.containsKey("msg") &&
            responseData["msg"] != null &&
            responseData["msg"] != "null" &&
            responseData["msg"].toString().trim().isNotEmpty) {
          EasyLoading.showError(responseData["msg"],
              duration: const Duration(milliseconds: 500));
          return false;
        }
        EasyLoading.showError('Error while Uploading',
            duration: const Duration(milliseconds: 500));
        return false;
      }
    } on TimeoutException catch (e) {
      EasyLoading.showError('Request timed out',
          duration: const Duration(milliseconds: 500));
      return false;
    } catch (e) {
      EasyLoading.showError('$e Error while Uploading',
          duration: const Duration(milliseconds: 500));
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<List?> getDataList(BuildContext context, String endpoint) async {
    var support = await Support.instance;
    String? token = await support.getString('token');
    String? username = await support.getString('username');
    String? statusCode = await support.getString('statusCode');
    var url = Uri.parse('${ipAddress}/$statusCode/${endpoint}');

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      var response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 30));
      var responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseBody is Map &&
            (responseBody['status'] == 'Token is Invalid' ||
                responseBody['status'] == 'Token is Expired' ||
                responseBody['status'] == 'Authorization Token not found')) {
          Logout.logoutFun();
          EasyLoading.showError(
              'Token is invalid or expired. Please log in again.');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        } else if (responseBody is List) {
          EasyLoading.showSuccess('Data is Loaded!',
              duration: const Duration(milliseconds: 500));

          return responseBody;
        }
      }
    } catch (e) {
      EasyLoading.showError('Failed to fetch data. Please try again.',
          duration: const Duration(milliseconds: 500));
      return null;
    }
    EasyLoading.showError('Failed to fetch data. Please try again.');
  }

  Future<dynamic> getDataMapById(
      BuildContext context, String endpoint, Map<String, dynamic> data) async {
    print("-----------------------------------");
    print(data);
    var support = await Support.instance;

    String? token = await support.getString('token');
    String? uuid = await support.getString('uuid');
    String? statusCode = await support.getString('statusCode');

    var url = Uri.parse('${ipAddress}/$statusCode/$endpoint');

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      var response = await http
          .post(url, headers: headers, body: jsonEncode(data))
          .timeout(const Duration(seconds: 20));
      var body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (body is Map &&
            (body['status'] == 'Token is Invalid' ||
                body['status'] == 'Token is Expired' ||
                body['status'] == 'Authorization Token not found')) {
          Logout.logoutFun();
          EasyLoading.showError(
              'Token is invalid or expired. Please log in again.');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        } else if (body is Map<String, dynamic>) {
          EasyLoading.showSuccess('Data is Loaded!',
              duration: const Duration(milliseconds: 500));

          return body;
        }
      }
    } catch (e) {
      EasyLoading.showError('Failed to fetch data. Please try again.',
          duration: const Duration(milliseconds: 500));
      return null;
    }
    EasyLoading.showError('Failed to fetch data. Please try again.');
  }
}
