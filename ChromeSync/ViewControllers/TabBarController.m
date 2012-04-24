//
//  TabBarComntroller.m
//  ChromeSync
//
//  Created by Vladimir Smirnov on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarController.h"
#import "BookmarksController.h"
#import "HistoryController.h"
#import "SettingsController.h"

@interface TabBarController ()
{
    AppDelegate *Syncr;
}
@end

@implementation TabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    Syncr = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (self) {
        BookmarksController *Bookmarks = [[BookmarksController alloc] initWithID:[Syncr.SyncInterface BookmarksRootID]];
        UINavigationController *BookmarksNavigation = [[UINavigationController alloc] initWithRootViewController:Bookmarks];
        [BookmarksNavigation setTitle:NSLocalizedString(@"Bookmarks",nil)];
        [[BookmarksNavigation tabBarItem] setImage:[UIImage imageNamed:@"tabBookmarks.png"]];
        
        HistoryController *History = [[HistoryController alloc] initWithNibName:nil bundle:nil];
        [History setTitle:NSLocalizedString(@"History",nil)];
        [[History tabBarItem] setImage:[UIImage imageNamed:@"tabHistory.png"]];
         
        SettingsController *Settings = [[SettingsController alloc] initWithStyle:UITableViewStyleGrouped];
        [Settings setTitle:NSLocalizedString(@"Settings",nil)];
        [[Settings tabBarItem] setImage:[UIImage imageNamed:@"tabSettings.png"]];
                
        [self setViewControllers:[NSArray arrayWithObjects:BookmarksNavigation, History, Settings, nil]];
    }
    
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown) return YES;
    return NO;
}

@end
