//
//  LocalNotificationsBridge.m
//  RNLocalNotificationsSample
//
//  Created by MacKentoch on 10/09/2016.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "LocalNotificationsBridge.h"
#import "LocalNotifications.h"
#import "UIKit/UIKit.h"
#import "AppDelegate.h"
#import "RCTLog.h"



#ifndef SHOW_RCTLOG
#define SHOW_RCTLOG 1 // set 1 only for dev debug otherwise 0
#endif

@implementation LocalNotificationsBridge


RCT_EXPORT_MODULE();


#pragma RCTEventEmitter implement

- (NSArray<NSString *> *)supportedEvents{
  
  return @[@"onLocalNotification"];
}

- (void)startObserving
{
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(receivedLocalNotification:)
                                               name:@"onLocalNotification"
                                             object:nil];
}

- (void)stopObserving
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - INNER METHODS

// get reference to singleton appDelegate
- (AppDelegate *) getAppDelegate {
  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  return appDelegate;
}

// called when received a local notification (see startObserving observing upper)
-(void) receivedLocalNotification: (NSNotification *)notification {
  
  if ([[notification name] isEqualToString:@"onLocalNotification"]) {
    
    NSDictionary *receivedDetails = (NSDictionary *)notification.object;
    
    NSString *body = [receivedDetails objectForKey:@"body"];
    NSString *title = [receivedDetails objectForKey:@"title"];
    
    #if SHOW_RCTLOG
        RCTLogInfo(@"receivedLocalNotification in bridge, will send it to JS with body: '%@' and '%@'", body, title);
    #endif
    
    [self sendEventWithName:@"onLocalNotification"
                       body:receivedDetails];
  }
}



#pragma mark - EXPORTED METHODS

// disactive local notifications (WARNING all notification will be canceled)
RCT_EXPORT_METHOD(enableLocalNotifications)
{
  AppDelegate *appDelegate = [self getAppDelegate];

  LocalNotifications *localNotificationManager = appDelegate.localNotificationsManager;
  if (!localNotificationManager) {return; }
  
  #if SHOW_RCTLOG
    RCTLogInfo(@"'enable' local notifications");
  #endif
  
  localNotificationManager.notificationsEnabled = YES;
}

// active local notifications
RCT_EXPORT_METHOD(disableLocalNotifications)
{
  AppDelegate *appDelegate = [self getAppDelegate];
  
  LocalNotifications *localNotificationManager = appDelegate.localNotificationsManager;
  if (!localNotificationManager) {return; }
  
  #if SHOW_RCTLOG
    RCTLogInfo(@"'disable' local notifications");
  #endif
  
  localNotificationManager.notificationsEnabled = NO;
}

// IMPORTANT: prerequisite to enable notifications for your application (otherwise notifications won't fire)
RCT_EXPORT_METHOD(registerNotification)
{
  AppDelegate *appDelegate = [self getAppDelegate];
  
  LocalNotifications *localNotificationManager = appDelegate.localNotificationsManager;
  if (!localNotificationManager) {return; }
  
  #if SHOW_RCTLOG
    RCTLogInfo(@"'register local notifications'");
  #endif
  
  [localNotificationManager registerNotification];
}

// cancel all local notifications
RCT_EXPORT_METHOD(cancelAllLocalNotifications)
{
  AppDelegate *appDelegate = [self getAppDelegate];
  
  LocalNotifications *localNotificationManager = appDelegate.localNotificationsManager;
  if (!localNotificationManager) {return; }
  
  #if SHOW_RCTLOG
    RCTLogInfo(@"'cancel all notifications'");
  #endif
  
  [localNotificationManager cancelAllLocalNotifications];
}

// schedule a local notification (define a title, a body and how many seconds from now before apearing)
RCT_EXPORT_METHOD(scheduleLocalNotification: (NSString *) title
                  body:(NSString *) body
                  secondsBeforeAppear: (int) seconds
                  userInfo: (NSDictionary *) userInfo)
{
  AppDelegate *appDelegate = [self getAppDelegate];
  
  LocalNotifications *localNotificationManager = appDelegate.localNotificationsManager;
  if (!localNotificationManager) {return; }
  
  #if SHOW_RCTLOG
    RCTLogInfo(@"'schedule a local notification' with title: %@ and body: %@", title, body);
  #endif
  
  [localNotificationManager scheduleLocalNotification:title
                                                 body:body
                                  secondsBeforeAppear:seconds
                                             userInfo:userInfo];
}


// show an immediate local notification (define a title, a body)
RCT_EXPORT_METHOD(showLocalNotification: (NSString *) title body:(NSString *) body userInfo: (NSDictionary *) userInfo)
{
  AppDelegate *appDelegate = [self getAppDelegate];
  
  LocalNotifications *localNotificationManager = appDelegate.localNotificationsManager;
  if (!localNotificationManager) {return; }
  
  #if SHOW_RCTLOG
    RCTLogInfo(@"'show instantly a local notification' with title: %@ and body: %@", title, body);
  #endif

  [localNotificationManager showLocalNotification:title
                                             body:body
                                         userInfo:userInfo];
}

RCT_EXPORT_METHOD(resetNotificationBadgeNumber) {
  AppDelegate *appDelegate = [self getAppDelegate];
  
  LocalNotifications *localNotificationManager = appDelegate.localNotificationsManager;
  if (!localNotificationManager) {return; }
  
  #if SHOW_RCTLOG
    RCTLogInfo(@"'resets badge number");
  #endif
  
  [localNotificationManager resetNotificationBadgeNumber];
};


@end
