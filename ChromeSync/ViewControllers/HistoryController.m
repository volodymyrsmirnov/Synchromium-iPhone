//
//  HistoryController.m
//  ChromeSync
//
//  Created by Vladimir Smirnov on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "HistoryController.h"
#import "TSMiniWebBrowser.h"

@interface HistoryController ()
{
    NSArray *History;
    AppDelegate *Syncr;
    NSString *ID;
    NSString *LastClickedURL;
    UIActionSheet *ActionSheet;
    UISearchBar *SearchBar;
}
@end

@implementation HistoryController

- (void)Synchronization:(NSString *)Status
{
    
}

- (void) UpdateData 
{
    History = [Syncr.SyncInterface ReadHistory]; 
    [[self tableView] reloadData];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Syncr.NotificationsWindow setParentView:[self view]];
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        Syncr = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [Syncr.SyncInterface setDelegate:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateData) name:@"UpdateHistoryData" object:nil];
        
        History = [Syncr.SyncInterface ReadHistory];
        
        SearchBar = [[UISearchBar alloc] init];
        [SearchBar sizeToFit];
        [SearchBar setDelegate:self];
        [SearchBar setPlaceholder:NSLocalizedString(@"search in your history", nil)];
        [SearchBar setShowsCancelButton:YES animated:NO];
        [[self tableView] setTableHeaderView:SearchBar];
        
        ActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Open is Safari", nil), NSLocalizedString(@"Open in built-in browser", nil), NSLocalizedString(@"Copy link to clipboard", nil),nil];
        [ActionSheet setDelegate:self];
    }
    
    return self;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    History = [Syncr.SyncInterface SearchHistory:searchText]; 
    [[self tableView] reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{   
    History = [Syncr.SyncInterface ReadHistory]; 
    [[self tableView] reloadData];
    [searchBar resignFirstResponder];  
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [History count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier: @"Cell"];
    
    if (Cell == nil)
        Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        
    NSMutableDictionary *HistoryItem = [History objectAtIndex:[indexPath row]];
    
    if ([[HistoryItem objectForKey:@"Name"] length] == 0)
        [HistoryItem setObject:[HistoryItem objectForKey:@"URL"] forKey:@"Name"];
    
    [[Cell textLabel] setText:[HistoryItem objectForKey:@"Name"]];
    [[Cell detailTextLabel] setText:[HistoryItem objectForKey:@"URL"]];
    
    return Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    NSMutableDictionary *HistoryRow = [History objectAtIndex:[indexPath row]];
    
    [[tableView tableHeaderView] resignFirstResponder];
    
    LastClickedURL = [HistoryRow objectForKey:@"URL"];
    
    if ([Syncr.UserSettings boolForKey:@"OpenInSafari"])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:LastClickedURL]];
    else
        [ActionSheet showFromTabBar:[[self tabBarController] tabBar]];
}

@end
