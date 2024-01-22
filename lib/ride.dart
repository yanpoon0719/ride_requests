import 'dart:ffi';

class Ride {
  final String? pickupFormattedAddress;
  final double? pickupLatitude;
  final double? pickupLongitude;
  final String? pickupTitle;
  final String? dropoffFormattedAddress;
  final double? dropoffLatitude;
  final double? dropoffLongitude;
  final String? dropoffTitle;

  Ride({this.pickupFormattedAddress, this.pickupLatitude, this.pickupLongitude, this.pickupTitle, this.dropoffFormattedAddress, this.dropoffLatitude, this.dropoffLongitude, this.dropoffTitle});

  factory Ride.fromJson(Map<String, dynamic> json) {
    double? pickupLat = json['pickup_latitude'] is String? double.tryParse(json['pickup_latitude']):json['pickup_latitude'];
    double? pickupLong = json['pickup_longitude'] is String? double.tryParse(json['pickup_longitude']):json['pickup_longitude'];

    double? dropoffLat = json['dropoff_latitude'] is String? double.tryParse(json['dropoff_latitude']):json['dropoff_latitude'];
    double? dropoffLong = json['dropoff_longitude'] is String? double.tryParse(json['dropoff_longitude']):json['dropoff_longitude'];
    return Ride(
      pickupFormattedAddress: json['pickup_formatted_address'],
      pickupLatitude: pickupLat,
      pickupLongitude: pickupLong,
      pickupTitle: json['pickup_title'],
      dropoffFormattedAddress: json['dropoff_formatted_address'],
      dropoffLatitude: dropoffLat,
      dropoffLongitude: dropoffLong,
      dropoffTitle: json['dropoff_title'],
    );
  }
}
