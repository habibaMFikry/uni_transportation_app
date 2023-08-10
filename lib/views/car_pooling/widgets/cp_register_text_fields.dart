import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class CPRegisterTextFields extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const CPRegisterTextFields(
      {super.key,
      required this.nameController,
      required this.lastNameController,
      required this.emailController,
      required this.phoneController,
      required this.passwordController,
      required this.confirmPasswordController});

  @override
  State<CPRegisterTextFields> createState() => _CPRegisterTextFieldsState();
}

class _CPRegisterTextFieldsState extends State<CPRegisterTextFields> {
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          title: 'First Name',
          textController: widget.nameController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please Enter Your Name';
            } else if (value.length > 12) {
              return 'Name Must be less than 12 characters';
            }
            return null;
          },
        ),
        CustomTextField(
          title: 'Last Name',
          textController: widget.lastNameController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please Enter Your Name';
            } else if (value.length > 12) {
              return 'Name Must be less than 12 characters';
            }
            return null;
          },
        ),
        CustomTextField(
          title: 'Email',
          textController: widget.emailController,
          keyboardType: TextInputType.emailAddress,
          validator:  (value){if (value!.isEmpty) {
              return 'Please Enter Your Email';
            } else if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9+_.-]+.[com]")
                .hasMatch(value)) {
              return 'Please Enter Valid email as example@gmail.com';
            }
            return null;
          }
        ),
        CustomTextField(
          title: 'Phone Number',
          textController: widget.phoneController,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please Enter Your Phone Number';
            } else if (value.length != 11) {
              return "Phone Number Must be 11 Number";
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
                ? const Icon(Icons.visibility_off,color: Colors.black)
                : const Icon(Icons.visibility,color: Colors.black),
          ),
          isObscureText: isHiddenPass,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please Enter Your Password';
            }
            if (value.length < 5) {
              return 'Password is too short';
            }
            return null;
          },
        ),
        CustomTextField(
          title: 'Confirm password',
          textController: widget.confirmPasswordController,
          suffixWidget: InkWell(
            onTap: _togglePass,
            child: isHiddenPass
                ? const Icon(Icons.visibility_off,color: Colors.black)
                : const Icon(Icons.visibility,color: Colors.black),
          ),
          isObscureText: isHiddenPass,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please Enter Your Confirm Password';
            }
            if (value != widget.passwordController.text) {
              return 'Passwords do not match!';
            }
            return null;
          },
        ),
      ],
    );
  }
}
