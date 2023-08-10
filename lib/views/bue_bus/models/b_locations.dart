class BLocations {
  final int busId;
  final String startLocation;
  final dynamic stopPoints;
  final String destinationLocation;
  final num availableSeats;
  final String time;

  BLocations({
    required this.availableSeats,
    required this.busId,
    required this.startLocation,
    required this.stopPoints,
    required this.destinationLocation,
    required this.time,
  });

  factory BLocations.fromJson(json) {
    return BLocations(
      busId: json['BusId'],
      startLocation: json['Starting'] ?? '',
      destinationLocation: json['Destination'] ?? '',
      stopPoints: json['Stop Points'] ?? [],
      availableSeats: json['Available_Seats'] ?? 0,
      time: json['Time']??'',
    );
  }
}
