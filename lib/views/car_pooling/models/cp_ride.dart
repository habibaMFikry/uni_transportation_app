import 'package:firebase_auth/firebase_auth.dart';

class CpRide {
  final String? driverID;
  final String startLocation;
  final String rideTime;
  final String destinationLocation;
  final num? price;
  final num? nOfSeatsAvailable;
  final dynamic passengers;
  final List<dynamic>? passTokens;
  final bool rideStarted;

  CpRide({
    this.rideStarted = false,
    this.passTokens,
    this.passengers,
    this.nOfSeatsAvailable,
    this.driverID,
    this.price,
    required this.startLocation,
    required this.rideTime,
    required this.destinationLocation,
  });

  toJson() {
    return {
      'driverID': FirebaseAuth.instance.currentUser!.uid,
      'start location': startLocation,
      'ride time': rideTime,
      'destination location': destinationLocation,
      'price': price,
      'number of seats available': nOfSeatsAvailable,
      'passengers': passengers,
      'passengers tokens': passTokens,
      'ride started': rideStarted,
    };
  }

  factory CpRide.fromJson(json) {
    return CpRide(
      driverID: json['driverID'] ?? '',
      startLocation: json['start location'] ?? '',
      rideTime: json['ride time'] ?? 0,
      destinationLocation: json['destination location'] ?? '',
      price: json['price'] ?? 0,
      nOfSeatsAvailable: json['number of seats available'] ?? 0,
      passengers: json['passengers'],
      passTokens: json['passengers tokens'],
      rideStarted: json['ride started'],
    );
  }
}
