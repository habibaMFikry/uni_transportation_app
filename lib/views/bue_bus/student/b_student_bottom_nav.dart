import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

import 'b_student_locations.dart';
import 'b_student_profile.dart';

class BStudentBottomNav extends StatefulWidget {
  static const routeName = '/b-student-bottom-nav';
  const BStudentBottomNav({super.key});

  @override
  State<BStudentBottomNav> createState() => _BStudentBottomNavState();
}

class _BStudentBottomNavState extends State<BStudentBottomNav> {
  int index = 0;
  final views = [
    const BStudentLocations(),
    const BStudentProfile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: views[index],
      bottomNavigationBar: BottomNavyBar(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        selectedIndex: index,
        onItemSelected: (index) => setState(() {
          this.index = index;
        }),
        items: [
          BottomNavyBarItem(
            icon: const Icon(Icons.home,color: Colors.black,),
            title: const Text('Home', textAlign: TextAlign.center,style: TextStyle(color: Colors.black),),
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.person,color: Colors.black,),
            title: const Text('Profile', textAlign: TextAlign.center,style: TextStyle(color: Colors.black),),
          ),
          
        ],
      ),
    );
  }
}
