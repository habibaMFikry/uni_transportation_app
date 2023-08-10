import 'package:flutter/material.dart';

import 'custom_text_field.dart';

class CPLoginTextFields extends StatefulWidget {
  final TextEditingController emailController;

  final TextEditingController passwordController;
  const CPLoginTextFields(
      {super.key,
      required this.emailController,
      required this.passwordController});

  @override
  State<CPLoginTextFields> createState() => _CPLoginTextFieldsState();
}

class _CPLoginTextFieldsState extends State<CPLoginTextFields> {
  bool isHiddenPass = true;

  void _togglePass() {
    setState(() {
      if (isHiddenPass == true) {
        isHiddenPass = false;
      } else {
        isHiddenPass = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          title: 'BUE email',
          textController: widget.emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please Enter Your Email';
            }
            return null;
          },
        ),
        CustomTextField(
          title: 'Password',
          textController: widget.passwordController,
          suffixWidget: InkWell(
            onTap: _togglePass,
            child: isHiddenPass
                ? const Icon(Icons.visibility_off,color: Colors.black,)
                : const Icon(Icons.visibility,color: Colors.black),
          ),
          isObscureText: isHiddenPass,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please Enter Your password';
            }
            return null;
          },
        ),
      ],
    );
  }
}
