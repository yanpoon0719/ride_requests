import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ride_requests/ride.dart';
import 'package:ride_requests/ride_requests.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel mChannel = const MethodChannel('ride_requests/ride');
  final List<MethodCall> log = <MethodCall>[];
  mChannel.setMockMethodCallHandler((MethodCall methodCall) async {
    log.add(methodCall);
  });

  tearDown(() {
    log.clear();
  });

  test('getRideRequest', () async {
    await getRideRequest();
    expect(
      log,
      <Matcher>[isMethodCall('getRideRequest', arguments: null)],
    );
  });

  test('getRideRequestStream', () async {
    Stream? stream = getRideRequestStream();
    expect(stream, isInstanceOf<Stream<dynamic>>());
  });

  test('resToRide', () async {
    Ride? r = resToRide(null);
    expect(r, isNull);
    r = resToRide({});
    expect(r?.pickupFormattedAddress, isNull);
    expect(r?.dropoffFormattedAddress, isNull);
    r = resToRide({
      'pickup_formatted_address': "1 Main Street, Central, HK",
      'pickup_latitude': "1.223311",
      'pickup_longitude': 12.23311,
      'pickup_title': "123 Building",
      'dropoff_formatted_address': "2 Second Street, Wan Chi, HK",
      'dropoff_latitude': "2.223311",
      'dropoff_longitude': 22.331122,
      'dropoff_title': "321 Building"
    });
    expect(r, isInstanceOf<Ride>());
    expect(r?.pickupLatitude, 1.223311);
  });
}