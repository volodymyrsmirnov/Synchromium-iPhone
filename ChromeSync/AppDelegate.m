//
//  AppDelegate.m
//  ChromeSync
//
//  Created by Vladimir Smirnov on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "LoginFormController.h"
#import "FirstSynchronizationController.h"

#import "BookmarksController.h"
#import "TabBarController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize SyncInterface, NotificationsWindow, UserSettings;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    SyncInterface = [[CRSync alloc] init];
    
    UserSettings = [NSUserDefaults standardUserDefaults];

    NotificationsWindow = [[SJNotificationViewController alloc] initWithNibName:@"SJNotificationViewController" bundle:nil];
    [NotificationsWindow setNotificationPosition:SJNotificationPositionTop];
    [NotificationsWindow setShowSpinner:YES];
    [NotificationsWindow setNotificationTitle:NSLocalizedString(@"Requesting Google servers", nil)];
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([Keychain hasValueForKey:@"Auth"])
    {
        if ([[self UserSettings] boolForKey:@"Initialized"])
        {
            TabBarController *TabBar = [[TabBarController alloc] initWithNibName:nil bundle:nil];
            [_window setRootViewController:TabBar];
        }
        else 
        {
            FirstSynchronizationController *FirstSynchronization = [[FirstSynchronizationController alloc] initWithNibName:@"FirstSynchronization" bundle:nil];
            [_window setRootViewController:FirstSynchronization];
        }
    }
    else
    {   
        LoginFormController *Login = [[LoginFormController alloc] initWithNibName:@"Login" bundle:nil];
        [_window setRootViewController:Login];
    }
    
    [_window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

@end
