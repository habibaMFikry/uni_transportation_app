import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String title;
  final Widget? suffixWidget;
  final String? Function(String?)? validator;
  final bool isObscureText;
  final TextEditingController? textController;
  final TextInputType? keyboardType;
  final String? initialValue;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.title,
    this.suffixWidget,
    this.validator,
    this.isObscureText = false,
    this.textController,
    this.keyboardType,
    this.initialValue,
    this.onChanged,
  });

  OutlineInputBorder buildBorder([color]) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color ?? Colors.black87),
      borderRadius: BorderRadius.circular(20),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        onChanged: onChanged,
        initialValue: initialValue,
        keyboardType: keyboardType,
        controller: textController,
        obscureText: isObscureText,
        validator: validator,
        maxLines: 1,
        decoration: InputDecoration(
          suffixIcon: suffixWidget,
          labelText: title,
          labelStyle: const TextStyle(color: Colors.black),
          border: buildBorder(),
          focusedBorder: buildBorder(Colors.black),
        ),
      ),
    );
  }
}
