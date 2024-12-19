#import "AppDelegate.h"

#import <React/RCTBundleURLProvider.h>

#import <UserNotifications/UserNotifications.h>

#import <CleverTap-iOS-SDK/CleverTap.h>
#import <clevertap-react-native/CleverTapReactManager.h>




@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.moduleName = @"FirstRN";
  // You can add your custom initial props in the dictionary below.
  // They will be passed down to the ViewController used by React Native.
  self.initialProps = @{};
  
  
  [self registerPush];
  [CleverTap setDebugLevel:CleverTapLogDebug];
  
  [CleverTap autoIntegrate]; // integrate CleverTap SDK using the autoIntegrate option
  [[CleverTapReactManager sharedInstance] applicationDidLaunchWithOptions:launchOptions];
  
  //UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
  //center.delegate = self;

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)registerPush {
   
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
        if( !error ){
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            });
        }
    }];
}


-(void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
  NSLog(@"%@: failed to register for remote notifications: %@", self.description, error.localizedDescription);
}

-(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
  NSLog(@"%@: registered for remote notifications: %@", self.description, deviceToken.description);
}

-(void) userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    
  NSLog(@"%@: did receive notification response: %@", self.description, response.notification.request.content.userInfo);
  completionHandler();
}

/*
-(void) userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSLog(@"%@: will present notification: %@", self.description, notification.request.content.userInfo);
  //[[CleverTap sharedInstance] recordNotificationViewedEventWithData:notification.request.content.userInfo];
    completionHandler(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound);
}*/

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    NSLog(@"%@: did receive remote notification completionhandler: %@", self.description, userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)pushNotificationTappedWithCustomExtras:(NSDictionary *)customExtras{
  NSLog(@"pushNotificationTapped: customExtras: ", customExtras);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    NSLog(@"%@: will present notification: %@", self.description, notification.request.content.userInfo);
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}




- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

@end
