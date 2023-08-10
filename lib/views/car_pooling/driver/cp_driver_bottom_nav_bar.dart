import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

import 'cp_driver_locations_view.dart';
import 'cp_driver_profile_view.dart';

class CpDriverBottomNavBar extends StatefulWidget {
  static const routeName = 'cp-bottom-nav-bar';
  const CpDriverBottomNavBar({super.key});

  @override
  State<CpDriverBottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<CpDriverBottomNavBar> {
  int index = 0;
  final views = [
    const CpDriverLocationsView(),
    const CpDriverProfileView(),
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
            title: const Text('Profile', textAlign: TextAlign.center,style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
