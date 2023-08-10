import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'cp_choose_user_view.dart';
import 'cp_register_view.dart';
import '../cubits/cp_login_cubit/cp_login_cubit.dart';
import '../cubits/cp_ride_cubit/cp_ride_cubit.dart';
import '../widgets/cp_login_text_fields.dart';
import '../widgets/custom_buttons.dart';

class CPLoginView extends StatefulWidget {
  static const routeName = '/cp-login-view';

  const CPLoginView({super.key});

  @override
  State<CPLoginView> createState() => _CPLoginViewState();
}

class _CPLoginViewState extends State<CPLoginView> {
  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CPLoginCubit, CPLoginState>(
      listener: (context, state) {
        if (state is CPLoginSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Account signed up successfully",
              ),
              duration: Duration(seconds: 2),
            ),
          );
          BlocProvider.of<CpRideCubit>(context).checkDriverRide();
          BlocProvider.of<CpRideCubit>(context).checkPassengerRide();
          FocusScope.of(context).unfocus();
          Navigator.of(context)
              .pushReplacementNamed(CPChooseUserView.routeName);
        }
        if (state is CPLoginFailure) {
          
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
                    CPLoginTextFields(
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
                          BlocProvider.of<CPLoginCubit>(context)
                              .cpLogin(email: email, password: password);
                        }
                      },
                      textButton2: 'Register',
                      onPressedButton2: () {
                        FocusScope.of(context).unfocus();
                        Navigator.of(context)
                            .pushReplacementNamed(CPRegisterview.routeName);
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
