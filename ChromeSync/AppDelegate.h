//
//  AppDelegate.h
//  ChromeSync
//
//  Created by Vladimir Smirnov on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CRSync.h"
#import "SJNotificationViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    CRSync *SyncInterface;
}


@property (strong, nonatomic) UIWindow *window;

@property (readonly, nonatomic) CRSync *SyncInterface;
@property (readonly, nonatomic) SJNotificationViewController *NotificationsWindow;
@property (readonly, nonatomic) NSUserDefaults *UserSettings;

@end
