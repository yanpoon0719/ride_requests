import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ride_requests/ride.dart';
import 'package:ride_requests/ride_requests.dart';

void main() {
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
    Stream<Ride> stream = getRideRequestStream();
    expect(stream, isInstanceOf<Stream<Ride>>());
  });
}