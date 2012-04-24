// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "ProtocolBuffers.h"

@class ExtensionSpecifics;
@class ExtensionSpecifics_Builder;

@interface ExtensionSpecificsRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
@end

@interface ExtensionSpecifics : PBGeneratedMessage {
@private
  BOOL hasEnabled_:1;
  BOOL hasIncognitoEnabled_:1;
  BOOL hasId_:1;
  BOOL hasVersion_:1;
  BOOL hasUpdateUrl_:1;
  BOOL hasName_:1;
  BOOL enabled_:1;
  BOOL incognitoEnabled_:1;
  NSString* id;
  NSString* version;
  NSString* updateUrl;
  NSString* name;
}
- (BOOL) hasId;
- (BOOL) hasVersion;
- (BOOL) hasUpdateUrl;
- (BOOL) hasEnabled;
- (BOOL) hasIncognitoEnabled;
- (BOOL) hasName;
@property (readonly, retain) NSString* id;
@property (readonly, retain) NSString* version;
@property (readonly, retain) NSString* updateUrl;
- (BOOL) enabled;
- (BOOL) incognitoEnabled;
@property (readonly, retain) NSString* name;

+ (ExtensionSpecifics*) defaultInstance;
- (ExtensionSpecifics*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (ExtensionSpecifics_Builder*) builder;
+ (ExtensionSpecifics_Builder*) builder;
+ (ExtensionSpecifics_Builder*) builderWithPrototype:(ExtensionSpecifics*) prototype;

+ (ExtensionSpecifics*) parseFromData:(NSData*) data;
+ (ExtensionSpecifics*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (ExtensionSpecifics*) parseFromInputStream:(NSInputStream*) input;
+ (ExtensionSpecifics*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (ExtensionSpecifics*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (ExtensionSpecifics*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface ExtensionSpecifics_Builder : PBGeneratedMessage_Builder {
@private
  ExtensionSpecifics* result;
}

- (ExtensionSpecifics*) defaultInstance;

- (ExtensionSpecifics_Builder*) clear;
- (ExtensionSpecifics_Builder*) clone;

- (ExtensionSpecifics*) build;
- (ExtensionSpecifics*) buildPartial;

- (ExtensionSpecifics_Builder*) mergeFrom:(ExtensionSpecifics*) other;
- (ExtensionSpecifics_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (ExtensionSpecifics_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasId;
- (NSString*) id;
- (ExtensionSpecifics_Builder*) setId:(NSString*) value;
- (ExtensionSpecifics_Builder*) clearId;

- (BOOL) hasVersion;
- (NSString*) version;
- (ExtensionSpecifics_Builder*) setVersion:(NSString*) value;
- (ExtensionSpecifics_Builder*) clearVersion;

- (BOOL) hasUpdateUrl;
- (NSString*) updateUrl;
- (ExtensionSpecifics_Builder*) setUpdateUrl:(NSString*) value;
- (ExtensionSpecifics_Builder*) clearUpdateUrl;

- (BOOL) hasEnabled;
- (BOOL) enabled;
- (ExtensionSpecifics_Builder*) setEnabled:(BOOL) value;
- (ExtensionSpecifics_Builder*) clearEnabled;

- (BOOL) hasIncognitoEnabled;
- (BOOL) incognitoEnabled;
- (ExtensionSpecifics_Builder*) setIncognitoEnabled:(BOOL) value;
- (ExtensionSpecifics_Builder*) clearIncognitoEnabled;

- (BOOL) hasName;
- (NSString*) name;
- (ExtensionSpecifics_Builder*) setName:(NSString*) value;
- (ExtensionSpecifics_Builder*) clearName;
@end

