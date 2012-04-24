//
//  CRSync.h
//  ChromeSync
//
//  Created by Vladimir Smirnov on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IXKeychain.h"
#import "Sync.pb.h"
#import "LRResty.h"
#import "FMDatabase.h"

#define UserAgent @"CrSync IOS 1.0.0.1 (1001)"

@protocol CRSyncDelegate <NSObject>

@optional
- (void)Synchronization:(NSString *)Status;
- (void)Login:(NSString *)Status;

@end

@interface CRSync : NSObject
{
    FMDatabase *DB;
    id <CRSyncDelegate> delegate;
}

typedef enum  {
    Autofill = 31729,
    Bookmark = 32904,
    Preference = 37702,
    Typed_url = 40781,
    Theme = 41210,
    App_notification = 45184,
    Password = 45873,
    Nigori = 47745,
    Extension = 48119,
    Apps = 48364,
    Session = 50119,
    Autofill_profile = 63951,
    Search_engine = 88610,
    Extension_setting = 96159,
    App_setting = 103656
} CRRequestType;

@property (readonly, nonatomic) FMDatabase *DB;
@property (strong, nonatomic) id <CRSyncDelegate> delegate;  

- (NSString*) BookmarksRootID;

- (void) RequestAllInitial;
- (void) CleanEverything;

- (void) RequestNigoriInitial;
- (void) RequestBookmarks;
- (void) RequestHistory;
- (NSArray *) SearchBookmarks: (NSString *) Word;
- (NSArray *) SearchHistory: (NSString *) Word;

- (void) LoginAtGoogle: (NSString *) Email : (NSString *) Password;
- (NSString *) GenerateClientID;
- (NSArray *) ReadBookmarks: (NSString *) ID;
- (NSArray *) ReadHistory;

- (NSString *) CountBookmarks;
- (NSString *) CountHistory;

- (void) RequestGoogleSyncUpdates: (NSArray *) 
         ProgressMarkers CallerInfo: (GetUpdatesCallerInfo *) 
         CallerInfo ClientID:(NSString *) 
         ClientID InfiniteLoop: (BOOL) InfiniteLoop;

@end
