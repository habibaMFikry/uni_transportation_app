class CpLocations {
  final String startLocation;
  final num price;
  final String destinationLocation;

  CpLocations({
    required this.startLocation,
    required this.price,
    required this.destinationLocation,
  });

  factory CpLocations.fromJson(json) {
    return CpLocations(
      startLocation: json['Starting'] ?? '',
      destinationLocation: json['Destination'] ?? '',
      price: json['Price'] ?? '',
    );
  }
}
