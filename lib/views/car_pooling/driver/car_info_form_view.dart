import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import 'cp_driver_bottom_nav_bar.dart';

class CarInfoFormView extends StatefulWidget {
  static const routeName = '/car-info-form-view';
  const CarInfoFormView({super.key});

  @override
  State<CarInfoFormView> createState() => _CarInfoFormViewState();
}

class _CarInfoFormViewState extends State<CarInfoFormView> {
  final TextEditingController carTypeController = TextEditingController();
  final GlobalKey<FormState> carFormKey = GlobalKey<FormState>();
  String? carText;

  final List<int> items = [1, 2, 3, 4];
  late int dropdownvalue = items[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color(0xffFFF9E1),
          appBar: AppBar(backgroundColor: const Color(0xffFFF9E1),
          iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: const Text('Car Information',style: TextStyle(color: Colors.black),
          ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: Card(
          elevation: 15,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Container(
            height: MediaQuery.of(context).size.height * .30,
            width: MediaQuery.of(context).size.height * .40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Please Enter Your Car Brand',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Form(
                  key: carFormKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(children: [
                      CustomTextField(
                        title: 'Car Brand',
                        textController: carTypeController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter car Brand';
                          }
                          return null;
                        },
                      ),
                    ]),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                   style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black
                    ),
                  onPressed: () {
                    if (carFormKey.currentState!.validate()) {
                      FirebaseFirestore.instance
                          .collection('Carpooling users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({'car type': carTypeController.text});
                      Navigator.of(context)
                          .pushReplacementNamed(CpDriverBottomNavBar.routeName);
                    }
                  },
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}