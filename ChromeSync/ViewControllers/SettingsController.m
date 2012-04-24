//
//  SettingsController.m
//  ChromeSync
//
//  Created by Vladimir Smirnov on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingsController.h"
#import "IXKeychain.h"
#import "LoginFormController.h"

@interface SettingsController ()
{
    AppDelegate *Syncr;
    UISwitch *SynchronizeOnStart;
    UISwitch *OpenInSafari;
}
@end

@implementation SettingsController

- (void)Synchronization:(NSString *)Status
{   
    if (Status == @"success")
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBookmarksData" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateHistoryData" object:nil];
        [[self tableView] reloadData];
    }
    if (Status == @"error_level_0") 
    {        
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No network connection", nil) message:NSLocalizedString(@"You must be connected to the internet to use this app", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    else if (Status == @"error_level_1" || Status== @"error_level_2") 
    {        
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Weird answer", nil) message:NSLocalizedString(@"We get wrong data from Google, try again later", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    else if (Status == @"started") 
    {
        return [[Syncr NotificationsWindow] show];
    }
    
    [[Syncr NotificationsWindow] hide];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        Syncr = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [Syncr.SyncInterface setDelegate:self];
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Syncr.NotificationsWindow setParentView:[self view]];
}

- (void) SwitchChanged: (UISwitch *) sender
{   
    if (sender == SynchronizeOnStart) [Syncr.UserSettings setBool:sender.on forKey:@"SynchronizeOnStart"];
    if (sender == OpenInSafari) [Syncr.UserSettings setBool:sender.on forKey:@"OpenInSafari"];
    
    [Syncr.UserSettings synchronize];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) return NSLocalizedString(@"General settings",nil);
    else if (section == 1) return NSLocalizedString(@"Database information",nil);
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 3) return NSLocalizedString(@"and perform new synchronization",nil);
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return 2;
    if (section == 1) return 3;
    else return 1;
}

- (NSString *)stringFromFileSize:(int)theSize
{
    float floatSize = theSize;
    if (theSize<1023)
        return([NSString stringWithFormat:@"%i bytes",theSize]);
    floatSize = floatSize / 1024;
    if (floatSize<1023)
        return([NSString stringWithFormat:@"%1.1f KB",floatSize]);
    floatSize = floatSize / 1024;
    if (floatSize<1023)
        return([NSString stringWithFormat:@"%1.1f MB",floatSize]);
    floatSize = floatSize / 1024;
    
    return([NSString stringWithFormat:@"%1.1f GB",floatSize]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *Cell;
    
    Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if ([indexPath section] == 0)
    {
        [Cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if ([indexPath row] == 0)
        {
            [[Cell textLabel] setText:NSLocalizedString(@"Synchronize on start",nil)];
            SynchronizeOnStart =  [[UISwitch alloc] initWithFrame:CGRectZero];
            [SynchronizeOnStart setOn:[Syncr.UserSettings boolForKey:@"SynchronizeOnStart"]];
            [SynchronizeOnStart addTarget:self action:@selector(SwitchChanged:) forControlEvents:UIControlEventValueChanged];
            [Cell setAccessoryView:SynchronizeOnStart];
        }
        else
        {
            [[Cell textLabel] setText:NSLocalizedString(@"Open all links in Safari",nil)];
            OpenInSafari =  [[UISwitch alloc] initWithFrame:CGRectZero];
            [OpenInSafari setOn:[Syncr.UserSettings boolForKey:@"OpenInSafari"]];
            [OpenInSafari addTarget:self action:@selector(SwitchChanged:) forControlEvents:UIControlEventValueChanged];
            [Cell setAccessoryView:OpenInSafari];
        }
    }
    else if ([indexPath section] == 1)
    {
        Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];

        if ([indexPath row] == 0)
        {
            [[Cell textLabel] setText:NSLocalizedString(@"Bookmarks quantity",nil)];
            [[Cell detailTextLabel] setText:[Syncr.SyncInterface CountBookmarks]];
        }
        else if ([indexPath row] == 1)
        {
            [[Cell textLabel] setText:NSLocalizedString(@"History items quantity",nil)];
            [[Cell detailTextLabel] setText:[Syncr.SyncInterface CountHistory]];
        }
        else if ([indexPath row] == 2) 
        {
            [[Cell textLabel] setText:NSLocalizedString(@"Database size",nil)];
            
            NSDictionary *DBFile = [[NSFileManager defaultManager] attributesOfItemAtPath:[[NSString alloc] initWithFormat:@"%@/basic.db",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]] error:nil];            
            
            [[Cell detailTextLabel] setText:[self stringFromFileSize:[[DBFile objectForKey:@"NSFileSize"] intValue]]];
        }
        
        [Cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    else if ([indexPath section] == 2) 
    {
        [[Cell textLabel] setTextAlignment:UITextAlignmentCenter];
        [[Cell textLabel] setText:NSLocalizedString(@"Synchronize everything now",nil)];
    }
    else if ([indexPath section] == 3) 
    {
        [[Cell textLabel] setTextAlignment:UITextAlignmentCenter];
        [[Cell textLabel] setText:NSLocalizedString(@"Clean synchronization database",nil)];
    }
    
    return Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    
    if ([indexPath section] == 2) 
    {
        [Syncr.SyncInterface RequestAllInitial]; 
    }
    else if ([indexPath section] == 3)
    {
        [Keychain removeSecureValueForKey:@"Auth"];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
        [Syncr.SyncInterface CleanEverything];
        [[Syncr window] setRootViewController:[[LoginFormController alloc] initWithNibName:@"Login" bundle:nil]];
    }
}

@end
