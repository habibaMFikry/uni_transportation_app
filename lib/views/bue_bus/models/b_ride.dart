class BRide {
  final int busID;
  final String startLocation;
  final dynamic stopPoints;
  final String destinationLocation;
  final num nOfSeatsAvailable;
  final dynamic students;
  final List<dynamic>? studentsTokens;
  final bool stopPoint1;
  final bool stopPoint2;
  final bool stopPoint3;
  final List<dynamic>? studentsOnBus;
  final String time;

  BRide({
    this.studentsOnBus,
    this.stopPoint1 = false,
    this.stopPoint2 = false,
    this.stopPoint3 = false,
    this.studentsTokens,
    this.students,
    this.nOfSeatsAvailable = 30,
    required this.busID,
    required this.startLocation,
    required this.stopPoints,
    required this.destinationLocation,
    required this.time,
  });

  toJson() {
    return {
      'busID': busID,
      'start location': startLocation,
      'stop points': stopPoints,
      'destination location': destinationLocation,
      'number of seats available': nOfSeatsAvailable,
      'students': students,
      'students tokens': studentsTokens,
      'stop point 1': stopPoint1,
      'stop point 2': stopPoint2,
      'stop point 3': stopPoint3,
      'students on bus': studentsOnBus,
      'Time': time,
    };
  }

  factory BRide.fromJson(json) {
    return BRide(
      busID: json['busID'] ?? '',
      startLocation: json['start location'] ?? '',
      stopPoints: json['stop points'],
      destinationLocation: json['destination location'] ?? '',
      nOfSeatsAvailable: json['number of seats available'] ?? 0,
      students: json['students'],
      studentsTokens: json['students tokens'],
      stopPoint1: json['stop point 1'],
      stopPoint2: json['stop point 2'],
      stopPoint3: json['stop point 3'],
      studentsOnBus: json['students on bus'],
      time: json['Time']?? '',
    );
  }
}
