import 'dart:async';

import 'package:flutter/services.dart';
import 'package:ride_requests/ride.dart';

const MethodChannel _mChannel = const MethodChannel('ride_requests/ride');
const EventChannel _eChannel = const EventChannel('ride_requests/stream');
Stream<dynamic>? _stream;

Future<dynamic> getRideRequest() async {
  final res = await _mChannel.invokeMethod('getRideRequest');
  return res;
}

Stream<dynamic>? getRideRequestStream() {
  if (_stream == null) {
    return _stream = _eChannel.receiveBroadcastStream();
  }
  return _stream;
}

Ride? resToRide(dynamic res) {
  try {
    final json = Map<String, dynamic>.from(res);
    final Ride rideRequest = Ride.fromJson(json);
    return rideRequest;
  } catch (e) {
    return null;
  }
}