import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'cp_login_view.dart';
import '../cubits/cp_register_cubit/cp_register_cubit.dart';
import '../models/cp_user.dart';
import '../widgets/cp_register_text_fields.dart';
import '../widgets/custom_buttons.dart';
import 'cp_verification_view.dart';

class CPRegisterview extends StatefulWidget {
  static const routeName = '/cp-register-view';

  const CPRegisterview({super.key});

  @override
  State<CPRegisterview> createState() => _CPRegisterviewState();
}

class _CPRegisterviewState extends State<CPRegisterview> {
  final GlobalKey<FormState> registerKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CPRegisterCubit, CPRegisterState>(
      listener: (context, state) {
        if (state is CPRegisterSuccess) {
          FocusScope.of(context).unfocus();
          // Navigator.of(context)
          //     .pushReplacementNamed(CPChooseUserView.routeName);
          Navigator.of(context).pushNamed(CpVerificationView.routeName);
        }
        if (state is CPRegisterFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage,
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      builder: (BuildContext context, state) {
        return Scaffold(
          backgroundColor: const Color(0xffFFF9E1),
          appBar: AppBar(backgroundColor: const Color(0xffFFF9E1),
          iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: const Text('Create your account',style: TextStyle(color: Colors.black),),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: registerKey,
              child: ListView(
                physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
                children: [
                  CPRegisterTextFields(
                    nameController: nameController,
                    lastNameController: lastNameController,
                    emailController: emailController,
                    phoneController: phoneController,
                    passwordController: passwordController,
                    confirmPasswordController: confirmPasswordController,
                  ),
                  SizedBox(height: 4.h),
                  CustomButtons(
                    textButton1: 'Register',
                    onPressedButton1: () {
                      if (registerKey.currentState!.validate()) {
                        final CpUser userModel = CpUser(
                          firstName: nameController.text,
                          lastName: lastNameController.text,
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          phoneNumber: phoneController.text,
                        );

                        BlocProvider.of<CPRegisterCubit>(context)
                            .cpRegister(userModel: userModel);
                      }
                    },
                    textButton2: 'Login',
                    onPressedButton2: () {
                      FocusScope.of(context).unfocus();
                      Navigator.of(context)
                          .pushReplacementNamed(CPLoginView.routeName);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
