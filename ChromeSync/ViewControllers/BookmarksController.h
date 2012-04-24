//
//  BookmarksViewController.h
//  ChromeSync
//
//  Created by Vladimir Smirnov on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRSync.h"

@interface BookmarksController : UITableViewController <UISearchBarDelegate,UIActionSheetDelegate,CRSyncDelegate>

- (id)initWithID: (NSString *) ID;

@end

