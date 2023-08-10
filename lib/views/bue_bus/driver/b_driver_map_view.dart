import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_geocoder/location_geocoder.dart';
//import 'package:location/location.dart' as loc;

import '../../car_pooling/driver/widgets/badge.dart' as badgeWidegt;
import '../cubits/b_ride_cubit/b_ride_cubit.dart';
import '../models/b_locations.dart';
import '../models/b_ride.dart';
import 'b_driver_start_ride.dart';
import 'services/b_location_service.dart';

class BDriverMapView extends StatefulWidget {
  static const routeName = 'b-driver-map-view';
  final BLocations location;
  const BDriverMapView({super.key, required this.location});

  @override
  State<BDriverMapView> createState() => _BDriverMapViewState();
}

class _BDriverMapViewState extends State<BDriverMapView> {
  final String mapApiKey = 'AIzaSyDZjAlxAZNL5-MqDdXPz2L7UNEDmTTS6Ws';

  static const LatLng initialLocation = LatLng(30.033333, 31.233334);
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = <Marker>{};
  Set<Polyline> polyline = <Polyline>{};
  //loc.LocationData? currentLocation;
  int polylineCounter = 1;

  bool isPressed = false;

 
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
    var directions = await BLocationService().getDirections(
        startLoc,
        stopPoint);
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
    DocumentReference rideRef = FirebaseFirestore.instance
        .collection('Bus_rides')
        .doc(widget.location.busId.toString());

    List<dynamic> studentsList = [];

    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xffFFF9E1),
          iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            title: const Text('Map',style: TextStyle(color: Colors.black),
          ),
        actions: [
          isPressed
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: StreamBuilder(
                      stream: rideRef.snapshots(),
                      builder: (context, snapshot) {
                        var rideDoc = snapshot.data;
                        if (rideDoc != null) {
                          studentsList = rideDoc['students'] ?? [];
                        }
                        return badgeWidegt.Badge(
                          value: studentsList.isEmpty
                              ? '0'
                              : studentsList.length.toString(),
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                BDriverStartRide.routeName,
                                arguments: BLocations(
                                  busId: widget.location.busId,
                                  startLocation: widget.location.startLocation,
                                  stopPoints: widget.location.stopPoints,
                                  destinationLocation:
                                      widget.location.destinationLocation,
                                  availableSeats:
                                      widget.location.availableSeats,
                                      time: widget.location.time,
                                ),
                              );
                            },
                            icon: const Icon(Icons.person),
                          ),
                        );
                      }),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Create Ride',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      //getLiveLocaion();
                      BRide busRide = BRide(
                        busID: widget.location.busId,
                        startLocation: widget.location.startLocation,
                        stopPoints: widget.location.stopPoints,
                        destinationLocation:
                            widget.location.destinationLocation,
                            time: widget.location.time,
                      );
                      BlocProvider.of<BRideCubit>(context)
                          .saveRide(rideModel: busRide);
                      setState(() {
                        isPressed = true;
                      });
                    },
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
