import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../car_pooling/widgets/custom_buttons.dart';
import '../cubits/b_login_cubit/b_login_cubit.dart';
import '../cubits/b_ride_cubit/b_ride_cubit.dart';
import '../models/b_driver.dart';
import '../models/b_ride.dart';
import 'b_student_bottom_nav.dart';
import 'b_student_register.dart';
import 'b_student_start_ride.dart';
import 'widgets/b_login_text_fields.dart';

class BStudentLogin extends StatefulWidget {
  static const routeName = '/b-student-login-view';

  const BStudentLogin({super.key});

  @override
  State<BStudentLogin> createState() => _CPLoginViewState();
}

class _CPLoginViewState extends State<BStudentLogin> {
  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BLoginCubit, BLoginState>(
      listener: (context, state) async {
        var rideCubit = BlocProvider.of<BRideCubit>(context);
        var nav = Navigator.of(context);
        var scaffold = ScaffoldMessenger.of(context);
        if (state is BLoginSuccess) {
          scaffold.showSnackBar(
            const SnackBar(
              content: Text(
                "Account signed up successfully",
              ),
              duration: Duration(seconds: 2),
            ),
          );

          await rideCubit.checkStudentRide();
          final bool pHasRide = rideCubit.pHasRide;

          final BDriver driverInfo = rideCubit.driver;
          final BRide passRide = rideCubit.passRide;
          if (pHasRide) {
            nav.pushReplacement(
              MaterialPageRoute(
                builder: (builder) {
                  return BStudentStartRide(driver: driverInfo, ride: passRide);
                },
              ),
            );
          } else {
            nav.pushReplacementNamed(BStudentBottomNav.routeName);
          }
        }
        if (state is BLoginFailure) {
          scaffold.showSnackBar(
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
            title: const Text('Hello again!',style: TextStyle(color: Colors.black),),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: loginKey,
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    BLoginTextFields(
                      emailController: emailController,
                      passwordController: passwordController,
                    ),
                    SizedBox(height: 5.h),
                    CustomButtons(
                      textButton1: 'Login',
                      onPressedButton1: () {
                        if (loginKey.currentState!.validate()) {
                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();
                          BlocProvider.of<BLoginCubit>(context)
                              .bLogin(email: email, password: password);
                        }
                      },
                      textButton2: 'Register',
                      onPressedButton2: () {
                        Navigator.of(context)
                            .pushReplacementNamed(BStudentRegister.routeName);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
