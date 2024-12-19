//
//  NotificationService.m
//  NotifSE
//
//  Created by Hans Tang on 11/07/24.
//

#import "NotificationService.h"
#import <CleverTap-iOS-SDK/CleverTap.h>

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    //Login process here
    NSLog(@"Rich Push ObjC");
  
    /*
    NSString* COLOR_ITEM = @"color";
    NSUserDefaults* defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.app.firstRN"];
    NSString* newColor = [defaults stringForKey:COLOR_ITEM];
    */
  
    //NSLog(COLOR_ITEM);
  
    //record impression
    [[CleverTap sharedInstance] recordNotificationViewedEventWithData:request.content.userInfo];
  
    //Render push
    [super didReceiveNotificationRequest:request withContentHandler:contentHandler];
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
