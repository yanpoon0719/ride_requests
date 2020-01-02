class Ride {
  final String pickupFormattedAddress;
  final double pickupLatitude;
  final double pickupLongitude;
  final String pickupTitle;
  final String dropoffFormattedAddress;
  final double dropoffLatitude;
  final double dropoffLongitude;
  final String dropoffTitle;

  Ride({this.pickupFormattedAddress, this.pickupLatitude, this.pickupLongitude, this.pickupTitle, this.dropoffFormattedAddress, this.dropoffLatitude, this.dropoffLongitude, this.dropoffTitle});

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      pickupFormattedAddress: json['pickup_formatted_address'],
      pickupLatitude: json['pickup_latitude'],
      pickupLongitude: json['pickup_longitude'],
      pickupTitle: json['pickup_title'],
      dropoffFormattedAddress: json['dropoff_formatted_address'],
      dropoffLatitude: json['dropoff_latitude'],
      dropoffLongitude: json['dropoff_longitude'],
      dropoffTitle: json['dropoff_title'],
    );
  }
}
