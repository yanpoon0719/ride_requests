package com.hktaxiprojectf.ride_requests;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import com.google.android.gms.actions.ReserveIntents;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.EventChannel.StreamHandler;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import java.util.HashMap;
import java.util.Map;

/** RideRequestsPlugin */
public class RideRequestsPlugin implements MethodCallHandler, StreamHandler, PluginRegistry.NewIntentListener {
  private static final String RIDE_CHANNEL = "ride_requests/ride";
  private static final String STREAM_CHANNEL = "ride_requests/stream";

  private BroadcastReceiver changeReceiver;
  private Registrar registrar;

  private Map<String, String> initialRide = new HashMap<String, String>() {{
    put("pickup_formatted_address", "");
    put("pickup_latitude", "");
    put("pickup_longitude", "");
    put("pickup_title", "");
    put("dropoff_formatted_address", "");
    put("dropoff_latitude", "");
    put("dropoff_longitude", "");
    put("dropoff_title", "");
  }};
  private Map<String, String> latestRide = new HashMap<String, String>() {{
    put("pickup_formatted_address", "");
    put("pickup_latitude", "");
    put("pickup_longitude", "");
    put("pickup_title", "");
    put("dropoff_formatted_address", "");
    put("dropoff_latitude", "");
    put("dropoff_longitude", "");
    put("dropoff_title", "");
  }};

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    // Detect if already launched in background
    if (registrar.activity() == null) {
      return;
    }

    RideRequestsPlugin instance = new RideRequestsPlugin(registrar);

    final MethodChannel mChannel = new MethodChannel(registrar.messenger(), RIDE_CHANNEL);
    mChannel.setMethodCallHandler(instance);

    final EventChannel eChannel = new EventChannel(registrar.messenger(), STREAM_CHANNEL);
    eChannel.setStreamHandler(instance);

    registrar.addNewIntentListener(instance);
  }

  public RideRequestsPlugin(Registrar registrar) {
    this.registrar = registrar;
    handleIntent(registrar.context(), registrar.activity().getIntent(), true);
  }

  private void handleIntent(Context context, Intent intent, Boolean initial) {
    String action = intent.getAction();
    String dataString = intent.getDataString();

    // TODO: convert intent data to map
    if (ReserveIntents.ACTION_RESERVE_TAXI_RESERVATION.equals(action)) {
      if (initial) initialRide.put("pickup_formatted_address", dataString);
      latestRide = new HashMap<String, String>(initialRide);
      if (changeReceiver != null) changeReceiver.onReceive(context, intent);
    }
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getRideRequest")) {
      result.success(initialRide);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onListen(Object arguments, EventSink events) {
    changeReceiver = createChangeReceiver(events);
  }

  @Override
  public void onCancel(Object arguments) {
    changeReceiver = null;
  }

  @Override
  public boolean onNewIntent(Intent intent) {
    handleIntent(registrar.context(), intent, false);
    return false;
  }

  private BroadcastReceiver createChangeReceiver(final EventSink events) {
    return new BroadcastReceiver() {
      @Override
      public void onReceive(Context context, Intent intent) {
        String dataString = intent.getDataString();

        if (dataString == null) {
          events.error("UNAVAILABLE", "Link unavailable", null);
        } else {
          events.success(dataString);
        }
      }
    };
  }
}
