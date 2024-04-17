import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import 'package:image/image.dart' as ui;
import '../index.dart';

class ScreenDimensions {
  //its returning screen size right?
  //where is it used
  final double height;
  final double width;

  ScreenDimensions(this.height, this.width);

  factory ScreenDimensions.fromContext(BuildContext? context) {
    if (context == null) {
      return ScreenDimensions(0.0, 0.0);
    }
    final Size size = MediaQuery.of(context)
        .size; //is used to get the size of the screen in Flutter
    return ScreenDimensions(size.height, size.width);
  }
}

TableRow radioButtonFieldGroup({
  //TableRow is a flutter class
  required String fieldName,
  required List<String> options,
  required String groupValue, // <-- New parameter for external control
  ValueChanged<String>? onRadioChanged,
}) {
  return TableRow(
    children: [
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Center(
          child: Text(
            fieldName, //display this within the cell
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Column(
          children: [
            Wrap(
              spacing: 8.0,
              children: options.map((option) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<String>(
                      value: option,
                      groupValue: groupValue, // Use external groupValue here
                      onChanged: (String? value) {
                        if (onRadioChanged != null) onRadioChanged(value!);
                      },
                    ),
                    Text(option, overflow: TextOverflow.ellipsis),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    ],
  );
}

TableRow emptyRow() {
  return TableRow(children: [
    TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Center(
        child: Container(
          height: 1, // Set the height to a small value
          color: Colors.transparent, // Set color to transparent
        ),
      ),
    ),
    TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Center(
        child: Container(
          height: 1, // Set the height to a small value
          color: Colors.transparent, // Set color to transparent
        ),
      ),
    ),
  ]);
}

class Dashboard {
  final BuildContext context;
  final Widget buttonIcon; // Changed from Icon to Widget
  final String buttonLabel;

  double cardWidth = .35;
  double cardHeight = .15;
  double iconWidth = 0.2;
  double iconHeight = 0.06;

  final Widget page;
  final Color backgroundColor;

  Dashboard({
    required this.context,
    required this.buttonIcon,
    required this.buttonLabel,
    required this.page,
    required this.backgroundColor,
  });

  Widget LgNavBtn({
    cardWidth = .75,
    cardHeight = .14,
  }) {
    ScreenDimensions dimensions = ScreenDimensions.fromContext(context);
    double width = dimensions.width;
    double height = dimensions.height;
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => page)),
      child: Container(
        margin: EdgeInsets.all(10),
        height: height * cardHeight,
        width: width * cardWidth,
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.all(10),
                height: height * iconHeight,
                width: width * iconWidth,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: buttonIcon),
            SizedBox(
              width: width * 0.1,
            ),
            Text(
              buttonLabel,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget SmNavBtn({cardHeight = .15, cardWidth = .35}) {
    ScreenDimensions dimensions = ScreenDimensions.fromContext(context);
    double width = dimensions.width;
    double height = dimensions.height;
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => page)),
      child: Container(
        margin: EdgeInsets.all(10),
        height: height * cardHeight,
        width: width * cardWidth,
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.all(10),
                height: height * iconHeight,
                width: width * iconWidth,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: buttonIcon),
            SizedBox(
              width: width * 0.1,
            ),
            Text(
              buttonLabel,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}

//login TextField

class CustomDropdown<T> extends StatefulWidget {
  final String hintText;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final InputDecoration? decoration;
  final IconData? prefixIcon;

  CustomDropdown({
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.value,
    this.decoration,
    this.prefixIcon,
  });

  @override
  _CustomDropdownState<T> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    ScreenDimensions dimensions = ScreenDimensions.fromContext(context);
    return DropdownButtonFormField<T>(
      value: widget.value,
      items: widget.items,
      onChanged: widget.onChanged,
      decoration: widget.decoration ??
          InputDecoration(
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: Colors.grey,
                  )
                : null, // Adding the icon here
            filled: true,
            fillColor: Color(0xffe1effd),
            contentPadding: EdgeInsets.only(
                left: dimensions.width * 0.05,
                top: dimensions.height * 0.02,
                bottom: dimensions.height * 0.00),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xffe1effd)),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  double height;
  double width;
  final int radius;
  final String buttonText;
  final Color color;
  final Color textColor;
  final double textFontSize;

  CustomElevatedButton({
    required this.onPressed,
    required this.height, // These are intended to be percentages
    required this.width, // These are intended to be percentages
    this.radius = 0,
    required this.buttonText,
    this.color = const Color(0xFF382e84),
    this.textColor = Colors.white,
    this.textFontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    ScreenDimensions dimensions = ScreenDimensions.fromContext(context);
    EdgeInsets margin = EdgeInsets.all(0);
    // Adjust the size based on whether the platform is web or not.
    double screenWidth = dimensions.width * (width / 100);
    double screenHeight = dimensions.height * (height / 100);

    return Container(
      padding: EdgeInsets.all(5),
      margin: margin,
      child: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: ElevatedButton(
          style: _buttonStyle(radius: radius, color: color),
          onPressed: onPressed,
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: _textStyle(textColor: textColor, textFontSize: textFontSize),
          ),
        ),
      ),
    );
  }

  ButtonStyle _buttonStyle({required int radius, required Color color}) {
    return ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.toDouble()),
          side: BorderSide(color: Color(0xff02306b), width: 1.5),
        ),
      ),
      backgroundColor: MaterialStateProperty.all(color),
    );
  }

  TextStyle _textStyle(
      {required Color textColor, required double textFontSize}) {
    return TextStyle(fontSize: textFontSize, color: textColor);
  }
}

class Header extends StatelessWidget {
  final String headerTitle;
  final Color color;
  final double radius;
  final Alignment alignment;
  EdgeInsets margin;
  final EdgeInsets padding;
  final Color textColor;
  final double textFontSize;
  final FontWeight textWeight;
  Header(
      {required this.headerTitle,
      this.color = const Color.fromARGB(255, 63, 81, 181),
      this.radius = 20,
      this.alignment = Alignment.center,
      this.margin = const EdgeInsets.all(10),
      this.padding = const EdgeInsets.all(10),
      this.textColor = Colors.white,
      this.textFontSize = 18,
      this.textWeight = FontWeight.bold});

  @override
  Widget build(BuildContext context) {
    ScreenDimensions dimensions = ScreenDimensions.fromContext(context);

    return Container(
      padding: padding,
      margin: margin,
      alignment: alignment,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(radius)),
      child: Text("${headerTitle}",
          style: _textStyle(
              textColor: textColor,
              textFontSize: textFontSize,
              textWeight: textWeight)),
    );
  }

  TextStyle _textStyle(
      {required Color textColor,
      required double textFontSize,
      required FontWeight textWeight}) {
    return TextStyle(
        fontSize: textFontSize, color: textColor, fontWeight: textWeight);
  }
}

class CustomFormSection extends StatelessWidget {
  final children;

  const CustomFormSection({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7, horizontal: 37),
      child: Table(
          // textDirection: TextDirection.ltr,
          defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
          border: TableBorder.all(
            width: 2.0,
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          children: children),
    );
  }
}

class CustomForm {
  final List<dynamic>? mappedData;
  ValueChanged<String?>? onChanged;
  String? dropdownText;
  String? initialValue;
  String? selectedValue;
  String? field_name;
  double dropdown_bar_width = 200;
  Color fillColor = Color(0xffe1effd);

  CustomForm({
    this.mappedData,
    this.onChanged,
    this.dropdownText,
    this.initialValue,
    this.selectedValue,
    this.field_name,
  });
  Widget dropDown(
    String field_name,
    String dropdownText,
    ValueChanged<String?>? onChanged, {
    String? initialValue,
    Color? fillColor = Colors.white, // Default color if none is provided
    required List<dynamic>? mappedData,
    double? width, // Adjusted width as needed
  }) {
    Widget fieldValueWidget = Container(
      margin: EdgeInsets.only(bottom: 10),
      alignment: Alignment.center, // Center alignment for the dropdown
      child: SizedBox(
        width: width, // Apply the width here
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                vertical: 0, horizontal: 10), // Reduce padding
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: fillColor,
          ),
          isExpanded: true,
          value: initialValue,
          hint: Text("$dropdownText"),
          items: mappedData
              ?.map((item) => DropdownMenuItem<String>(
                    value: item["opt_id"].toString(),
                    child: Container(
                      // Adjusting container within dropdown item for height control
                      padding:
                          EdgeInsets.symmetric(vertical: 0), // Minimize padding
                      child: Text(
                        item["opt_name"].toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ))
              ?.toList(),
          onChanged: onChanged,
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ),
    );

    return Center(
      // Ensure the entire widget is centered
      child: Container(
        width: width, // Apply the same width to maintain consistency
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center children vertically
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                field_name,
                style: TextStyle(
                  color: Colors.blue[900],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 0), // Minimized space, adjust as needed or remove
            fieldValueWidget,
          ],
        ),
      ),
    );
  }

  TableRow DashboardDropdown(
      String initialText, ValueChanged<String?>? onChanged,
      {String? initialValue}) {
    Widget fieldValueWidget = Container(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 400,
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: Color(0xffF5F5F5),
              enabledBorder: InputBorder.none,
            ),
            isExpanded: true,
            value: initialValue,
            hint: Text(
              "Select",
              textAlign: TextAlign.center,
            ),
            items: mappedData
                ?.map((item) => DropdownMenuItem<String>(
                      value: item["opt_id"].toString(),
                      child: Text(
                        item["opt_name"].toString(),
                        overflow: TextOverflow.visible,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ))
                ?.toList(),
            onChanged: onChanged,
            // onChanged: (value) {
            //   selectedValue = value;
            //   onChanged?.call(value);
            // },
          ),
        ),
      ),
    );

    return TableRow(
      children: [
        // 1. Dropdown
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: fieldValueWidget,
        ),
        // 2. Display Initial Text / Selected Value
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Center(
            child: Text(selectedValue ?? initialText),
          ),
        ),
        // 3. Refresh Button
      ],
    );
  }

  Row customRow(List<Widget> children) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  TableRow DashboardDateRange(
    String initialText,
    VoidCallback onRefreshButtonPressed,
    var startDate,
    var endDate,
    VoidCallback onDateRangeButtonPressed,
  ) {
    Widget dateRangeButton = Container(
      child: TextButton(
          onPressed: onDateRangeButtonPressed,
          child: startDate == null || endDate == null
              ? Text("Pick Date Range")
              : Column(
                  mainAxisSize: MainAxisSize
                      .min, // Ensure the column takes the minimum space
                  children: [
                    Text(
                      "Fr: ${DateFormat('dd-MM-yyyy').format(startDate)}",
                      textAlign: TextAlign.center,
                      overflow:
                          TextOverflow.ellipsis, // Add overflow handling here
                    ),
                    Text(
                      "To: ${DateFormat('dd-MM-yyyy').format(endDate)}",
                      textAlign: TextAlign.center,
                      overflow:
                          TextOverflow.ellipsis, // Add overflow handling here
                    ),
                  ],
                )),
    );

    return TableRow(
      children: [
        // 1. Date Range Button
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: dateRangeButton,
        ),
        // 2. Display Start and End Date
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: SingleChildScrollView(
            // Wrap the content with SingleChildScrollView
            child: Center(
              child: Text(
                "${initialText}",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  TableRow DashboardDateRow(
    String initialText,
    VoidCallback onRefreshButtonPressed,
    var selectedDate,
    VoidCallback onDateButtonPressed,
  ) {
    Widget dateButton = Container(
      child: TextButton(
        onPressed:
            onDateButtonPressed, // Callback function to handle date button press
        child: selectedDate == null
            ? Text("Pick a Date")
            : Text(
                "Date: ${DateFormat('dd-MM-yyyy').format(selectedDate)}",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis, // Handle text overflow
              ),
      ),
    );

    return TableRow(
      children: [
        // 1. Date Button
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: dateButton,
        ),
        // 2. Display Text (can be used for other info or removed if not needed)
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: SingleChildScrollView(
            // Wrap the content with SingleChildScrollView
            child: Center(
              child: Text(
                "${initialText}",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

//!! searchDropDown table
  searchDropDown(
    BuildContext context,
    String field_name,
    String dropdownText,
    void Function(String?, String?) onChanged,
    // String? initValueName,
    String? initialValue,
  ) {
    Widget fieldValueWidget = PopDropDown(
        onChanged: onChanged,
        mappedData: mappedData,
        dialogContext: context,
        initialValue: initialValue);
    EasyLoading.dismiss();
    return TableRow(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      field_name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.blue[900],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: fieldValueWidget,
            ),
          ),
        ),
      ],
    );
  }

//!! textField
  TableRow textField({required String field_name, required String field_val}) {
    Widget fieldValueWidget = Center(
      child: Text(
        field_val,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    return TableRow(children: [
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    field_name,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          color: Colors.grey[350],
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: fieldValueWidget,
            ),
          ),
        ),
      ),
    ]);
  }

  // Widget fileInputField({
  //   required String fieldName,
  //   bool isRequired = true,
  //   ValueChanged<String>? onFileSelected,
  //   bool readOnly = false,
  //   String? initialValue,
  //   TextInputType keyboardType = TextInputType.text,
  //   Color fillColor = Colors.white,
  // }) {
  //   // Function to handle file selection
  //   Future<void> _pickFile() async {
  //     FilePickerResult? result = await FilePicker.platform.pickFiles();

  //     if (result != null) {
  //       // Assuming we're interested in a single file selection
  //       PlatformFile file = result.files.first;

  //       // This is where you could do something with the selected file
  //       // For example, you could use the `onFileSelected` callback to pass the file's path or its contents back
  //       if (onFileSelected != null && file.path != null) {
  //         onFileSelected(file
  //             .path!); // Use the '!' operator to assert that the value is not null.
  //       } else {
  //         // Handle the case where file.path is null or onFileSelected is null.
  //         // You might want to inform the user or log an error.
  //       }
  //     } else {
  //       // User canceled the picker
  //     }
  //   }

  //   // UI for the file input field
  //   return GestureDetector(
  //     onTap: readOnly ? null : _pickFile,
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //       margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
  //       decoration: BoxDecoration(
  //         color: fillColor,
  //         borderRadius: BorderRadius.circular(10),
  //         border: Border.all(color: Colors.black),
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Expanded(
  //             child: Text(
  //               initialValue ?? fieldName,
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 color: initialValue != null ? Colors.black : Colors.grey,
  //               ),
  //               overflow: TextOverflow.ellipsis,
  //             ),
  //           ),
  //           Icon(Icons.file_upload),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  TableRow imageField({
    required String field_name,
    Null Function(double latitude, double longitude, String? path)?
        onLocationSelected,
    String? initialImagePath,
    String? initialImageBase64, // New parameter
  }) {
    Widget fieldValueWidget = ImageSelectionWidget(
      onLocationSelected: onLocationSelected,
      initialImagePath: initialImagePath,
      initialImageBase64: initialImageBase64, // Pass to the widget
    );
    Widget imageWidget;

    if (initialImageBase64 != null) {
      try {
        //(initialImageBase64);
        // Try to decode the string
        Uint8List imageBytes = base64Decode(initialImageBase64);
        imageWidget = Image.memory(imageBytes);
      } catch (e) {
        // You can add additional checks here if you want to handle this case specifically
        if (initialImagePath != null) {
          // Use image path
          imageWidget = Image.file(File(initialImagePath));
        } else {
          // Placeholder in case there's no image data
          imageWidget =
              Icon(Icons.image, size: 50); // change this placeholder as needed
        }
      }
    } else if (initialImagePath != null) {
      // Use image path
      imageWidget = Image.file(File(initialImagePath));
    } else {
      // Placeholder in case there's no image data
      imageWidget =
          Icon(Icons.image, size: 50); // change this placeholder as needed
    }

    return TableRow(children: [
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    field_name,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: fieldValueWidget,
          ),
        ),
      ),
    ]);
  }

  Widget textFormField(
      {required String field_name,
      bool isRequired = true,
      TextEditingController? controller,
      ValueChanged<String?>? onSaved,
      bool readOnly = false,
      int? maxLines = 1,
      String? initialValue,
      String? Function(String?)? customValidator,
      TextInputType keyboardType = TextInputType.text,
      bool isSmall = false,
      bool inLakh = false,
      Color fillColor = Colors.white,
      bool isPassword =
          false, // New parameter to indicate if it's a password field
      bool isPasswordVisible = false, // New parameter for toggling visibility
      VoidCallback? togglePasswordVisibility,
      int? maxLength,
      custWidth = 0.8}) {
    String? _errorText;
    TextEditingController _controller =
        controller ?? TextEditingController(text: initialValue);

    if (inLakh && initialValue != null) {
      _controller.text = NumberFormat('#,##,##0')
          .format(int.tryParse(initialValue.replaceAll(',', '')) ?? 0);
    }

    _controller.addListener(() {
      if (inLakh) {
        String text = _controller.text.replaceAll(',', '');
        int? number = int.tryParse(text);
        if (number != null) {
          String formatted = NumberFormat('#,##,##0').format(number);
          if (formatted != _controller.text) {
            _controller.value = TextEditingValue(
              text: formatted,
              selection: TextSelection.fromPosition(
                TextPosition(offset: formatted.length),
              ),
            );
          }
        }
      }
    });

    Widget fieldValueWidget = TextFormField(
      textCapitalization: TextCapitalization.words,
      maxLength: maxLength,
      obscureText:
          isPassword && !isPasswordVisible, // Use the new parameters here
      decoration: InputDecoration(
        hintText: field_name,
        labelText: field_name,
        hintStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.only(
          left: 14.0,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(10.0),
        ),
        suffixIcon:
            isPassword // Conditional rendering based on if it's a password field
                ? IconButton(
                    icon: Icon(isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: togglePasswordVisibility,
                  )
                : null,
      ),
      keyboardType: keyboardType,
      style: TextStyle(fontWeight: FontWeight.bold),
      onSaved: onSaved,
      readOnly: readOnly,
      controller: _controller,
      validator: (String? value) {
        // If the field is required and the value is empty, return an error message.
        if (isRequired && (value == null || value.trim().isEmpty)) {
          return "Field Required!";
        }

        // If the field is not required but has a value, or if it is required and has a value,
        // pass it through the customValidator.
        if (value != null && value.isNotEmpty) {
          if (customValidator != null) {
            // Custom validation logic is applied here
            return customValidator(value);
          }
        }

        // If none of the above conditions match, validation passes by returning null.
        return null;
      },
      maxLines: maxLines,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        double height = MediaQuery.of(context).size.height;
        return Container(
          alignment: Alignment.center,
          height: maxLines! > 3 ? height * 0.14 : height * 0.08,
          width: isSmall
              ? MediaQuery.of(context).size.width * 0.4
              : MediaQuery.of(context).size.width * custWidth,
          child: Center(child: fieldValueWidget),
        );
      },
    );
  }

  TableRow textFieldArray(
      {required List<String> field_names,
      List<Widget> actionWidgets = const [],
      Color textColor = Colors.black,
      Color rowColor = Colors.white}) {
    List<Widget> fieldWidgets = field_names.map((fieldName) {
      return TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: 10, vertical: 5), // Adjust the margin values
            child: Text(
              overflow: TextOverflow.fade,
              fieldName,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold, color: textColor),
            ),
          ),
        ),
      );
    }).toList();

    if (actionWidgets.isNotEmpty) {
      fieldWidgets[fieldWidgets.length - 1] = TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Center(
          child: Container(
// Adjust the margin values
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  field_names.last,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ...actionWidgets,
              ],
            ),
          ),
        ),
      );
    }

    return TableRow(
        decoration: BoxDecoration(
            color: rowColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        children: fieldWidgets);
  }

//!! dateField
  Widget dateField(
    BuildContext context,
    String field_name, {
    TextEditingController? dateController,
    Function(String?)? onSaved,
    bool isSmall = false,
  }) {
    Widget fieldValueWidget = GestureDetector(
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null && dateController != null) {
          dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
          if (onSaved != null) {
            onSaved(dateController.text);
          }
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: dateController,
          decoration: InputDecoration(
            hintText: field_name,
            labelText: field_name,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            filled: true,
            fillColor: Color.fromARGB(255, 236, 237, 239),
            contentPadding:
                const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 6),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xffe1effd)),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a valid date';
            }
            return null;
          },
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        double height = MediaQuery.of(context).size.height;

        return Container(
          alignment: Alignment.center,
          width: isSmall
              ? MediaQuery.of(context).size.width * 0.4
              : MediaQuery.of(context).size.width * 0.8,
          child: Center(child: fieldValueWidget),
        );
      },
    );
  }

//!! imageFieldBase64
  TableRow imageFieldBase64({
    required String field_name,
    required String base64Image,
    required BuildContext
        context, // Add BuildContext parameter to use showDialog function
  }) {
    try {
      Uint8List bytes = base64Decode(base64Image);
      Widget fieldValueWidget = GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Image.memory(
                    bytes,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        },
        child: Image.memory(
          bytes,
          fit: BoxFit.cover,
        ),
      );

      return TableRow(children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                field_name,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: fieldValueWidget,
            ),
          ),
        ),
      ]);
    } catch (e) {
      print('Error decoding base64 image: $e');
      return TableRow(children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                field_name,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Invalid Image',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ]);
    }
  }

  TableRow radioButtonFieldGroup({
    required String fieldName,
    required List<String> options,
    required String groupValue, // <-- New parameter for external control
    ValueChanged<String>? onRadioChanged,
  }) {
    return TableRow(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Center(
            child: Text(
              fieldName,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Column(
            children: [
              Wrap(
                spacing: 8.0,
                children: options.map((option) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: option,
                        groupValue: groupValue, // Use external groupValue here
                        onChanged: (String? value) {
                          if (onRadioChanged != null) onRadioChanged(value!);
                        },
                      ),
                      Text(option, overflow: TextOverflow.ellipsis),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  TableRow dateRangeFieldGroup({
    required BuildContext context,
    required String startFieldName,
    required String endFieldName,
    DateTime? startDate,
    DateTime? endDate,
    required Function(DateTime) onStartChanged,
    required Function(DateTime) onEndChanged,
  }) {
    final dateFormat = DateFormat('yyyy-MM-dd');

    return TableRow(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Center(
            child: TextButton(
              onPressed: () => _selectDate(
                context: context,
                initialDate: startDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2025),
                onDateChanged: onStartChanged,
              ),
              child: Text(
                startDate == null
                    ? startFieldName
                    : dateFormat.format(startDate),
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Center(
            child: TextButton(
              onPressed: () => _selectDate(
                context: context,
                initialDate: endDate ?? (startDate ?? DateTime.now()),
                firstDate: startDate ?? DateTime.now(),
                lastDate: DateTime(2025),
                onDateChanged: onEndChanged,
              ),
              child: Text(
                endDate == null ? endFieldName : dateFormat.format(endDate),
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    required Function(DateTime) onDateChanged,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) {
      onDateChanged(picked);
    }
  }

  TableRow emptyRow() {
    return TableRow(children: [
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Center(
          child: Container(
            height: 1, // Set the height to a small value
            color: Colors.transparent, // Set color to transparent
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Center(
          child: Container(
            height: 1, // Set the height to a small value
            color: Colors.transparent, // Set color to transparent
          ),
        ),
      ),
    ]);
  }

  CustomFormSection tableSection({required List<TableRow> children}) {
    return CustomFormSection(children: children);
  }
}

//!! dependence of searchDropDown
class PopDropDown extends StatefulWidget {
  final Function(String?, String?) onChanged;
  final mappedData;
  final initialValue;
  final BuildContext dialogContext;

  const PopDropDown({
    Key? key,
    required this.onChanged,
    this.mappedData,
    required this.dialogContext,
    this.initialValue,
  }) : super(key: key);

  @override
  PopDropDownState createState() => PopDropDownState(); // change type here
}

class PopDropDownState extends State<PopDropDown> {
  String? selectedOptionId;
  String? selectedOptionName;
  final TextEditingController _textController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    selectedOptionName = getNameFromId(widget.initialValue);
  }

  String? getNameFromId(String? id) {
    if (id == null || widget.mappedData == null) {
      return null;
    }
    final item = widget.mappedData?.firstWhere(
        (item) => item["opt_id"].toString() == id,
        orElse: () => null);

    return item?["opt_name"]?.toString();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _onButtonPressed,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(5),
        child: Text(
          textAlign: TextAlign.center,
          "${widget.initialValue}" == "null"
              ? "Select Instiute/Scheme"
              : "${getNameFromId(widget.initialValue)}",
          style: TextStyle(
              fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _onButtonPressed() async {
    setState(() {
      isLoading = true;
    });

    showDropdownDialog(
      widget.dialogContext,
      (selectedOptionId, selectedOptionName) {
        setState(() {
          this.selectedOptionId = selectedOptionId;
          this.selectedOptionName = selectedOptionName;
          isLoading = false;
        });
        widget.onChanged(selectedOptionId, selectedOptionName);
      },
      widget.mappedData,
      selectedOptionId,
      '',
    );
  }

  void showDropdownDialog(
    BuildContext context,
    void Function(String?, String?) onChanged,
    List<dynamic>? mappedData,
    String? initialValue,
    String? initialValueName,
  ) {
    _textController.text = initialValueName ?? '';
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String searchQuery = '';
        List<dynamic> filteredData = mappedData!;
        ScreenDimensions dimensions = ScreenDimensions.fromContext(context);
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Row(
                children: [
                  Text('Select Option'),
                  SizedBox(
                    width: dimensions.width * 0.26,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Icon(
                        Icons.cancel,
                        color: Colors.red,
                        size: 35,
                      ),
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _textController,
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                          filteredData = mappedData
                              .where((item) => item["opt_name"]
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchQuery.toLowerCase()))
                              .toList();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Search",
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(),
                        ),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    if (filteredData.isEmpty)
                      Text("No data available")
                    else
                      Container(
                        height: MediaQuery.of(context).size.height * 0.35,
                        color: Colors
                            .grey[200], // Optional: Add a background color
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical:
                                  8.0), // Optional: Add padding around the content
                          child: SingleChildScrollView(
                            child: Column(
                              children: filteredData.map<Widget>((item) {
                                return ListTile(
                                  title: Text(item["opt_name"].toString()),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    if (onChanged != null) {
                                      onChanged(item["opt_id"].toString(),
                                          item["opt_name"].toString());
                                    }
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

//// bottom banner
final ValueNotifier<double?> latitudeNotifier = ValueNotifier<double?>(null);
final ValueNotifier<double?> longitudeNotifier = ValueNotifier<double?>(null);
final ValueNotifier<double?> pathNotifier = ValueNotifier<double?>(null);

class ImageSelectionWidget extends StatefulWidget {
  final Function(double, double, String?)? onLocationSelected;
  final String? initialImagePath;
  final String? initialImageBase64; // New field for base64 string

  ImageSelectionWidget({
    this.onLocationSelected,
    this.initialImagePath,
    this.initialImageBase64, // Initialize in constructor
  });
  @override
  _ImageSelectionWidgetState createState() => _ImageSelectionWidgetState();
}

class _ImageSelectionWidgetState extends State<ImageSelectionWidget> {
  bool _isImagePicked = false;
  late File _pickedImage;
  late Directory _tempDir;
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    initializeTempDir();

    if (widget.initialImagePath != null) {
      _pickedImage = File(widget.initialImagePath!);
      _isImagePicked = true;
    }
  }

  Future<void> initializeTempDir() async {
    _tempDir = await getApplicationDocumentsDirectory();
  }

  Future<List<double>> getLocation() async {
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    return [position.latitude, position.longitude];
  }

  Future<File?> addWatermark(
    List<int> imgBytes,
    double latitude,
    double longitude,
  ) async {
    final String latLon = 'Latitude: $latitude\nLongitude: $longitude';
    final Uint8List watermarkedImg = await ImageWatermark.addTextWatermark(
      imgBytes: Uint8List.fromList(imgBytes),
      watermarkText: latLon,
      dstX: 40,
      dstY: 350,
      font: ui.arial_24,
      color: Colors.white,
    );

    final Random random = Random();
    final int randomNumber = random.nextInt(100000);
    final String filePath = '${_tempDir.path}/image$randomNumber.png';
    final File file = File(filePath);
    await file.writeAsBytes(watermarkedImg);
    savingTheImage(file.path, latitude, longitude);
    return file;
  }

  void savingTheImage(String path, double latitude, double longitude) {
    final random = Random().nextInt(100000);
    final String fileName = 'image$random.png';
    final File savedFile = File('${_tempDir.path}/$fileName');
    final File originalFile = File(path);

    originalFile.copySync(savedFile.path);
  }

  Future<void> pickImage() async {
    EasyLoading.show(status: 'Loading...');
    final ImagePicker picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 480, // Reduced from 720
      maxHeight: 320, // Reduced from 480
      imageQuality: 80,
    );

    if (pickedImage != null) {
      final List<double> location = await getLocation();
      _latitude = location[0];
      _longitude = location[1];
      final List<int> imageBytes = await pickedImage.readAsBytes();
      final File? file =
          await addWatermark(imageBytes, _latitude!, _longitude!);

      if (file != null) {
        setState(() {
          _isImagePicked = true;
          _pickedImage = file;
        });
      }
      if (widget.onLocationSelected != null) {
        widget.onLocationSelected!(_latitude!, _longitude!, _pickedImage.path);
      }
    }
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    final imageWidget = _isImagePicked
        ? Image.file(
            _pickedImage,
            height: 150,
            width: 150,
            fit: BoxFit.cover,
          )
        : (widget.initialImageBase64 != null
            ? Image.memory(
                base64Decode(widget.initialImageBase64!),
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              )
            : Container(
                padding: EdgeInsets.all(20),
                child: Image.asset(
                  "lib/assets/addImage.png",
                  scale: 5,
                ),
              ));

    return GestureDetector(
      onTap: () async {
        await pickImage();
      },
      child: Container(
        child: imageWidget,
      ),
    );
  }
}

//// bottom banner

Widget nicBottomBar() {
  //how is its size determined???
  return Container(
    child: Image.asset(
      'lib/assets/bottomLogo.png',
    ),
  );
}

// class FileInputField extends StatefulWidget {
//   final String fieldName;
//   final bool isRequired;
//   final ValueChanged<String>? onFileSelected;
//   final bool readOnly;
//   final String? initialValue;
//   final TextInputType keyboardType;
//   final Color fillColor;
//   final List<String>? allowedExtensions; // Add this line

//   const FileInputField({
//     Key? key,
//     required this.fieldName,
//     this.isRequired = true,
//     this.onFileSelected,
//     this.readOnly = false,
//     this.initialValue,
//     this.keyboardType = TextInputType.text,
//     this.fillColor = Colors.white,
//     this.allowedExtensions, // Add this line
//   }) : super(key: key);

//   @override
//   State<FileInputField> createState() => _FileInputFieldState();
// }

// class _FileInputFieldState extends State<FileInputField> {
//   String? selectedFileName;

//   @override
//   void initState() {
//     super.initState();
//     selectedFileName = widget.initialValue;
//   }

//   Future<void> _pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: widget.allowedExtensions, // Use the allowedExtensions
//     );

//     if (result != null) {
//       PlatformFile file = result.files.first;
//       if (file.name != null) {
//         setState(() {
//           selectedFileName = file.name;
//         });
//         if (widget.onFileSelected != null && file.path != null) {
//           widget.onFileSelected!(file.path!);
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: widget.readOnly ? null : _pickFile,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//         decoration: BoxDecoration(
//           color: widget.fillColor,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: Colors.black),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Text(
//                 selectedFileName ?? widget.fieldName,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: selectedFileName != null ? Colors.black : Colors.grey,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             Icon(Icons.file_upload),
//           ],
//         ),
//       ),
//     );
//   }
// }
