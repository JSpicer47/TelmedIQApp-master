//
//  AppDelegate.h
//  TelmedIQApp
//
//  Created by John Spicer on 2016-07-20.
//  Copyright © 2016 John Spicer. All rights reserved.
//

#ifndef DEBUG
// do nothing
#define DLog(...)
#else
#define DLog NSLog
#endif

typedef enum
{
    NotReachable = 0,
    ReachableViaWiFi,
    ReachableViaWWAN
} NetworkStatus;

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    
}

@property (strong, nonatomic) UIWindow *window;

/**
 The main application object.
 */
+ (AppDelegate *)app;

/**
 Check the ability to use wifi to reach specified web urls (if true, we can).
 */
- (NetworkStatus)checkReachability;


@end

