import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

import 'cp_passenger_locations_view.dart';
import 'cp_passenger_profile_view.dart';

class CpPassengerBottomNav extends StatefulWidget {
  static const routeName = '/cp-passenger-bottom-nav';
  const CpPassengerBottomNav({super.key});

  @override
  State<CpPassengerBottomNav> createState() => _CpPassengerBottomNavState();
}

class _CpPassengerBottomNavState extends State<CpPassengerBottomNav> {
  int index = 0;
  final views = [
    const CpPassengerLocations(),
    const CpPassengerProfile(),
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
