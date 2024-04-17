import '../index.dart';

class Support {
  static Support? _instance;
  static SharedPreferences? _prefs; //to access shared preferences

  Support._(); // Private constructor

  static Future<Support> get instance async {
    _instance ??= Support._(); // Create a new instance if it's null
    await _initPrefs(); // Initialize SharedPreferences
    return _instance!;
  }

  static Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> setBool(String varName, bool value) async {
    await _prefs?.setBool(varName, value);
  }

  Future<void> setString(String varName, String varValue) async {
    await _prefs?.setString(varName, varValue);
  }

  Future<String?> getString(String varName) async {
    return _prefs?.getString(varName);
  }

  Future<void> remove(String varName) async {
    await _prefs?.remove(varName);
  }

  Future<bool?> getBool(String varName) async {
    return _prefs?.getBool(varName);
  }
}

class FileManager {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> localFile(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName.json');
  }

  Future<File> writeData(List<dynamic> data, String fileName) async {
    final file = await localFile(fileName);

    return file.writeAsString(json.encode(data));
  }

  Future<List<dynamic>?> readData(String fileName) async {
    try {
      final file = await localFile(fileName);

      String contents = await file.readAsString();

      return json.decode(contents);
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteAllFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = directory.listSync();
      for (var entity in files) {
        if (entity is File && entity.path.endsWith('.json')) {
          await entity.delete();
        }
      }
    } catch (e) {
      print('An error occurred while deleting the files: $e');
    }
  }
}

class Logout {
  static Future<void> logoutFun() async {
    var support = await Support.instance;
    await support.remove('token');
    await support.remove("uuid");
    await support.remove("id");
    await support.remove("name");
  }

  static void promptLogout(BuildContext context) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Logout",
      desc: "Do you want to Logout?",
      buttons: [
        DialogButton(
          child: Text(
            "Yes",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            await logoutFun();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    Login(), // make sure LoginPage is imported
              ),
              (Route<dynamic> route) => false,
            );
          },
          color: Colors.green,
        ),
        DialogButton(
          child: Text(
            "No",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.of(context).pop(false),
          color: Colors.red,
        ),
      ],
    ).show();
  }
}

class Validator {
  String? validateAlphaNum(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field cannot be empty';
    }

    // Regular expression for alphanumeric characters and spaces
    final RegExp alphaNumRegExp = RegExp(r'^[a-zA-Z0-9\s]+$');
    if (!alphaNumRegExp.hasMatch(value)) {
      return 'This field can only contain letters, numbers, and spaces';
    }

    return null; // null means valid
  }

  String? validateText(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Field is required';
    }
    final RegExp nameRegExp = RegExp(r'^[a-zA-Z\s,.()-]+$');
    if (!nameRegExp.hasMatch(value)) {
      return 'Field can only contain letters, spaces, and . , ( ) - characters';
    }
    return null;
  }

  String? validateMoney(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }

    // Remove commas for validation
    String numericValue = value.replaceAll(',', '');

    // Check for negative numbers
    if (numericValue.startsWith('-')) {
      return 'Negative numbers not allowed';
    }

    // Check for numeric value with exactly two decimal places (or none)
    final numberRegExp = RegExp(r'^\d+(\.\d{1,2})?$');
    if (!numberRegExp.hasMatch(numericValue)) {
      return 'Only numbers with up to two decimal places allowed';
    }

    return null; // null means valid // null means valid
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter phone number';
    } else if (value.length != 10) {
      return 'Please enter a valid 10 digit phone number';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    }
    final RegExp emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null; // null means valid
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    } else if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    } else if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    } else if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
      return 'Password must contain at least one number';
    } else if (!RegExp(r'(?=.*[!@#$%^&*(),.?":{}|<>])').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  String? validateWholeNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }

    final RegExp wholeNumberRegExp = RegExp(r'^\d+$');
    if (!wholeNumberRegExp.hasMatch(value)) {
      return 'Only whole numbers are allowed';
    }

    return null;
  }
}

class Miscellaneous {
  getAddress() {
    // return "http://192.168.137.84:5000/api";
    // return "http://10.177.15.135/cell-requirement-system/public/api";
    return "http://10.177.15.121/ep_project/ecell_system/public/api";
  }

  getKey() {
    return "XBMJwH94BHjSiVhICx3MfS9i5CaLL5HQjuRt9hiXfIc=";
  }
}
