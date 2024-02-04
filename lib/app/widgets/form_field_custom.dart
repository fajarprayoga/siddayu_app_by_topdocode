import 'package:flutter/material.dart';
import 'package:todo_app/app/core/constants/value.dart';

class FormFieldCustom extends StatelessWidget {
  final String title;
  final String placeholder;
  final double? width;
  final IconData? icon;
  final bool? isMultiLine;
  final String? type;
  final TextStyle? titleStyle;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final dynamic initialValue;
  final void Function(String)? onChanged;

  const FormFieldCustom(
      {super.key,
      required this.placeholder,
      required this.title,
      this.titleStyle,
      this.icon,
      this.width,
      this.isMultiLine,
      this.type = 'TEXT',
      this.controller,
      this.keyboardType,
      this.onChanged,
      this.initialValue});

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      // Handle the selected date value
      DateTime localPicked = picked.toLocal(); // Convert to local time
      String formattedDate =
          localPicked.toString().split(' ')[0]; // Get only the date part
      controller?.text =
          formattedDate; // Update the text field with the formatted date
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != '') Text(title, style: titleStyle),
          const SizedBox(
            height: gap - 2,
          ),
          if (type == 'TEXT')
            TextFormField(
              validator: (String? arg) {
                if (arg!.length < 3) {
                  return 'Text must be more than 2 characters';
                }
                return null;
              },
              controller: controller,
              initialValue: initialValue,
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: const TextStyle(color: Colors.black38),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black26,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: primary, width: 2),
                  borderRadius: BorderRadius.circular(5.5),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 13.0, horizontal: padding),
                prefixIcon: icon != null ? Icon(icon) : null,
              ),
              maxLines: null,
              minLines: isMultiLine ?? false ? 4 : 1,
              onSaved: (String? val) {
                // Handle the saved value for text type.
              },
              onChanged: onChanged,
              keyboardType: keyboardType ?? TextInputType.text,
            )
          else if (type == 'DATE')
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: placeholder,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(5.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: primary, width: 2),
                  borderRadius: BorderRadius.circular(5.5),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: padding,
                ),
                prefixIcon: icon != null ? Icon(icon) : null,
              ),
              maxLines: null,
              minLines: isMultiLine ?? false ? 4 : 1,
              onTap: () => _selectDate(context),
              readOnly: true, // Prevent manual text input
            ),
        ],
      ),
    );
  }
}
