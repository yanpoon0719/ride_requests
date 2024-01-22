import 'dart:ffi';

class Ride {
  final String pickupFormattedAddress;
  final double pickupLatitude;
  final double pickupLongitude;
  final String pickupTitle;
  final String dropoffFormattedAddress;
  final double dropoffLatitude;
  final double dropoffLongitude;
  final String dropoffTitle;

  Ride({required this.pickupFormattedAddress, required this.pickupLatitude, required this.pickupLongitude, required this.pickupTitle, required this.dropoffFormattedAddress, required this.dropoffLatitude, required this.dropoffLongitude, required this.dropoffTitle});

  factory Ride.fromJson(Map<String, dynamic> json) {
    double? pickupLat = json['pickup_latitude'] is String? double.tryParse(json['pickup_latitude']):json['pickup_latitude'];
    double? pickupLong = json['pickup_longitude'] is String? double.tryParse(json['pickup_longitude']):json['pickup_longitude'];

    double? dropoffLat = json['dropoff_latitude'] is String? double.tryParse(json['dropoff_latitude']):json['dropoff_latitude'];
    double? dropoffLong = json['dropoff_longitude'] is String? double.tryParse(json['dropoff_longitude']):json['dropoff_longitude'];
    return Ride(
      pickupFormattedAddress: json['pickup_formatted_address'],
      pickupLatitude: pickupLat?? 0,
      pickupLongitude: pickupLong?? 0,
      pickupTitle: json['pickup_title'],
      dropoffFormattedAddress: json['dropoff_formatted_address'],
      dropoffLatitude: dropoffLat?? 0,
      dropoffLongitude: dropoffLong?? 0,
      dropoffTitle: json['dropoff_title'],
    );
  }
}
