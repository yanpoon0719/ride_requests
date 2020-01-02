#import "RideRequestsPlugin.h"

static NSString *const kRideChannel = @"ride_requests/ride";
static NSString *const kStreamChannel = @"ride_requests/stream";
static NSString *const kActivityType = @"com.hktaxiprojectf.ride_requests";

@interface RideRequestsPlugin () <FlutterStreamHandler>
@property(nonatomic, copy) NSDictionary *initialRide;
@property(nonatomic, copy) NSDictionary *latestRide;
@end

@implementation RideRequestsPlugin {
  FlutterEventSink _eventSink;
}

static id _instance;

+ (RideRequestsPlugin *)sharedInstance {
  if (_instance == nil) {
    _instance = [[RideRequestsPlugin alloc] init];
  }
  return _instance;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  RideRequestsPlugin *instance = [RideRequestsPlugin sharedInstance];

  FlutterMethodChannel *_mChannel =
      [FlutterMethodChannel methodChannelWithName:kRideChannel
            binaryMessenger:[registrar messenger]];
  [registrar addMethodCallDelegate:instance channel:_mChannel];

  FlutterEventChannel *_eChannel =
      [FlutterEventChannel eventChannelWithName:kStreamChannel
            binaryMessenger:[registrar messenger]];
  [_eChannel setStreamHandler:instance];

  [registrar addApplicationDelegate:instance];
}

- (void)setLatestRide:(NSDictionary *)latestRide {
  static NSString *key = @"latestRide";

  [self willChangeValueForKey:key];
  _latestRide = [latestRide copy];
  [self didChangeValueForKey:key];

  if (_eventSink) _eventSink(_latestRide);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  NSDictionary *userActivityDictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsUserActivityDictionaryKey];
  if (userActivityDictionary) {
      [userActivityDictionary enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL* _Nonnull stop) {
      if ([obj isKindOfClass:[NSUserActivity class]]) {
          NSString* activityType = [obj valueForKey:@"activityType"];
          if ([activityType isEqualToString:kActivityType]) {
              self.initialRide = [obj valueForKey:@"userInfo"];
              self.latestRide = [obj valueForKey:@"userInfo"];
          }
      }
    }];
  }
  return YES;
}

- (BOOL)application:(UIApplication *)application
    continueUserActivity:(NSUserActivity *)userActivity
        restorationHandler:(void (^)(NSArray *_Nullable))restorationHandler {
  if ([userActivity.activityType isEqualToString:kActivityType]) {
    self.latestRide = userActivity.userInfo;
    if (!_eventSink) {
      self.initialRide = self.latestRide;
    }
    return YES;
  }
  return NO;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
  if ([@"getRideRequest" isEqualToString:call.method]) {
    result(self.initialRide);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (FlutterError *_Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(nonnull FlutterEventSink)eventSink {
  _eventSink = eventSink;
  return nil;
}

- (FlutterError *_Nullable)onCancelWithArguments:(id _Nullable)parameters {
  _eventSink = nil;
  return nil;
}

@end
