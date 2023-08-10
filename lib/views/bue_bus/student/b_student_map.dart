import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_geocoder/location_geocoder.dart';

import '../cubits/b_get_student_info_cubit/b_get_student_info_cubit.dart';
import '../cubits/b_ride_cubit/b_ride_cubit.dart';
import '../driver/services/b_location_service.dart';
import '../models/b_driver.dart';
import '../models/b_locations.dart';
import '../models/b_ride.dart';
import '../models/b_student.dart';
import 'b_student_start_ride.dart';

class BStudentMap extends StatefulWidget {
  static const routeName = 'b-student-Map';
  final BLocations location;
  const BStudentMap({super.key, required this.location});

  @override
  State<BStudentMap> createState() => _BStudentMapState();
}

class _BStudentMapState extends State<BStudentMap> {
  final String mapApiKey = 'AIzaSyDZjAlxAZNL5-MqDdXPz2L7UNEDmTTS6Ws';

  static const LatLng initialLocation = LatLng(30.033333, 31.233334);
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = <Marker>{};
  Set<Polyline> polyline = <Polyline>{};
  int polylineCounter = 1;

  final List<LatLng> points = [];

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

  void setMarker(String place, String marker) async {
    final LocatitonGeocoder geocoder = LocatitonGeocoder(mapApiKey);
    final address = await geocoder.findAddressesFromQuery(place);
    var lat = address.first.coordinates.latitude;
    var lng = address.first.coordinates.longitude;
    setState(() {
      markers.add(
        Marker(
          markerId: MarkerId(marker),
          position: LatLng(lat!, lng!),
        ),
      );
    });
  }

  void getLine(String startLoc, dynamic stopPoint) async {
    var directions =
        await BLocationService().getDirections(startLoc, stopPoint);
    goToPlace(
      directions['start_location']['lat'],
      directions['start_location']['lng'],
      directions['bounds_ne'],
      directions['bounds_sw'],
    );
    setState(() {
      setPolyline(directions['polyline_decoded']);
    });
  }

  @override
  void initState() {
    setMarker(widget.location.startLocation, 'start');
    setMarker(widget.location.stopPoints[0], 'sp1');
    setMarker(widget.location.stopPoints[1], 'sp2');
    setMarker(widget.location.stopPoints[2], 'sp3');
    setMarker(widget.location.destinationLocation, 'des');

    getLine(widget.location.startLocation, widget.location.stopPoints[0]);
    getLine(widget.location.stopPoints[0], widget.location.stopPoints[1]);
    getLine(widget.location.stopPoints[1], widget.location.stopPoints[2]);
    getLine(widget.location.stopPoints[2], widget.location.destinationLocation);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BRide ride = BlocProvider.of<BRideCubit>(context).ride;
    BDriver driver = BlocProvider.of<BRideCubit>(context).driver;
    BStudent student =
        BlocProvider.of<BGetStudentInfoCubit>(context).studentData;

    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xffFFF9E1),
          iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: const Text('Map',style: TextStyle(color: Colors.black),
          ),
        actions: [ ride.busID !=0 ?
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('Bus_rides')
                    .doc(driver.busId.toString())
                    .update({
                  'students': FieldValue.arrayUnion([
                    {
                      'uid': student.userId,
                      'first name': student.firstName,
                      'last name': student.lastName,
                      'email': student.email,
                      'phone number': student.phoneNumber,
                      //'on ride': false,
                    },
                  ]),
                  'number of seats available': ride.nOfSeatsAvailable - 1,
                });
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return BStudentStartRide(driver: driver, ride: ride);
                }));
              },
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ): const Center(),
        ],
      ),
      body: ride.busID != 0
          ? 
          GoogleMap(
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
              markers:
                  markers,
            )
          // })
          : const Center(
              child: Text('No rides'),
            ),
      //);
      // },
    );
  }
}
