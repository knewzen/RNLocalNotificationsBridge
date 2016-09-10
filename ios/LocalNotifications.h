//
//  LocalNotifications.h
//  RNLocalNotificationsSample
//
//  Created by MacKentoch on 10/09/2016.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalNotifications : NSObject


//////////////////////////////////
//----- GENERAL PROPERTIES -----//
//////////////////////////////////

// enable / disable notifications
@property (nonatomic, assign) BOOL notificationsEnabled;




///////////////////////////////////
//----- METHODS             -----//
///////////////////////////////////


//----- INIT -----//

-(id) initWithDefault;



//----- METHODS -----//


// IMPORTANT: prerequisite to enable notifications for your application (otherwise notifications won't fire)
-(void)registerNotification;

// cancel all local notifications
-(void) cancelAllLocalNotifications;

// schedule a local notification
-(void) scheduleLocalNotification;


@end