import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/cp_user.dart';
import '../widgets/custom_text_field.dart';
import '../cubits/cp_get_user_info_cubit/cp_get_user_info_cubit.dart';

class CpPassengerEditProfile extends StatefulWidget {
  static const routeName = 'cp-passenger-edit-profile';
  const CpPassengerEditProfile({super.key});

  @override
  State<CpPassengerEditProfile> createState() => _CpPassengerEditProfileState();
}

class _CpPassengerEditProfileState extends State<CpPassengerEditProfile> {
  final GlobalKey<FormState> registerKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final CpUser user =
        BlocProvider.of<CpGetUserInfoCubit>(context).userData; 

    return Scaffold(backgroundColor: const Color(0xffFFF9E1),
          appBar: AppBar(backgroundColor: const Color(0xffFFF9E1),
          iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: const Text('Update Information',style: TextStyle(color: Colors.black),
          ),
       ),
      
      body: Align(alignment: Alignment.center,
              child: Card(elevation: 15,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                child: Container(
                  height: MediaQuery.of(context).size.height*.55,
                        width: MediaQuery.of(context).size.width*.70,
                        decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                        ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: registerKey,
              child: ListView(
                physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Please enter your information.'),
                      const SizedBox(height: 10),
                      CustomTextField(
                        title: 'First Name',
                        initialValue: user.firstName,
                        onChanged: (value) {
                          user.firstName = value;
                        },
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
                        initialValue: user.lastName,
                        onChanged: (value) {
                          user.lastName = value;
                        },
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
                        title: 'Phone Number',
                        initialValue: user.phoneNumber,
                        onChanged: (value) {
                          user.phoneNumber = value;
                        },
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
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                     style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black
                    ),
                    onPressed: () {
                      if (registerKey.currentState!.validate()) {
                        final CpUser userModel = CpUser(
                          firstName: user.firstName,
                          lastName: user.lastName,
                          email: user.email,
                          phoneNumber: user.phoneNumber,
                        );
      
                        BlocProvider.of<CpGetUserInfoCubit>(context)
                            .editUserInfo(userModel);
                        BlocProvider.of<CpGetUserInfoCubit>(context).getUserInfo();
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Update'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
    );    
  }
}
