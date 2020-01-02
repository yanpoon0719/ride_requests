# Ride Requests

A flutter plugin projecet to help integrate Google Assistant and Sirikit to Flutter.

Google Assistant and Siri are voice assistant tools which help users to get a ride with specific intents/domains.

Make sure you read both the Installation and the Usage guides.

## Installation

To use the plugin, add ride_requests as a [dependency in your pubspec.yaml file.](https://flutter.io/platform-plugins/)

### Permission

Android and iOS require to declare permission in a configuration file.

Feel free to examine the example app in the example directory for Google Assistant (Android) and Siri (iOS).

The following steps are not Flutter specific, but platform specific. You might be able to find more in-depth guides elsewhere online, by searching about Google Assistant on Android or Siri on iOS.

### For Android

Google Assistant supports ride booking function with `RESERVE_TAXI_RESERVATION` intent.

First, set up [Google API services for Android](https://developers.google.com/android/guides/google-services-plugin).

Then, add `actions.xml` to android/app/src/main/res/xml/.

```xml
<?xml version="1.0" encoding="utf-8"?>

<actions>
    <action intentName="actions.intent.CREATE_TAXI_RESERVATION">
        <fulfillment urlTemplate="YOUR_SCHEME://YOUR_HOST{&amp;dropoff_formatted_address,dropoff_latitude,dropoff_longitude,dropoff_title,pickup_formatted_address,pickup_latitude,pickup_longitude,pickup_title}">
            <parameter-mapping
                intentParameter="taxiReservation.dropoffLocation.address"
                urlParameter="dropoff_formatted_address" />
            <parameter-mapping
                intentParameter="taxiReservation.dropoffLocation.geo.latitude"
                urlParameter="dropoff_latitude" />
            <parameter-mapping
                intentParameter="taxiReservation.dropoffLocation.geo.longitude"
                urlParameter="dropoff_longitude" />
            <parameter-mapping
                intentParameter="taxiReservation.dropoffLocation.name"
                urlParameter="dropoff_title" />
            <parameter-mapping
                intentParameter="taxiReservation.pickupLocation.address"
                urlParameter="pickup_formatted_address" />
            <parameter-mapping
                intentParameter="taxiReservation.pickupLocation.geo.latitude"
                urlParameter="pickup_latitude" />
            <parameter-mapping
                intentParameter="taxiReservation.pickupLocation.geo.longitude"
                urlParameter="pickup_longitude" />
            <parameter-mapping
                intentParameter="taxiReservation.pickupLocation.name"
                urlParameter="pickup_title" />
        </fulfillment>
    </action>
</actions>
```

After that, declare intent filter in `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest ...>
    <!-- ... other tags -->
    <application ...>
        <activity ...>
            <!-- ... other tags -->

            <!-- Google Assistant -->
            <intent-filter>
                <action android:name="com.google.android.gms.actions.RESERVE_TAXI_RESERVATION" />
                <category android:name="android.intent.category.DEFAULT" />
            </intent-filter>
        </activity>
    </application>
    <!-- ... other tags -->

    <!-- Google Assistant -->
    <meta-data
        android:name="com.google.android.actions"
        android:resource="@xml/actions" />
</manifest>
```

For more info read the [App Actions section of Google Assistant](https://developers.google.com/assistant/app/overview).

### For iOS

SiriKit supports ride booking with either Siri or Maps.
* Maps service supports ride booking with `INListRideOptionsIntent` object
* Siri service supports ride booking with `INRequestRideIntent` object

Follow the guide from the [official documentation page in Sirikit](https://developer.apple.com/documentation/sirikit/ride_booking/booking_rides_with_sirikit) to add Intents extensions to your app. Remember to add the respective intents to your `Info.plits` file. The page have a sample code with explanations, which can help you get familiar with the environment.

Add `NSUserActivity` with activityType `com.hktaxiprojectf.ride_requests` to the response in the corresponding function to integrate with this plugin. For example,

```swift
let activity = NSUserActivity(activityType: "com.hktaxiprojectf.ride_requests")
activity.userInfo = [
    "pickup_title": intent.pickupLocation?.name ?? nil!,
    "pickup_latitude": intent.pickupLocation?.location?.coordinate.latitude ?? nil!,
    "pickup_longitude": intent.pickupLocation?.location?.coordinate.longitude ?? nil!,
    "dropoff_title": intent.dropOffLocation?.name ?? nil!,
    "dropoff_latitude": intent.dropOffLocation?.location?.coordinate.latitude ?? nil!,
    "dropoff_longitude": intent.dropOffLocation?.location?.coordinate.longitude ?? nil!,
];

let response = INRequestRideIntentResponse(code: .failureRequiringAppLaunch, userActivity: activity)
completion(response)
```

For more info read the [Ride Booking section of SiriKit documentation](https://developer.apple.com/documentation/sirikit/ride_booking).

## Usage

There are two ways your app will receive a ride request - from cold start and brought from the background.

### Initial Ride

Returns the ride that the app was started with, if any.

```dart
import 'dart:async';
import 'dart:io';

import 'package:ride_requests/ride_requests.dart';
import 'package:flutter/services.dart' show PlatformException;

// ...

  Future<Null> initRideRequests() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final res = await getRideRequest();
      Ride ride = resToRide(res);
      // Parse the link and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
    } on PlatformException {
      // Handle exception by warning the user their action did not succeed
      // return?
    }
  }

// ...
```

### On change event

Usually you would check the `getInitialRide` and also listen for changes.

```dart
import 'dart:async';
import 'dart:io';

import 'package:uni_links/uni_links.dart';

// ...

  StreamSubscription _sub;

  Future<Null> initRideRequests() async {
    // ... check initialRide

    // Attach a listener to the stream
    _sub = getRideRequestStream().listen((dynamic res) {
      Ride ride = resToRide(res);
      // Parse the link and warn the user, if it is not correct
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });

    // NOTE: Don't forget to call _sub.cancel() in dispose()
  }

// ...
```

## Contribution

For help on editing plugin code, view the [documentation.](https://flutter.io/platform-plugins/#edit-code)

## License

MIT