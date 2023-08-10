import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:location/location.dart' as loc;
import 'package:sizer/sizer.dart';

import '../cubits/cp_get_user_info_cubit/cp_get_user_info_cubit.dart';
import '../cubits/cp_ride_cubit/cp_ride_cubit.dart';
import '../models/cp_locations.dart';
import '../models/cp_ride.dart';
import 'cp_driver_start_ride_view.dart';
import 'services/location_service.dart';
import 'widgets/badge.dart' as badgeWidegt;

class CPDriverMapView extends StatefulWidget {
  static const routeName = '/cp-driver-map-view';
  final CpLocations location;
  const CPDriverMapView({super.key, required this.location});

  @override
  State<CPDriverMapView> createState() => _CPDriverMapViewState();
}

class _CPDriverMapViewState extends State<CPDriverMapView> {
  final Completer<GoogleMapController> _controller = Completer();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  static const LatLng initialLocation = LatLng(30.033333, 31.233334);

  Set<Marker> markers = <Marker>{};
  Set<Polyline> polyline = <Polyline>{};

  int polylineCounter = 1;

  TextEditingController timeController = TextEditingController();

  late Position currentPosition;
  var geoLocator = Geolocator();

  bool isPressed = false;
  final List<int> items = [1, 2, 3, 4];
  late int dropdownvalue = items[0];

  //loc.LocationData? currentLocation;

  /*void getLiveLocaion() async {
    loc.Location location = loc.Location();
    location.getLocation().then((location) {
      currentLocation = location;
    });
    final GoogleMapController controller = await _controller.future;
    location.onLocationChanged.listen((newLoc) {
      currentLocation = newLoc;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(newLoc.latitude!, newLoc.longitude!),
            zoom: 16,
          ),
        ),
      );
      setState(() {});
    });
  }*/

  Future<void> goToPlace(
    double lat,
    double lng,
    Map<dynamic, dynamic> boundNe,
    Map<dynamic, dynamic> boundSw,
  ) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, lng),
          zoom: 14,
        ),
      ),
    );
    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(boundSw['lat'], boundSw['lng']),
            northeast: LatLng(boundNe['lat'], boundNe['lng']),
          ),
          25),
    );
    setMarker(LatLng(lat, lng));
  }

  void setPolyline(List<PointLatLng> points) {
    final String polylineId = 'polyline$polylineCounter';
    polylineCounter++;
    polyline.add(
      Polyline(
        polylineId: PolylineId(polylineId),
        width: 2,
        color: Colors.blue,
        points: points
            .map(
              (point) => LatLng(point.latitude, point.longitude),
            )
            .toList(),
      ),
    );
  }

  void setMarker(LatLng point) {
    setState(() {
      markers.add(
        Marker(markerId: const MarkerId('marker'), position: point),
      );
    });
  }

  void setMarker2(LatLng point) {
    setState(() {
      markers.add(
        Marker(
          markerId: const MarkerId('marker2'),
          position: point,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue,
          ),
        ),
      );
    });
  }

  void getLine(CpLocations location) async {
    var directions = await LocationService().getDirections(
      location.startLocation,
      location.destinationLocation,
    );
    goToPlace(
      directions['start_location']['lat'],
      directions['start_location']['lng'],
      directions['bounds_ne'],
      directions['bounds_sw'],
    );
    polyline.clear();
    setPolyline(directions['polyline_decoded']);
    setMarker2(LatLng(
      directions['end_location']['lat'],
      directions['end_location']['lng'],
    ));
  }

  @override
  void initState() {
    BlocProvider.of<CpRideCubit>(context);
   // getLine(widget.location);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DocumentReference rideRef = FirebaseFirestore.instance
        .collection('Carpooling rides')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    List<dynamic> passengersList = [];

    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xffFFF9E1),
          iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: const Text('Driver',style: TextStyle(color: Colors.black),
          ),
        actions: [
          isPressed
              ? StreamBuilder(
                  stream: rideRef.snapshots(),
                  builder: (context, snapshot) {
                    var rideDoc = snapshot.data;
                    if (rideDoc != null) {
                      passengersList = rideDoc['passengers'] ?? [];
                    }
                    return badgeWidegt.Badge(
                      value: passengersList.isEmpty
                          ? '0'
                          : passengersList.length.toString(),
                      child: IconButton(
                        onPressed: () {
                          BlocProvider.of<CpGetUserInfoCubit>(context)
                              .getUserInfo();
                          BlocProvider.of<CpRideCubit>(context).getDriverRide();
                          Navigator.of(context)
                              .pushNamed(CpDriverStartRide.routeName);
                        },
                        icon: const Icon(Icons.person),
                      ),
                    );
                  })
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                  'Enter Start Time and Number of Seats'),
                              actions: [
                                StatefulBuilder(
                                  builder: (context, setState) {
                                    return Column(
                                      children: [
                                        Card(
                                          elevation: 15,
                                          margin: EdgeInsets.symmetric(
                                            vertical: 0.75.h,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10, top: 7),
                                            child: TextFormField(
                                              controller: timeController,
                                              keyboardType:
                                                  TextInputType.datetime,
                                              decoration: const InputDecoration(
                                                  labelText: 'Start Time',
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  border: InputBorder.none),
                                            ),
                                          ),
                                        ),
                                        Card(
                                          elevation: 15,
                                          margin: EdgeInsets.symmetric(
                                            vertical: 0.15.h,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(9.0),
                                            child: Row(
                                                children: [
                                                  const Text('Number Of Seats: '),
                                                  Padding(
                                                    padding: const EdgeInsets.all(20.0),
                                                    child: Column(
                                                        children: [
                                                          DropdownButton(
                                                            value: dropdownvalue,
                                                            icon: const Icon(Icons
                                                                .keyboard_arrow_down),
                                                            items: items
                                                                .map((int items) {
                                                              return DropdownMenuItem(
                                                                value: items,
                                                                child: Text(items
                                                                    .toString()),
                                                              );
                                                            }).toList(),
                                                            onChanged:
                                                                (int? newValue) {
                                                              setState(() {
                                                                dropdownvalue =
                                                                    newValue!;
                                                              });
                                                            },
                                                          ),
                                                        ]),
                                                  ),
                                                ]),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black
                                          ),
                                          onPressed: () async {
                                            if (timeController
                                                .text.isNotEmpty) {
                                              final navigator =
                                                  Navigator.of(context);
                                              final cubit =
                                                  BlocProvider.of<CpRideCubit>(
                                                      context);
                                              //getLiveLocaion();
                                              final CpRide rideModel = CpRide(
                                                startLocation: widget
                                                    .location.startLocation,
                                                rideTime: timeController.text,
                                                destinationLocation: widget
                                                    .location
                                                    .destinationLocation,
                                                price: widget.location.price,
                                                nOfSeatsAvailable:
                                                    dropdownvalue,
                                              );
                                              cubit.saveRide(
                                                  rideModel: rideModel);
                                              FirebaseFirestore.instance
                                                  .collection(
                                                      'Carpooling users')
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.uid)
                                                  .update({
                                                'number of seats available':
                                                    dropdownvalue,
                                              });

                                              navigator.pop();
                                              setState(() {
                                                isPressed = true;
                                              });
                                            }
                                          },
                                          child: const Text('Create Ride'), 
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    child: const Text(
                      'Create Ride',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
        zoomControlsEnabled: false,
        zoomGesturesEnabled: true,
        initialCameraPosition: const CameraPosition(
          target: initialLocation,
          zoom: 13,
        ),
        polylines: polyline,
        markers: markers,
      ),
    );
  }
}
