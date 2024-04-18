import 'package:encrypt/encrypt.dart' as encrypt;
import '../index.dart';

import 'package:http/http.dart' as http;

class ApiControllerMain {
  static var _staging = Miscellaneous().getAddress();

  static String get staging => _staging;

  Future<Tuple2<bool, dynamic?>> login(
      String phone, String password, BuildContext context) async {
    EasyLoading.show(status: 'loading...');
    try {
      final apiUrl = Uri.parse("${_staging}/login");
      final key = encrypt.Key.fromBase64(Miscellaneous().getKey());
      final iv = encrypt.IV.fromSecureRandom(16);
      final encrypted =
          encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

      final encryptedPhone = encrypted.encrypt(phone, iv: iv);
      final encryptedPassword = encrypted.encrypt(password, iv: iv);

      final response = await http
          .post(
        apiUrl,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'phone': encryptedPhone.base64,
          'password': encryptedPassword.base64,
          'iv': iv.base64,
        }),
      )
          .timeout(Duration(seconds: 10), onTimeout: () {
        EasyLoading.showError('Request timed out. Please try again.');
        throw TimeoutException(
            "Login request took too long. Please try again.");
      });
      var body = jsonDecode(response.body);
      // print(body);
      if (response.statusCode == 200) {
        if (body['status'] == 'Token is Invalid' ||
            body['status'] == 'Token is Expired' ||
            body['status'] == 'Authorization Token not found') {
          Logout.promptLogout(context);
          return Tuple2(false, null);
        }

        if (body["msg"] == "Successful") {
          EasyLoading.showSuccess('Login Successful!',
              duration: Duration(seconds: 2));
          return Tuple2(true, body);
        }
      }
      // print(body);
      EasyLoading.showError(body["msg"].toString(),
          duration: Duration(seconds: 2));
      return Tuple2(false, null);
    } on TimeoutException catch (e) {
      EasyLoading.showError('Request timeout! Please try again.',
          duration: Duration(seconds: 2));
      return Tuple2(false, null);
    } catch (e) {
      EasyLoading.showError('Login Fail!', duration: Duration(seconds: 1));
      return Tuple2(false, null);
    }
  }

  Future<bool> fetchDataAndStore(String url, String fileName) async {
    var _support = await Support.init();
    String? _token = await _support.getString('token');

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $_token ',
        },
      );
      // ! add a msg in this response
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        if (jsonResponse is List) {
          FileManager().writeData(jsonResponse, fileName);
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> registerUser(Map<String, dynamic> data) async {
    final url = '$_staging/register';
    EasyLoading.show(status: 'loading...');
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 201) {
        var msg = jsonDecode(response.body);
        EasyLoading.showSuccess(msg['msg'].toString(),
            duration: const Duration(seconds: 2));
        return true;
      } else {
        var msg = jsonDecode(response.body);

        EasyLoading.showError(msg['msg'].toString(),
            duration: const Duration(seconds: 2));
        return false;
      }
    } on SocketException {
      EasyLoading.showError('Network error. Please check your connection.',
          duration: const Duration(seconds: 2));
      return false;
    } on TimeoutException {
      EasyLoading.showError('Request timeout. Please try again.',
          duration: const Duration(seconds: 2));
      return false;
    } catch (e) {
      EasyLoading.showError('An unexpected error occurred!',
          duration: const Duration(seconds: 2));
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }
}
