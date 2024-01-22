import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:ride_requests/ride.dart';
import 'package:ride_requests/ride_requests.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Ride? _ride;
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    Ride? ride;
    try {
      final res = await getRideRequest();
      ride = resToRide(res);
    } on PlatformException {
      print('Fail to get ride');
    }

    _sub?.cancel();
    _sub = getRideRequestStream()?.listen((dynamic res) {
      Ride? ride = resToRide(res);
      if (!mounted) return;
      setState(() {
        _ride = ride;
      });
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _ride = ride;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Ride_requests example app'),
        ),
        body: Center(
          child: _ride == null
            ? Text("Ride is null")
            : Column(
              children: <Widget>[
                Text("Pickup:"),
                Text(_ride!.pickupFormattedAddress),
                Text(_ride!.pickupLatitude.toString()),
                Text(_ride!.pickupLongitude.toString()),
                Text(_ride!.pickupTitle),
                Divider(),
                Text("Dropoff:"),
                Text(_ride!.dropoffFormattedAddress),
                Text(_ride!.dropoffLatitude.toString()),
                Text(_ride!.dropoffLongitude.toString()),
                Text(_ride!.dropoffTitle),
              ],
            ),
        ),
      ),
    );
  }
}
