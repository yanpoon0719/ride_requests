package com.hktaxiprojectf.ride_requests_example;

import android.os.Bundle;

import com.hktaxiprojectf.ride_requests.RideRequestsPlugin;

import io.flutter.app.FlutterActivity;


public class EmbeddingV1Activity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        RideRequestsPlugin.registerWith(registrarFor("com.hktaxiprojectf.ride_requests.RideRequestsPlugin"));
    }

}
