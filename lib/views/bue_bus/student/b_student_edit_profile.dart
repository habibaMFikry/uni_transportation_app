import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../car_pooling/widgets/custom_text_field.dart';
import '../cubits/b_get_student_info_cubit/b_get_student_info_cubit.dart';
import '../models/b_student.dart';

class BStudentEditProfile extends StatefulWidget {
  static const routeName = 'b-student-edit-profile';
  const BStudentEditProfile({super.key});

  @override
  State<BStudentEditProfile> createState() => _BStudentEditProfileState();
}

class _BStudentEditProfileState extends State<BStudentEditProfile> {
  final GlobalKey<FormState> registerKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BGetStudentInfoCubit, BGetStudentInfoState>(
      builder: (context, state) {
        final BStudent student =
            BlocProvider.of<BGetStudentInfoCubit>(context).studentData;
        //print(student);
        return Scaffold(backgroundColor: const Color(0xffFFF9E1),
          appBar: AppBar(backgroundColor: const Color(0xffFFF9E1),
          iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: const Text('Update Information',style: TextStyle(color: Colors.black),
          ),
       ),
          body: Align(alignment: Alignment.center,
            child: Card
            ( elevation: 15,
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
                              initialValue: student.firstName,
                              onChanged: (value) {
                                student.firstName = value;
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
                              initialValue: student.lastName,
                              onChanged: (value) {
                                student.lastName = value;
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
                              initialValue: student.phoneNumber,
                              onChanged: (value) {
                                student.phoneNumber = value;
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
                              final BStudent studentModel = BStudent(
                                firstName: student.firstName,
                                lastName: student.lastName,
                                email: student.email,
                                phoneNumber: student.phoneNumber,
                              );
            
                              BlocProvider.of<BGetStudentInfoCubit>(context)
                                  .editStudentInfo(studentModel);
                              BlocProvider.of<BGetStudentInfoCubit>(context)
                                  .getStudentInfo();
                              Navigator.of(context).pop();
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
      },
    );
  }
}
