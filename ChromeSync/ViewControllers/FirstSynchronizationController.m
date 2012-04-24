//
//  FirstSynchronizationController.m
//  ChromeSync
//
//  Created by Vladimir Smirnov on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstSynchronizationController.h"
#import "TabBarController.h"
#import <QuartzCore/QuartzCore.h>

@interface FirstSynchronizationController ()
{
    AppDelegate *Syncr;
    BOOL NigoriFinished;
}
@end

@implementation FirstSynchronizationController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    Syncr = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[Syncr NotificationsWindow] setParentView:[self view]];
    [[Syncr SyncInterface] setDelegate:self];    
    [Syncr.SyncInterface RequestNigoriInitial];
    
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]]];
        
    UIImageView *Logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo.png"]];
    [Logo setFrame:CGRectMake(0, -70, Logo.frame.size.width, Logo.frame.size.height)];
    [SyncInformation addSubview:Logo];
    
    [[SyncInformation layer] setMasksToBounds:NO];
    [[SyncInformation layer] setShadowColor:[[UIColor grayColor] CGColor]];
    [[SyncInformation layer] setShadowOffset:CGSizeMake(0,0)];
    [[SyncInformation layer] setShadowRadius:15];
    [[SyncInformation layer] setShadowOpacity:1];
    [[SyncInformation layer] setCornerRadius:10];  

    
    return self;
}

- (void)Synchronization:(NSString *)Status
{
    if (Status == @"started")
    {
        return [[Syncr NotificationsWindow] show];
    }
    else if (Status == @"success")
    {
        if (!NigoriFinished)
        {
            if ([[Syncr UserSettings] boolForKey:@"encryptEverything"] || [[Syncr UserSettings] boolForKey:@"encryptBookmarks"] || [[Syncr UserSettings] boolForKey:@"encryptTypedUrls"])
            {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"You are encrypted", nil) message:NSLocalizedString(@"Sorry, but we don't support ecnrypted profiles now", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
            else 
            {
                NigoriFinished = YES;
                [[Syncr SyncInterface] RequestAllInitial];;
            }
        }
        else
        {
            [[Syncr UserSettings] setBool:YES forKey:@"Initialized"];
            [[Syncr UserSettings] synchronize];
            
            TabBarController *TabBar = [[TabBarController alloc] initWithNibName:nil bundle:nil];
            [self presentModalViewController:TabBar animated:YES];
        }
    }
    else if (Status == @"error_0")
    {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No network connection", nil) message:NSLocalizedString(@"You must be connected to the internet to use this app", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    else if (Status == @"error_1" || Status == @"error_2")
    {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Weird answer", nil) message:NSLocalizedString(@"We get wrong data from Google, try again later", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    
    [[Syncr NotificationsWindow] hide];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)InterfaceOrientation
{
    return (InterfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
