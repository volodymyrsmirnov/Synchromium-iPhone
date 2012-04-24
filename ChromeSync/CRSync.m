//
//  CRSync.m
//  ChromeSync
//
//  Created by Vladimir Smirnov on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CRSync.h"
#import "IXKeychain.h"
#import "Sync.pb.h"
#import "LRResty.h"
#import  "FMDatabase.h"

#import <CommonCrypto/CommonKeyDerivation.h>
#import <CommonCrypto/CommonCryptor.h>


@implementation CRSync
{
    NSUserDefaults *UserSettings;
    NSString *BID;
}

@synthesize DB, delegate;

- (CRSync *) init 
{
    UserSettings = [NSUserDefaults standardUserDefaults];
    
    DB = [FMDatabase databaseWithPath: [[NSString alloc] initWithFormat:@"%@/basic.db",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]]; 
    [DB open];

    [DB executeUpdate:@"CREATE TABLE IF NOT EXISTS CRBookmarks (ID TEXT PRIMARY KEY, ParentID TEXT, IsFolder NUMERIC, ServerTag TEXT, CTime NUMERIC, MTime NUMERIC, Name TEXT, URL Text, Favicon BLOB)"]; 
    [DB executeUpdate:@"CREATE TABLE IF NOT EXISTS CRHistory (ID TEXT PRIMARY KEY, CTime NUMERIC, MTime NUMERIC, Name TEXT, URL Text)"];
   
    return self;
}

- (NSString *) CountBookmarks
{
     FMResultSet *CountBookmarksQuery = [DB executeQuery:@"SELECT COUNT(ID) FROM CRBookmarks"];
    if ([CountBookmarksQuery next])
        return [CountBookmarksQuery stringForColumnIndex:0];
    else return @"0";
}

- (NSString *) CountHistory
{
    FMResultSet *CountBookmarksQuery = [DB executeQuery:@"SELECT COUNT(ID) FROM CRHistory"];
    if ([CountBookmarksQuery next])
        return [CountBookmarksQuery stringForColumnIndex:0];
    else return @"0";
}


- (void) CleanEverything
{
    [DB executeUpdate:@"DELETE FROM CRDevices"];
    [DB executeUpdate:@"DELETE FROM CRBookmarks"];
    [DB executeUpdate:@"DELETE FROM CRHistory"];
}

- (void) RequestHistory
{
    DataTypeProgressMarker *RequestHistoryCall; 
    
    if ([UserSettings objectForKey:@"ProgressMarker_40781"] == nil)
    {
        RequestHistoryCall = [[[[DataTypeProgressMarker_Builder alloc] init] setDataTypeId:(CRRequestType)Typed_url] build];
    }
    else 
    {
        DataTypeProgressMarker_Builder *RequestHistoryCallBuilder = [[DataTypeProgressMarker_Builder alloc] init];
        [RequestHistoryCallBuilder setToken:[UserSettings objectForKey:@"ProgressMarker_40781"]];
        [RequestHistoryCallBuilder setDataTypeId:(CRRequestType)Typed_url];
        RequestHistoryCall = [RequestHistoryCallBuilder build];
    }
    
    [self RequestGoogleSyncUpdates: [[NSArray alloc] initWithObjects:RequestHistoryCall, nil] CallerInfo:[[[[GetUpdatesCallerInfo_Builder alloc] init] setSource:GetUpdatesCallerInfo_GetUpdatesSourcePeriodic] build] ClientID:[self GenerateClientID] InfiniteLoop:YES];
}

- (NSArray *) ReadHistory
{
    NSMutableArray *Childs = [[NSMutableArray alloc] init];
    
    FMResultSet *HistoryQuery = [DB executeQuery:@"SELECT ID, Name, Url FROM CRHistory WHERE URL!='' ORDER BY MTime DESC"];
    
    while ([HistoryQuery next])
    {
        NSMutableDictionary *History = [[NSMutableDictionary alloc] init];
        [History setValue:[HistoryQuery stringForColumn:@"ID"] forKey:@"ID"];
        [History setValue:[HistoryQuery stringForColumn:@"Name"] forKey:@"Name"];
        [History setValue:[HistoryQuery stringForColumn:@"URL"] forKey:@"URL"];       
        [Childs addObject:History];
    }
    
    return Childs;
}

- (void) RequestAllInitial
{
    DataTypeProgressMarker *RequestHistoryCall; 
    
    if ([UserSettings objectForKey:@"ProgressMarker_40781"] == nil)
    {
        RequestHistoryCall = [[[[DataTypeProgressMarker_Builder alloc] init] setDataTypeId:(CRRequestType)Typed_url] build];
    }
    else 
    {
        DataTypeProgressMarker_Builder *RequestHistoryCallBuilder = [[DataTypeProgressMarker_Builder alloc] init];
        [RequestHistoryCallBuilder setToken:[UserSettings objectForKey:@"ProgressMarker_40781"]];
        [RequestHistoryCallBuilder setDataTypeId:(CRRequestType)Typed_url];
        RequestHistoryCall = [RequestHistoryCallBuilder build];
    }
    
    DataTypeProgressMarker *RequestBookmarksCall; 

    if ([UserSettings objectForKey:@"ProgressMarker_32904"] == nil)
    {
        RequestBookmarksCall = [[[[DataTypeProgressMarker_Builder alloc] init] setDataTypeId:(CRRequestType)Bookmark] build];
    }
    else 
    {
        DataTypeProgressMarker_Builder *RequestBookmarksCallBuilder = [[DataTypeProgressMarker_Builder alloc] init];
        [RequestBookmarksCallBuilder setToken:[UserSettings objectForKey:@"ProgressMarker_32904"]];
        [RequestBookmarksCallBuilder setDataTypeId:(CRRequestType)Bookmark];
        RequestBookmarksCall = [RequestBookmarksCallBuilder build];
    }

    [self RequestGoogleSyncUpdates: [[NSArray alloc] initWithObjects:RequestBookmarksCall,RequestHistoryCall, nil] CallerInfo:[[[[GetUpdatesCallerInfo_Builder alloc] init] setSource:GetUpdatesCallerInfo_GetUpdatesSourcePeriodic] build] ClientID:[self GenerateClientID] InfiniteLoop:YES];
}

- (NSString*) BookmarksRootID
{
    if (BID != nil)
        return BID;
    else
    {
        FMResultSet *Query = [DB executeQuery:@"SELECT ID FROM CRBookmarks WHERE ServerTag='google_chrome_bookmarks'"];
        
        if ([Query next]) 
        {
            BID = [Query stringForColumnIndex:0];
            return BID;
        }
        
        return @"";
    }
}

- (NSArray *) ReadBookmarks: (NSString *) ID
{
    NSMutableArray *Childs = [[NSMutableArray alloc] init];
    
    FMResultSet *BookmarksQuery = [DB executeQuery:@"SELECT ID, IsFolder, Name, Url, Favicon, ServerTag FROM CRBookmarks WHERE ParentID=? ORDER BY IsFolder DESC, Name ASC" withArgumentsInArray:[[NSArray alloc] initWithObjects:ID, nil]];
    
    while ([BookmarksQuery next])
    {
        NSMutableDictionary *Bookmark = [[NSMutableDictionary alloc] init];
        [Bookmark setValue:[BookmarksQuery stringForColumn:@"ID"] forKey:@"ID"];
        [Bookmark setValue:[NSNumber numberWithBool:[BookmarksQuery boolForColumn:@"IsFolder"]] forKey:@"IsFolder"];
        [Bookmark setValue:[BookmarksQuery stringForColumn:@"Name"] forKey:@"Name"];
        [Bookmark setValue:[BookmarksQuery stringForColumn:@"URL"] forKey:@"URL"];
        [Bookmark setValue:[BookmarksQuery stringForColumn:@"ServerTag"] forKey:@"ServerTag"];
        [Bookmark setValue:[BookmarksQuery dataForColumn:@"Favicon"] forKey:@"Favicon"];        
        [Childs addObject:Bookmark];
    }
    
    return Childs;
}

- (NSArray *) SearchBookmarks: (NSString *) Word
{
    NSMutableArray *Childs = [[NSMutableArray alloc] init];
    
    NSString *PatternS = [[NSString alloc] initWithFormat:@"SELECT ID, IsFolder, Name, Url, Favicon, ServerTag FROM CRBookmarks WHERE (Name LIKE '%%%@%%' OR Url LIKE '%%%@%%') AND Name != '' ORDER BY IsFolder DESC, Name ASC",Word,Word];
        FMResultSet *BookmarksQuery = [DB executeQuery:PatternS];
   
    while ([BookmarksQuery next])
    {
        NSMutableDictionary *Bookmark = [[NSMutableDictionary alloc] init];
        [Bookmark setValue:[BookmarksQuery stringForColumn:@"ID"] forKey:@"ID"];
        [Bookmark setValue:[NSNumber numberWithBool:[BookmarksQuery boolForColumn:@"IsFolder"]] forKey:@"IsFolder"];
        [Bookmark setValue:[BookmarksQuery stringForColumn:@"Name"] forKey:@"Name"];
        [Bookmark setValue:[BookmarksQuery stringForColumn:@"URL"] forKey:@"URL"];
        [Bookmark setValue:[BookmarksQuery stringForColumn:@"ServerTag"] forKey:@"ServerTag"];
        [Bookmark setValue:[BookmarksQuery dataForColumn:@"Favicon"] forKey:@"Favicon"];        
        [Childs addObject:Bookmark];
    }
    
    return Childs;
}

- (NSArray *) SearchHistory: (NSString *) Word
{
    NSMutableArray *Childs = [[NSMutableArray alloc] init];
    
    NSString *PatternS = [[NSString alloc] initWithFormat:@"SELECT ID, Name, Url FROM CRHistory WHERE (Name LIKE '%%%@%%' OR Url LIKE '%%%@%%') AND Name != '' ORDER BY mtime DESC",Word,Word];
    FMResultSet *HistoryQuery = [DB executeQuery:PatternS];
    
    while ([HistoryQuery next])
    {
        NSMutableDictionary *Bookmark = [[NSMutableDictionary alloc] init];
        [Bookmark setValue:[HistoryQuery stringForColumn:@"ID"] forKey:@"ID"];
        [Bookmark setValue:[HistoryQuery stringForColumn:@"Name"] forKey:@"Name"];
        [Bookmark setValue:[HistoryQuery stringForColumn:@"URL"] forKey:@"URL"];
        [Childs addObject:Bookmark];
    }
    
    return Childs;
}

- (void) LoginAtGoogle: (NSString *) Email : (NSString *) Password 
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GoogleLogin" object:@"starting"];
    [[self delegate] Login:@"starting"];
        
    NSMutableDictionary *RequestParams = [[NSMutableDictionary alloc]init];
    [RequestParams setValue:Email forKey:@"Email"];
    [RequestParams setValue:Password forKey:@"Passwd"];
    [RequestParams setValue:@"chromiumsync" forKey:@"service"];
    [RequestParams setValue:@"true" forKey:@"PersistentCookie"];
    [RequestParams setValue:@"GOOGLE" forKey:@"accountType"];
    
    [[LRResty client] post:@"https://www.google.com/accounts/ClientLogin" payload:RequestParams withBlock:^(LRRestyResponse *response){
        if (response.status == 200)
        {            
            [Keychain setSecureValue:Password forKey:@"GooglePassword"];
            [Keychain setSecureValue:Email forKey:@"GoogleEmail"];
            
            for (NSString *ResponseLine in [[response asString] componentsSeparatedByString:@"\n"])
            {
                
                NSArray *ResponseParsed = [ResponseLine componentsSeparatedByString:@"="];
                if ([ResponseParsed count] == 2)
                {
                    [Keychain setSecureValue:[ResponseParsed objectAtIndex:1] forKey:[ResponseParsed objectAtIndex:0]];
                }
                
            }
            [[self delegate] Login:@"success"];
        }
        else 
        {
            if (response.status == 0)
            {   
                [[self delegate] Login:@"error_network"];
            }
            else 
            {
                [[self delegate] Login:@"error_password"];
            }
        }
    }];
}

- (NSString *) GenerateClientID
{    
    // TODO: get client ID from https://sb-ssl.google.com/safebrowsing/newkey?client=googlechrome&appver=20.0.1103.0&pver=2.2
    
    NSString *ClientIDPlain = [[NSString alloc] init];
    
    if (![UserSettings objectForKey:@"ClientID"])
    {
        ClientIDPlain = (__bridge NSString *) CFUUIDCreateString(NULL, CFUUIDCreate(NULL));
        [UserSettings setValue:ClientIDPlain forKey:@"ClientID"];
        [UserSettings synchronize];
    }
    else 
    {
        ClientIDPlain = [UserSettings objectForKey:@"ClientID"];
    }
    return ClientIDPlain;
}

- (void) RequestNigoriInitial
{
    [self RequestGoogleSyncUpdates: [[NSArray alloc] initWithObjects:[[[[DataTypeProgressMarker_Builder alloc] init] setDataTypeId:(CRRequestType)Nigori] build], nil] CallerInfo:[[[[GetUpdatesCallerInfo_Builder alloc] init] setSource:GetUpdatesCallerInfo_GetUpdatesSourceNewClient] build] ClientID:[self GenerateClientID] InfiniteLoop:NO];
}

- (void) RequestBookmarks
{
    DataTypeProgressMarker *RequestBookmarksCall; 
    
    if ([UserSettings objectForKey:@"ProgressMarker_32904"] == nil)
    {
        RequestBookmarksCall = [[[[DataTypeProgressMarker_Builder alloc] init] setDataTypeId:(CRRequestType)Bookmark] build];
    }
    else 
    {
        DataTypeProgressMarker_Builder *RequestBookmarksCallBuilder = [[DataTypeProgressMarker_Builder alloc] init];
        [RequestBookmarksCallBuilder setToken:[UserSettings objectForKey:@"ProgressMarker_32904"]];
        [RequestBookmarksCallBuilder setDataTypeId:(CRRequestType)Bookmark];
        RequestBookmarksCall = [RequestBookmarksCallBuilder build];
    }
    
    [self RequestGoogleSyncUpdates: [[NSArray alloc] initWithObjects:RequestBookmarksCall, nil] CallerInfo:[[[[GetUpdatesCallerInfo_Builder alloc] init] setSource:GetUpdatesCallerInfo_GetUpdatesSourcePeriodic] build] ClientID:[self GenerateClientID] InfiniteLoop:YES];
}

- (void) RequestGoogleSyncUpdates: (NSArray *) ProgressMarkers 
         CallerInfo: (GetUpdatesCallerInfo *) CallerInfo 
         ClientID:(NSString *) ClientID 
         InfiniteLoop: (BOOL) InfiniteLoop
{        
    [[self delegate] Synchronization:@"started"];
    
    ClientToServerMessage_Builder *CTSMessage = [[ClientToServerMessage_Builder alloc] init];
    [CTSMessage setShare:[Keychain secureValueForKey:@"GoogleEmail"]];
    [CTSMessage setMessageContents: ClientToServerMessage_ContentsGetUpdates];
    [CTSMessage setProtocolVersion: 31];

    if([UserSettings valueForKey:@"StoreBirthday"] != Nil) 
        [CTSMessage setStoreBirthday:[UserSettings valueForKey:@"StoreBirthday"]];
    
    GetUpdatesMessage_Builder *CTSMessageGetUpdates = [[GetUpdatesMessage_Builder alloc] init];
    [CTSMessageGetUpdates setFetchFolders:YES];
    [CTSMessageGetUpdates setCallerInfo:CallerInfo];
    
    [CTSMessageGetUpdates addAllFromProgressMarker:ProgressMarkers];
    
    [CTSMessage setGetUpdates:[CTSMessageGetUpdates build]];
    
    ClientToServerMessage *CTSMessageRequest = [CTSMessage build];
    
    NSMutableData *CTSMessageData = [NSMutableData dataWithLength:CTSMessageRequest.serializedSize];
    PBCodedOutputStream* CTSMessageRequestStream = [PBCodedOutputStream streamWithData:CTSMessageData];
    [CTSMessageRequest writeToCodedOutputStream:CTSMessageRequestStream];
    
    NSDictionary *CTSMessageRequestHeaders = [[NSDictionary alloc] initWithObjectsAndKeys:
                                              UserAgent, @"UserAgent",
                                              [[NSString alloc] initWithFormat:@"GoogleLogin auth=%@",[Keychain secureValueForKey:@"Auth"]], @"Authorization", nil];
    [[LRResty client] 
     post:[[NSString alloc] initWithFormat:@"https://clients4.google.com/chrome-sync/command/?client_id=%@", ClientID]
     payload:CTSMessageData 
     headers:CTSMessageRequestHeaders 
     withBlock:^(LRRestyResponse *CRServerResponse) 
     {
         if ([CRServerResponse status] == 200)
         {
             ClientToServerResponse *STCResponse = [[[[ClientToServerResponse_Builder alloc] init] mergeFromData:[CRServerResponse responseData]] build];
    
             [UserSettings setValue:[STCResponse storeBirthday] forKey:@"StoreBirthday"];
             
             if ([STCResponse hasError] || ![STCResponse hasGetUpdates])
             {
                 [[self delegate] Synchronization:@"error_2"];
             }
             else
             {
                BOOL ContinueInfiniteLoop = InfiniteLoop;
                if ([[STCResponse getUpdates] changesRemaining] == 0) ContinueInfiniteLoop = NO;

                 for (SyncEntity *SyncItem in [[STCResponse getUpdates] entriesList])
                 {
                    if ([[SyncItem specifics] hasNigori])
                     {
                         NigoriSpecifics *NigoriValue = [[SyncItem specifics] nigori];
                         
                         if ([NigoriValue hasEncrypted])
                         {
                             EncryptedData *EncryptedNigori = [NigoriValue encrypted];
                             [UserSettings setValue:[EncryptedNigori blob] forKey:@"tblob"];
                         }
                         
                         [UserSettings setValue:[NSNumber numberWithBool:[NigoriValue encryptBookmarks]] forKey:@"encryptBookmarks"];
                         [UserSettings setValue:[NSNumber numberWithBool:[NigoriValue encryptTypedUrls]] forKey:@"encryptTypedUrls"];
                         [UserSettings setValue:[NSNumber numberWithBool:[NigoriValue encryptEverything]] forKey:@"encryptEverything"];
                         [UserSettings synchronize];
                     }
                     else if ([[SyncItem specifics] hasBookmark]) 
                     {
                         BookmarkSpecifics *BookmarkValue = [[SyncItem specifics] bookmark];
                                                
                         NSDictionary *BookmarkDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                       [[SyncItem idString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]], @"id",
                                                       [[SyncItem parentIdString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]], @"parentId",
                                                       [NSNumber numberWithInt:[SyncItem folder]], @"isFolder", 
                                                       [[SyncItem serverDefinedUniqueTag] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]], @"serverTag",
                                                       [NSNumber numberWithInt:[SyncItem ctime]], @"cTime",
                                                       [NSNumber numberWithInt:[SyncItem mtime]], @"mTime",
                                                       [[BookmarkValue title] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]], @"name",
                                                       [[BookmarkValue url] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]], @"url",
                                                       [BookmarkValue favicon], @"favicon",
                        nil];
                         
                        if ([[BookmarkDict objectForKey:@"url"] length] > 0 || [[BookmarkDict objectForKey:@"serverTag"] length] > 0 || [BookmarkDict objectForKey:@"isFolder"] == [NSNumber numberWithInt:1])
                             [DB executeUpdate:@"INSERT OR REPLACE INTO CRBookmarks (ID, ParentID, IsFolder, ServerTag, CTime, MTime, Name, URL, Favicon) VALUES (:id, :parentId, :isFolder, :serverTag, :cTime, :mTime, :name, :url, :favicon)" withParameterDictionary:BookmarkDict];
                         
                     }
                     else if ([[SyncItem specifics] hasTypedUrl]) 
                     {
                         TypedUrlSpecifics *HistoryValue = [[SyncItem specifics] typedUrl];
                         
                         NSDictionary *HistoryDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                       [[SyncItem idString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]], @"id",
                                                       [NSNumber numberWithInt:[SyncItem ctime]], @"cTime",
                                                       [NSNumber numberWithInt:[SyncItem mtime]], @"mTime",
                                                       [[HistoryValue title] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]], @"name",
                                                       [[HistoryValue url] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]], @"url",

                        nil];
                         
                        if ([[HistoryDict objectForKey:@"url"] length] > 0)
                             [DB executeUpdate:@"INSERT OR REPLACE INTO CRHistory (ID, CTime, MTime, Name, URL) VALUES (:id,:cTime,:mTime,:name,:url)" withParameterDictionary:HistoryDict];
                         
                     }
                 }
                                  
                 NSMutableArray *newProgressMarkers = [[NSMutableArray alloc] init];
                 
                 for(DataTypeProgressMarker *NewProgressMarker in [[STCResponse getUpdates] newProgressMarkerList])
                 {
                     [UserSettings setValue:[NewProgressMarker token] forKey:[[NSString alloc] initWithFormat:@"ProgressMarker_%i",[NewProgressMarker dataTypeId]]];
                                            
                     DataTypeProgressMarker_Builder *ProgressMarkedAdd = [[DataTypeProgressMarker_Builder alloc] init];
                     [ProgressMarkedAdd setToken:[NewProgressMarker token]];
                     [ProgressMarkedAdd setDataTypeId:[NewProgressMarker dataTypeId]];
                     [newProgressMarkers addObject:[ProgressMarkedAdd build]];
                 }
                 
                 [UserSettings synchronize];
                 
                 if (!ContinueInfiniteLoop)
                     [[self delegate] Synchronization:@"success"];
                 
                 if (ContinueInfiniteLoop)
                 {                        
                     [self RequestGoogleSyncUpdates: newProgressMarkers
                           CallerInfo:[[[[GetUpdatesCallerInfo_Builder alloc] init] setSource:GetUpdatesCallerInfo_GetUpdatesSourceSyncCycleContinuation] build] 
                           ClientID:ClientID 
                           InfiniteLoop:ContinueInfiniteLoop];
                 }
             }
         }
         else 
         {
             if ([CRServerResponse status] == 0)
             {
                 [[self delegate] Synchronization:@"error_0"];
             }
             else
             {
                [[self delegate] Synchronization:@"error_1"];
             }
         }
     }];
}
@end
