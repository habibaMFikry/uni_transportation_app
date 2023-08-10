import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../car_pooling/widgets/custom_buttons.dart';
import '../cubits/b_register_cubit/b_register_cubit.dart';
import '../models/b_student.dart';
import 'b_student_login.dart';
import 'b_verification_view.dart';
import 'widgets/b_register_text_fields.dart';

class BStudentRegister extends StatefulWidget {
  static const routeName = '/b-student-register-view';

  const BStudentRegister({super.key});

  @override
  State<BStudentRegister> createState() => _BStudentRegisterState();
}

class _BStudentRegisterState extends State<BStudentRegister> {
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
    return BlocConsumer<BRegisterCubit, BRegisterState>(
      listener: (context, state) {
        if (state is BRegisterSuccess) {
          // Navigator.of(context)
          //     .pushReplacementNamed(BStudentBottomNav.routeName);
          Navigator.of(context).pushNamed(BVerificationView.routeName);
        }
        if (state is BRegisterFailure) {
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
      builder: (context, state) {
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
                  BRegisterTextFields(
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
                        final BStudent studentModel = BStudent(
                          firstName: nameController.text,
                          lastName: lastNameController.text,
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          phoneNumber: phoneController.text,
                        );

                        BlocProvider.of<BRegisterCubit>(context)
                            .bRegister(studentModel: studentModel);
                      }
                    },
                    textButton2: 'Login',
                    onPressedButton2: () {
                      Navigator.of(context)
                          .pushReplacementNamed(BStudentLogin.routeName);
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
