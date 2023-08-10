import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

import 'b_driver_location.dart';
import 'b_driver_profile.dart';

class BDriverBottomNav extends StatefulWidget {
  static const routeName = '/b-driver-bottom-nav';
  const BDriverBottomNav({super.key});

  @override
  State<BDriverBottomNav> createState() => _BDriverBottomNavState();
}

class _BDriverBottomNavState extends State<BDriverBottomNav> {
  int index = 0;
  final views = [
    const BDriverLocation(),
    const BDriverProfile(),
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
