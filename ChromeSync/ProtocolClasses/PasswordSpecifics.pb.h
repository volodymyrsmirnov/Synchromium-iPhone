// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "ProtocolBuffers.h"

#import "Encryption.pb.h"

@class EncryptedData;
@class EncryptedData_Builder;
@class PasswordSpecifics;
@class PasswordSpecificsData;
@class PasswordSpecificsData_Builder;
@class PasswordSpecifics_Builder;

@interface PasswordSpecificsRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
@end

@interface PasswordSpecificsData : PBGeneratedMessage {
@private
  BOOL hasSslValid_:1;
  BOOL hasPreferred_:1;
  BOOL hasBlacklisted_:1;
  BOOL hasDateCreated_:1;
  BOOL hasScheme_:1;
  BOOL hasSignonRealm_:1;
  BOOL hasOrigin_:1;
  BOOL hasAction_:1;
  BOOL hasUsernameElement_:1;
  BOOL hasUsernameValue_:1;
  BOOL hasPasswordElement_:1;
  BOOL hasPasswordValue_:1;
  BOOL sslValid_:1;
  BOOL preferred_:1;
  BOOL blacklisted_:1;
  int64_t dateCreated;
  int32_t scheme;
  NSString* signonRealm;
  NSString* origin;
  NSString* action;
  NSString* usernameElement;
  NSString* usernameValue;
  NSString* passwordElement;
  NSString* passwordValue;
}
- (BOOL) hasScheme;
- (BOOL) hasSignonRealm;
- (BOOL) hasOrigin;
- (BOOL) hasAction;
- (BOOL) hasUsernameElement;
- (BOOL) hasUsernameValue;
- (BOOL) hasPasswordElement;
- (BOOL) hasPasswordValue;
- (BOOL) hasSslValid;
- (BOOL) hasPreferred;
- (BOOL) hasDateCreated;
- (BOOL) hasBlacklisted;
@property (readonly) int32_t scheme;
@property (readonly, retain) NSString* signonRealm;
@property (readonly, retain) NSString* origin;
@property (readonly, retain) NSString* action;
@property (readonly, retain) NSString* usernameElement;
@property (readonly, retain) NSString* usernameValue;
@property (readonly, retain) NSString* passwordElement;
@property (readonly, retain) NSString* passwordValue;
- (BOOL) sslValid;
- (BOOL) preferred;
@property (readonly) int64_t dateCreated;
- (BOOL) blacklisted;

+ (PasswordSpecificsData*) defaultInstance;
- (PasswordSpecificsData*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (PasswordSpecificsData_Builder*) builder;
+ (PasswordSpecificsData_Builder*) builder;
+ (PasswordSpecificsData_Builder*) builderWithPrototype:(PasswordSpecificsData*) prototype;

+ (PasswordSpecificsData*) parseFromData:(NSData*) data;
+ (PasswordSpecificsData*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (PasswordSpecificsData*) parseFromInputStream:(NSInputStream*) input;
+ (PasswordSpecificsData*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (PasswordSpecificsData*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (PasswordSpecificsData*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface PasswordSpecificsData_Builder : PBGeneratedMessage_Builder {
@private
  PasswordSpecificsData* result;
}

- (PasswordSpecificsData*) defaultInstance;

- (PasswordSpecificsData_Builder*) clear;
- (PasswordSpecificsData_Builder*) clone;

- (PasswordSpecificsData*) build;
- (PasswordSpecificsData*) buildPartial;

- (PasswordSpecificsData_Builder*) mergeFrom:(PasswordSpecificsData*) other;
- (PasswordSpecificsData_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (PasswordSpecificsData_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasScheme;
- (int32_t) scheme;
- (PasswordSpecificsData_Builder*) setScheme:(int32_t) value;
- (PasswordSpecificsData_Builder*) clearScheme;

- (BOOL) hasSignonRealm;
- (NSString*) signonRealm;
- (PasswordSpecificsData_Builder*) setSignonRealm:(NSString*) value;
- (PasswordSpecificsData_Builder*) clearSignonRealm;

- (BOOL) hasOrigin;
- (NSString*) origin;
- (PasswordSpecificsData_Builder*) setOrigin:(NSString*) value;
- (PasswordSpecificsData_Builder*) clearOrigin;

- (BOOL) hasAction;
- (NSString*) action;
- (PasswordSpecificsData_Builder*) setAction:(NSString*) value;
- (PasswordSpecificsData_Builder*) clearAction;

- (BOOL) hasUsernameElement;
- (NSString*) usernameElement;
- (PasswordSpecificsData_Builder*) setUsernameElement:(NSString*) value;
- (PasswordSpecificsData_Builder*) clearUsernameElement;

- (BOOL) hasUsernameValue;
- (NSString*) usernameValue;
- (PasswordSpecificsData_Builder*) setUsernameValue:(NSString*) value;
- (PasswordSpecificsData_Builder*) clearUsernameValue;

- (BOOL) hasPasswordElement;
- (NSString*) passwordElement;
- (PasswordSpecificsData_Builder*) setPasswordElement:(NSString*) value;
- (PasswordSpecificsData_Builder*) clearPasswordElement;

- (BOOL) hasPasswordValue;
- (NSString*) passwordValue;
- (PasswordSpecificsData_Builder*) setPasswordValue:(NSString*) value;
- (PasswordSpecificsData_Builder*) clearPasswordValue;

- (BOOL) hasSslValid;
- (BOOL) sslValid;
- (PasswordSpecificsData_Builder*) setSslValid:(BOOL) value;
- (PasswordSpecificsData_Builder*) clearSslValid;

- (BOOL) hasPreferred;
- (BOOL) preferred;
- (PasswordSpecificsData_Builder*) setPreferred:(BOOL) value;
- (PasswordSpecificsData_Builder*) clearPreferred;

- (BOOL) hasDateCreated;
- (int64_t) dateCreated;
- (PasswordSpecificsData_Builder*) setDateCreated:(int64_t) value;
- (PasswordSpecificsData_Builder*) clearDateCreated;

- (BOOL) hasBlacklisted;
- (BOOL) blacklisted;
- (PasswordSpecificsData_Builder*) setBlacklisted:(BOOL) value;
- (PasswordSpecificsData_Builder*) clearBlacklisted;
@end

@interface PasswordSpecifics : PBGeneratedMessage {
@private
  BOOL hasEncrypted_:1;
  EncryptedData* encrypted;
}
- (BOOL) hasEncrypted;
@property (readonly, retain) EncryptedData* encrypted;

+ (PasswordSpecifics*) defaultInstance;
- (PasswordSpecifics*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (PasswordSpecifics_Builder*) builder;
+ (PasswordSpecifics_Builder*) builder;
+ (PasswordSpecifics_Builder*) builderWithPrototype:(PasswordSpecifics*) prototype;

+ (PasswordSpecifics*) parseFromData:(NSData*) data;
+ (PasswordSpecifics*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (PasswordSpecifics*) parseFromInputStream:(NSInputStream*) input;
+ (PasswordSpecifics*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (PasswordSpecifics*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (PasswordSpecifics*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface PasswordSpecifics_Builder : PBGeneratedMessage_Builder {
@private
  PasswordSpecifics* result;
}

- (PasswordSpecifics*) defaultInstance;

- (PasswordSpecifics_Builder*) clear;
- (PasswordSpecifics_Builder*) clone;

- (PasswordSpecifics*) build;
- (PasswordSpecifics*) buildPartial;

- (PasswordSpecifics_Builder*) mergeFrom:(PasswordSpecifics*) other;
- (PasswordSpecifics_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (PasswordSpecifics_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasEncrypted;
- (EncryptedData*) encrypted;
- (PasswordSpecifics_Builder*) setEncrypted:(EncryptedData*) value;
- (PasswordSpecifics_Builder*) setEncryptedBuilder:(EncryptedData_Builder*) builderForValue;
- (PasswordSpecifics_Builder*) mergeEncrypted:(EncryptedData*) value;
- (PasswordSpecifics_Builder*) clearEncrypted;
@end

