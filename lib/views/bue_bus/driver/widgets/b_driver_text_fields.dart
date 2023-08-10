import 'package:flutter/material.dart';

import '../../../car_pooling/widgets/custom_text_field.dart';

class BDriverTextFields extends StatefulWidget {
  final TextEditingController emailController;

  final TextEditingController passwordController;
  const BDriverTextFields(
      {super.key,
      required this.emailController,
      required this.passwordController});

  @override
  State<BDriverTextFields> createState() => _BDriverTextFieldsState();
}

class _BDriverTextFieldsState extends State<BDriverTextFields> {
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
          title: 'Bus ID',
          textController: widget.emailController,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please Enter Your Bus ID';
            }
            return null;
          },
        ),
        CustomTextField(
          title: 'Password',
          textController: widget.passwordController,
          keyboardType: TextInputType.number,
          suffixWidget: InkWell(
            onTap: _togglePass,
            child: isHiddenPass
                ? const Icon(Icons.visibility_off,color: Colors.black)
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
