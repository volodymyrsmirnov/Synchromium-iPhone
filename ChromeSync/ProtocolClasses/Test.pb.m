// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "Test.pb.h"

@implementation TestRoot
static PBExtensionRegistry* extensionRegistry = nil;
+ (PBExtensionRegistry*) extensionRegistry {
  return extensionRegistry;
}

+ (void) initialize {
  if (self == [TestRoot class]) {
    PBMutableExtensionRegistry* registry = [PBMutableExtensionRegistry registry];
    [self registerAllExtensions:registry];
    extensionRegistry = [registry retain];
  }
}
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry {
}
@end

@interface UnknownFieldsTestA ()
@property BOOL foo;
@end

@implementation UnknownFieldsTestA

- (BOOL) hasFoo {
  return !!hasFoo_;
}
- (void) setHasFoo:(BOOL) value {
  hasFoo_ = !!value;
}
- (BOOL) foo {
  return !!foo_;
}
- (void) setFoo:(BOOL) value {
  foo_ = !!value;
}
- (void) dealloc {
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.foo = NO;
  }
  return self;
}
static UnknownFieldsTestA* defaultUnknownFieldsTestAInstance = nil;
+ (void) initialize {
  if (self == [UnknownFieldsTestA class]) {
    defaultUnknownFieldsTestAInstance = [[UnknownFieldsTestA alloc] init];
  }
}
+ (UnknownFieldsTestA*) defaultInstance {
  return defaultUnknownFieldsTestAInstance;
}
- (UnknownFieldsTestA*) defaultInstance {
  return defaultUnknownFieldsTestAInstance;
}
- (BOOL) isInitialized {
  if (!self.hasFoo) {
    return NO;
  }
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasFoo) {
    [output writeBool:1 value:self.foo];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  if (self.hasFoo) {
    size += computeBoolSize(1, self.foo);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (UnknownFieldsTestA*) parseFromData:(NSData*) data {
  return (UnknownFieldsTestA*)[[[UnknownFieldsTestA builder] mergeFromData:data] build];
}
+ (UnknownFieldsTestA*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (UnknownFieldsTestA*)[[[UnknownFieldsTestA builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (UnknownFieldsTestA*) parseFromInputStream:(NSInputStream*) input {
  return (UnknownFieldsTestA*)[[[UnknownFieldsTestA builder] mergeFromInputStream:input] build];
}
+ (UnknownFieldsTestA*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (UnknownFieldsTestA*)[[[UnknownFieldsTestA builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (UnknownFieldsTestA*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (UnknownFieldsTestA*)[[[UnknownFieldsTestA builder] mergeFromCodedInputStream:input] build];
}
+ (UnknownFieldsTestA*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (UnknownFieldsTestA*)[[[UnknownFieldsTestA builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (UnknownFieldsTestA_Builder*) builder {
  return [[[UnknownFieldsTestA_Builder alloc] init] autorelease];
}
+ (UnknownFieldsTestA_Builder*) builderWithPrototype:(UnknownFieldsTestA*) prototype {
  return [[UnknownFieldsTestA builder] mergeFrom:prototype];
}
- (UnknownFieldsTestA_Builder*) builder {
  return [UnknownFieldsTestA builder];
}
@end

@interface UnknownFieldsTestA_Builder()
@property (retain) UnknownFieldsTestA* result;
@end

@implementation UnknownFieldsTestA_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.result = [[[UnknownFieldsTestA alloc] init] autorelease];
  }
  return self;
}
- (PBGeneratedMessage*) internalGetResult {
  return result;
}
- (UnknownFieldsTestA_Builder*) clear {
  self.result = [[[UnknownFieldsTestA alloc] init] autorelease];
  return self;
}
- (UnknownFieldsTestA_Builder*) clone {
  return [UnknownFieldsTestA builderWithPrototype:result];
}
- (UnknownFieldsTestA*) defaultInstance {
  return [UnknownFieldsTestA defaultInstance];
}
- (UnknownFieldsTestA*) build {
  [self checkInitialized];
  return [self buildPartial];
}
- (UnknownFieldsTestA*) buildPartial {
  UnknownFieldsTestA* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (UnknownFieldsTestA_Builder*) mergeFrom:(UnknownFieldsTestA*) other {
  if (other == [UnknownFieldsTestA defaultInstance]) {
    return self;
  }
  if (other.hasFoo) {
    [self setFoo:other.foo];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (UnknownFieldsTestA_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (UnknownFieldsTestA_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (YES) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 8: {
        [self setFoo:[input readBool]];
        break;
      }
    }
  }
}
- (BOOL) hasFoo {
  return result.hasFoo;
}
- (BOOL) foo {
  return result.foo;
}
- (UnknownFieldsTestA_Builder*) setFoo:(BOOL) value {
  result.hasFoo = YES;
  result.foo = value;
  return self;
}
- (UnknownFieldsTestA_Builder*) clearFoo {
  result.hasFoo = NO;
  result.foo = NO;
  return self;
}
@end

@interface UnknownFieldsTestB ()
@property BOOL foo;
@property BOOL bar;
@end

@implementation UnknownFieldsTestB

- (BOOL) hasFoo {
  return !!hasFoo_;
}
- (void) setHasFoo:(BOOL) value {
  hasFoo_ = !!value;
}
- (BOOL) foo {
  return !!foo_;
}
- (void) setFoo:(BOOL) value {
  foo_ = !!value;
}
- (BOOL) hasBar {
  return !!hasBar_;
}
- (void) setHasBar:(BOOL) value {
  hasBar_ = !!value;
}
- (BOOL) bar {
  return !!bar_;
}
- (void) setBar:(BOOL) value {
  bar_ = !!value;
}
- (void) dealloc {
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.foo = NO;
    self.bar = NO;
  }
  return self;
}
static UnknownFieldsTestB* defaultUnknownFieldsTestBInstance = nil;
+ (void) initialize {
  if (self == [UnknownFieldsTestB class]) {
    defaultUnknownFieldsTestBInstance = [[UnknownFieldsTestB alloc] init];
  }
}
+ (UnknownFieldsTestB*) defaultInstance {
  return defaultUnknownFieldsTestBInstance;
}
- (UnknownFieldsTestB*) defaultInstance {
  return defaultUnknownFieldsTestBInstance;
}
- (BOOL) isInitialized {
  if (!self.hasFoo) {
    return NO;
  }
  if (!self.hasBar) {
    return NO;
  }
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasFoo) {
    [output writeBool:1 value:self.foo];
  }
  if (self.hasBar) {
    [output writeBool:2 value:self.bar];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  if (self.hasFoo) {
    size += computeBoolSize(1, self.foo);
  }
  if (self.hasBar) {
    size += computeBoolSize(2, self.bar);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (UnknownFieldsTestB*) parseFromData:(NSData*) data {
  return (UnknownFieldsTestB*)[[[UnknownFieldsTestB builder] mergeFromData:data] build];
}
+ (UnknownFieldsTestB*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (UnknownFieldsTestB*)[[[UnknownFieldsTestB builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (UnknownFieldsTestB*) parseFromInputStream:(NSInputStream*) input {
  return (UnknownFieldsTestB*)[[[UnknownFieldsTestB builder] mergeFromInputStream:input] build];
}
+ (UnknownFieldsTestB*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (UnknownFieldsTestB*)[[[UnknownFieldsTestB builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (UnknownFieldsTestB*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (UnknownFieldsTestB*)[[[UnknownFieldsTestB builder] mergeFromCodedInputStream:input] build];
}
+ (UnknownFieldsTestB*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (UnknownFieldsTestB*)[[[UnknownFieldsTestB builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (UnknownFieldsTestB_Builder*) builder {
  return [[[UnknownFieldsTestB_Builder alloc] init] autorelease];
}
+ (UnknownFieldsTestB_Builder*) builderWithPrototype:(UnknownFieldsTestB*) prototype {
  return [[UnknownFieldsTestB builder] mergeFrom:prototype];
}
- (UnknownFieldsTestB_Builder*) builder {
  return [UnknownFieldsTestB builder];
}
@end

@interface UnknownFieldsTestB_Builder()
@property (retain) UnknownFieldsTestB* result;
@end

@implementation UnknownFieldsTestB_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.result = [[[UnknownFieldsTestB alloc] init] autorelease];
  }
  return self;
}
- (PBGeneratedMessage*) internalGetResult {
  return result;
}
- (UnknownFieldsTestB_Builder*) clear {
  self.result = [[[UnknownFieldsTestB alloc] init] autorelease];
  return self;
}
- (UnknownFieldsTestB_Builder*) clone {
  return [UnknownFieldsTestB builderWithPrototype:result];
}
- (UnknownFieldsTestB*) defaultInstance {
  return [UnknownFieldsTestB defaultInstance];
}
- (UnknownFieldsTestB*) build {
  [self checkInitialized];
  return [self buildPartial];
}
- (UnknownFieldsTestB*) buildPartial {
  UnknownFieldsTestB* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (UnknownFieldsTestB_Builder*) mergeFrom:(UnknownFieldsTestB*) other {
  if (other == [UnknownFieldsTestB defaultInstance]) {
    return self;
  }
  if (other.hasFoo) {
    [self setFoo:other.foo];
  }
  if (other.hasBar) {
    [self setBar:other.bar];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (UnknownFieldsTestB_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (UnknownFieldsTestB_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (YES) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 8: {
        [self setFoo:[input readBool]];
        break;
      }
      case 16: {
        [self setBar:[input readBool]];
        break;
      }
    }
  }
}
- (BOOL) hasFoo {
  return result.hasFoo;
}
- (BOOL) foo {
  return result.foo;
}
- (UnknownFieldsTestB_Builder*) setFoo:(BOOL) value {
  result.hasFoo = YES;
  result.foo = value;
  return self;
}
- (UnknownFieldsTestB_Builder*) clearFoo {
  result.hasFoo = NO;
  result.foo = NO;
  return self;
}
- (BOOL) hasBar {
  return result.hasBar;
}
- (BOOL) bar {
  return result.bar;
}
- (UnknownFieldsTestB_Builder*) setBar:(BOOL) value {
  result.hasBar = YES;
  result.bar = value;
  return self;
}
- (UnknownFieldsTestB_Builder*) clearBar {
  result.hasBar = NO;
  result.bar = NO;
  return self;
}
@end

