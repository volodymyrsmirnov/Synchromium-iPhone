//
//  BookmarksViewController.m
//  ChromeSync
//
//  Created by Vladimir Smirnov on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "BookmarksController.h"
#import "TSMiniWebBrowser.h"

#import <iAd/iAd.h>


@interface BookmarksController ()
{
    NSArray *Bookmarks;
    AppDelegate *Syncr;
    NSString *ID;
    NSString *LastClickedURL;
    UIActionSheet *ActionSheet;
    UISearchBar *SearchBar;
}
@end

@implementation BookmarksController

- (void)Synchronization:(NSString *)Status
{    
    if (Status == @"success")
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateHistoryData" object:nil];
        
        Bookmarks = [Syncr.SyncInterface ReadBookmarks:ID]; 
        [[self tableView] reloadData];        
    } 
    else if (Status == @"error_level_0") 
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

- (void) UpdateData 
{
    Bookmarks = [Syncr.SyncInterface ReadBookmarks:ID]; 
    [[self tableView] reloadData];
}

- (id)initWithID: (NSString *) PID
{
    self = [super initWithNibName:nil bundle:nil];
    
    ID = PID;
    
    Syncr = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [Syncr.SyncInterface setDelegate:self];
    [[Syncr NotificationsWindow] setParentView:[self view]];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateData) name:@"UpdateBookmarksData" object:nil];
    
    if (ID == [Syncr.SyncInterface BookmarksRootID])
    {
        SearchBar = [[UISearchBar alloc] init];
        [SearchBar sizeToFit];
        [SearchBar setDelegate:self];
        [SearchBar setPlaceholder:NSLocalizedString(@"search in your bookmarks", nil)];
        [SearchBar setShowsCancelButton:YES animated:NO];
        [[self tableView] setTableHeaderView:SearchBar];
        
        if ([Syncr.UserSettings boolForKey:@"SynchronizeOnStart"])
            [Syncr.SyncInterface RequestAllInitial];

    }

    ActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Open is Safari", nil), NSLocalizedString(@"Open in built-in browser", nil), NSLocalizedString(@"Copy link to clipboard", nil),nil];
    [ActionSheet setDelegate:self];
    
    UIBarButtonItem *StaticBackButton = [[UIBarButtonItem alloc] init];
    [StaticBackButton setTitle:NSLocalizedString(@"Back", nil)];
    [[self navigationItem] setBackBarButtonItem:StaticBackButton];
    
    UIBarButtonItem *RefreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(RefreshBookmarksClick)];          
    [[self navigationItem] setRightBarButtonItem:RefreshButton];
        
    Bookmarks = [Syncr.SyncInterface ReadBookmarks:ID]; 
    
    return self;
}

- (void)actionSheet:(UIActionSheet *)ActionSheet clickedButtonAtIndex:(NSInteger)ButtonIndex
{
    if (ButtonIndex == 0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:LastClickedURL]];
    }
    else if (ButtonIndex == 1)
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
        TSMiniWebBrowser *BuiltinBrowser = [[TSMiniWebBrowser alloc] initWithUrl:[NSURL URLWithString:LastClickedURL]];
        [BuiltinBrowser setMode:TSMiniWebBrowserModeModal];
        [self presentModalViewController:BuiltinBrowser animated:YES];
    }
    else if (ButtonIndex == 2)
    {
        [[UIPasteboard generalPasteboard] setString:LastClickedURL];
    }
}

- (void) RefreshBookmarksClick
{
    [Syncr.SyncInterface RequestBookmarks];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
        
    if (ID != [Syncr.SyncInterface BookmarksRootID])
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    else
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [Syncr.NotificationsWindow setParentView:[self view]];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    Bookmarks = [Syncr.SyncInterface SearchBookmarks:searchText]; 
    [[self tableView] reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{   
    Bookmarks = [Syncr.SyncInterface ReadBookmarks:ID]; 
    [[self tableView] reloadData];
    [searchBar resignFirstResponder]; 
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [Bookmarks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *BookmarkRow;
    
    BookmarkRow = [Bookmarks objectAtIndex:[indexPath row]];
         
    if ([[BookmarkRow valueForKey:@"ServerTag"] rangeOfString:@"other_bookmarks"].location != NSNotFound) 
        [BookmarkRow setObject:NSLocalizedString(@"Other bookmarks", nil) forKey:@"Name"];
    
    if ([[BookmarkRow valueForKey:@"ServerTag"] rangeOfString:@"bookmark_bar"].location != NSNotFound) 
        [BookmarkRow setObject:NSLocalizedString(@"Bookmarks bar", nil) forKey:@"Name"];
    
    if ([[BookmarkRow objectForKey:@"Name"]length] == 0)
        [BookmarkRow setObject:[BookmarkRow objectForKey:@"URL"] forKey:@"Name"];
    
    UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:[BookmarkRow objectForKey:@"ID"]];
    
    if (!Cell)
    {
        if ([BookmarkRow objectForKey:@"IsFolder"] == [NSNumber numberWithBool:YES])
        {
            Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[BookmarkRow objectForKey:@"ID"]];
            [Cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [[Cell imageView] setImage:[UIImage imageNamed:@"iconFolder.png"]];
        }
        else 
        {
            Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[BookmarkRow objectForKey:@"ID"]];
            [[Cell detailTextLabel] setText:[BookmarkRow objectForKey:@"URL"]];
            
            if ([[BookmarkRow objectForKey:@"Favicon"] length] != 0)            
                [[Cell imageView] setImage:[UIImage imageWithData:[BookmarkRow objectForKey:@"Favicon"]]];
            else
                [[Cell imageView] setImage:[UIImage imageNamed:@"iconBookmark.png"]];
        }
        [[Cell textLabel] setText:[BookmarkRow objectForKey:@"Name"]];
    }
    
    return Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    NSMutableDictionary *BookmarkRow = [Bookmarks objectAtIndex:[indexPath row]];
    
    [[tableView tableHeaderView] resignFirstResponder];
    
    if ([BookmarkRow objectForKey:@"IsFolder"] == [NSNumber numberWithBool:YES])
    {
        BookmarksController *BookmarksChild = [[BookmarksController alloc] initWithID:[BookmarkRow objectForKey:@"ID"]];
        
        [BookmarksChild setTitle:[BookmarkRow objectForKey:@"Name"]];
        [self.navigationController pushViewController:BookmarksChild animated:YES];
    }
    else 
    {    
        LastClickedURL = [BookmarkRow objectForKey:@"URL"];
        
        if ([Syncr.UserSettings boolForKey:@"OpenInSafari"])
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:LastClickedURL]];
        else
            [ActionSheet showFromTabBar:[[self tabBarController] tabBar]];
    }
}

@end
