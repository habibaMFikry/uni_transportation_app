class BDriver {
  final int busId;
  final String name;
  final int password;
  final String phoneNumber;

  BDriver({
    required this.busId,
    required this.name,
    required this.password,
    required this.phoneNumber,
  });

  factory BDriver.fromJson(json) {
    return BDriver(
        busId: json['BusId'],
        name: json['Name'],
        password: json['Password'],
        phoneNumber: json['Phone Number']);
  }
}
