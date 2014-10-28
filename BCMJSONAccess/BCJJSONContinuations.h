//
//  BCJJSONContinuations.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 27/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLContinuation.h"



#pragma mark - Macro defines
#define BCJ_OVERLOADABLE __attribute__((overloadable))

#ifdef DEBUG
#define BCJ_KEY(NAME) NSStringFromSelector(@selector(NAME))
#else
#define BCJ_KEY(NAME) @"" #NAME
#endif



#pragma mark - Constants
typedef NS_OPTIONS(NSUInteger, BCJJSONReadingOptions) {
    BCJJSONReadingMutableContainers  = (1UL  << 0),
    BCJJSONReadingMutableLeaves  = (1UL  << 1),
};



typedef NS_OPTIONS(NSUInteger, BCJGetterOptions) {
    BCJGetterOptionReplaceNullWithNil  = (1UL  << 0),
    BCJGetterOptionReplaceNilWithDefaultValue = (1UL  << 1),
    BCJGetterOptionAllowsNilValue  = (1UL  << 2),
};

//Getter modes (i.e. predefined getter options)
typedef BCJGetterOptions BCJGetterMode;
const static BCJGetterMode BCJGetterModeMantatory           = 0;
const static BCJGetterMode BCJGetterModeOptional            = BCJGetterOptionAllowsNilValue;
const static BCJGetterMode BCJGetterModeDefaultable         = BCJGetterOptionAllowsNilValue     | BCJGetterOptionReplaceNilWithDefaultValue;
const static BCJGetterMode BCJGetterModeNullableOptional    = BCJGetterOptionReplaceNullWithNil | BCJGetterOptionAllowsNilValue;
const static BCJGetterMode BCJGetterModeNullableDefaultable = BCJGetterOptionReplaceNullWithNil | BCJGetterOptionAllowsNilValue | BCJGetterOptionReplaceNilWithDefaultValue;



#pragma mark - Type checking continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJIsOfKindClass(id object, Class class, void(^successBlock)(id object)) __attribute__((nonnull(1,2,3)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJIsOfKindClass(id object, Class class) __attribute__((nonnull(1,2)));



#pragma mark - JSON Creation continuations
//Block result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(NSData *data, Class class, BCJJSONReadingOptions options, void(^successBlock)(id fragment)) __attribute__((nonnull(1,2,4)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(NSData *data, Class class, void(^successBlock)(id fragment)) __attribute__((nonnull(1,2,3)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(NSData *data, BCJJSONReadingOptions options, void(^successBlock)(NSArray *array)) __attribute__((nonnull(1,3)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(NSData *data, void(^successBlock)(NSArray *array)) __attribute__((nonnull(1,2)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(NSData *data, BCJJSONReadingOptions options, void(^successBlock)(NSDictionary *dictionary)) __attribute__((nonnull(1,3)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(NSData *data, void(^successBlock)(NSDictionary *dictionary)) __attribute__((nonnull(1,2)));

//outValue result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(NSData *data, Class class, BCJJSONReadingOptions options, id *outValue) __attribute__((nonnull(1,2,4)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(NSData *data, NSArray **outArray) __attribute__((nonnull(1,2)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(NSData *data, NSDictionary **outDictionary) __attribute__((nonnull(1,2)));



#pragma mark - Get arbitary object continuations
//Block result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJGetValue(NSArray *array, NSUInteger idx, Class class, BCJGetterOptions options, id defaultValue, void(^successBlock)(id value)) __attribute__((nonnull(1,3,6)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJGetValue(NSDictionary *dict, id key, Class class, BCJGetterOptions options, id defaultValue, void(^successBlock)(id value)) __attribute__((nonnull(1,2,3,6)));



#pragma mark - Set arbitary object continuations
//KVC result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetValue(NSArray *array, NSUInteger idx, Class class, BCJGetterOptions options, id defaultValue, id target, NSString *targetKey) __attribute__((nonnull(1,3,6,7)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJSetValue(NSDictionary *dict, id key, Class class, BCJGetterOptions options, id defaultValue, id target, NSString *targetKey) __attribute__((nonnull(1,2,3,6,7)));

//outValue result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetValue(NSArray *array, NSUInteger idx, Class class, BCJGetterOptions options, id defaultValue, id *outValue) __attribute__((nonnull(1,3,6)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJSetValue(NSDictionary *dict, id key, Class class, BCJGetterOptions options, id defaultValue, id *outValue) __attribute__((nonnull(1,2,3,6)));



#pragma mark - Set NSArray continuations
//KVC result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(NSArray *array, NSUInteger idx, BCJGetterOptions options, NSArray *defaultValue, id target, NSString *targetKey)  __attribute__((nonnull(1,5,6)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(NSArray *array, NSUInteger idx, id target, NSString *targetKey) __attribute__((nonnull(1,3,4)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(NSDictionary *dict, id key, BCJGetterOptions options, NSArray *defaultValue, id target, NSString *targetKey)  __attribute__((nonnull(1,2,5,6)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(NSDictionary *dict, id key, id target, NSString *targetKey) __attribute__((nonnull(1,2,3,4)));



#pragma mark - Set NSMutableArray continuations
//KVC result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(NSArray *array, NSUInteger idx, BCJGetterOptions options, NSMutableArray *defaultValue, id target, NSString *targetKey)  __attribute__((nonnull(1,5,6)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(NSArray *array, NSUInteger idx, id target, NSString *targetKey) __attribute__((nonnull(1,3,4)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(NSDictionary *dict, id key, BCJGetterOptions options, NSMutableArray *defaultValue, id target, NSString *targetKey)  __attribute__((nonnull(1,2,5,6)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(NSDictionary *dict, id key, id target, NSString *targetKey) __attribute__((nonnull(1,2,3,4)));



#pragma mark - Set NSDictionary continuations
//KVC result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(NSArray *array, NSUInteger idx, BCJGetterOptions options, NSDictionary *defaultValue, id target, NSString *targetKey)  __attribute__((nonnull(1,5,6)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(NSArray *array, NSUInteger idx, id target, NSString *targetKey) __attribute__((nonnull(1,3,4)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(NSDictionary *dict, id key, BCJGetterOptions options, NSDictionary *defaultValue, id target, NSString *targetKey) __attribute__((nonnull(1,2,5,6)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(NSDictionary *dict, id key, id target, NSString *targetKey)__attribute__((nonnull(1,2,3,4)));



#pragma mark - Set NSMutableDictionary continuations
//KVC result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(NSArray *array, NSUInteger idx, BCJGetterOptions options, NSMutableDictionary *defaultValue, id target, NSString *targetKey)  __attribute__((nonnull(1,5,6)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(NSArray *array, NSUInteger idx, id target, NSString *targetKey) __attribute__((nonnull(1,3,4)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(NSDictionary *dict, id key, BCJGetterOptions options, NSMutableDictionary *defaultValue, id target, NSString *targetKey) __attribute__((nonnull(1,2,5,6)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(NSDictionary *dict, id key, id target, NSString *targetKey)__attribute__((nonnull(1,2,3,4)));



#pragma mark - Set NSString continuations
//KVC result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(NSArray *array, NSUInteger idx, BCJGetterOptions options, NSString *defaultValue, id target, NSString *targetKey)  __attribute__((nonnull(1,5,6)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(NSArray *array, NSUInteger idx, id target, NSString *targetKey) __attribute__((nonnull(1,3,4)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(NSDictionary *dict, id key, BCJGetterOptions options, NSString *defaultValue, id target, NSString *targetKey) __attribute__((nonnull(1,2,5,6)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(NSDictionary *dict, id key, id target, NSString *targetKey) __attribute__((nonnull(1,2,3,4)));



#pragma mark - Set NSMutableString continuations
//KVC result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(NSArray *array, NSUInteger idx, BCJGetterOptions options, NSMutableString *defaultValue, id target, NSString *targetKey)  __attribute__((nonnull(1,5,6)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(NSArray *array, NSUInteger idx, id target, NSString *targetKey) __attribute__((nonnull(1,3,4)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(NSDictionary *dict, id key, BCJGetterOptions options, NSMutableString *defaultValue, id target, NSString *targetKey) __attribute__((nonnull(1,2,5,6)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(NSDictionary *dict, id key, id target, NSString *targetKey) __attribute__((nonnull(1,2,3,4)));



#pragma mark - Set NSNumber continuations
//KVC result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(NSArray *array, NSUInteger idx, BCJGetterOptions options, NSNumber *defaultValue, id target, NSString *targetKey)  __attribute__((nonnull(1,5,6)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(NSArray *array, NSUInteger idx, id target, NSString *targetKey) __attribute__((nonnull(1,3,4)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(NSDictionary *dict, id key, BCJGetterOptions options, NSNumber *defaultValue, id target, NSString *targetKey) __attribute__((nonnull(1,2,5,6)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(NSDictionary *dict, id key, id target, NSString *targetKey) __attribute__((nonnull(1,2,3,4)));



#pragma mark - Set NSNull continuations
//KVC result-style
//TODO: It doesn't make sense to use BCJGetterOptionReplaceNullWithNil (and the derived modes). Should this be raise an exception?
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(NSArray *array, NSUInteger idx, BCJGetterOptions options, id target, NSString *targetKey) __attribute__((nonnull(1,4,5)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(NSArray *array, NSUInteger idx, id target, NSString *targetKey) __attribute__((nonnull(1,3,4)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(NSDictionary *dict, id key, BCJGetterOptions options, id target, NSString *targetKey) __attribute__((nonnull(1,2,4,5)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(NSDictionary *dict, id key, id target, NSString *targetKey) __attribute__((nonnull(1,2,3,4)));



#pragma mark - Get Enum continuations
//Block result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJGetEnum(NSArray *array, NSUInteger idx, BCJGetterOptions options, id defaultValue, NSDictionary *enumMapping, void(^successBlock)(id enumValue)) __attribute__((nonnull(1,5,6)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJGetEnum(NSDictionary *dict, id key, BCJGetterOptions options, id defaultValue, NSDictionary *enumMapping, void(^successBlock)(id enumValue)) __attribute__((nonnull(1,2,5,6)));



#pragma mark - Set Enum continuations
//KVC result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetEnum(NSArray *array, NSUInteger idx, BCJGetterOptions options, id defaultValue, NSDictionary *enumMapping, id target, NSString *targetKey) __attribute__((nonnull(1,5,6,7)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetEnum(NSDictionary *dict, id key, BCJGetterOptions options, id defaultValue, NSDictionary *enumMapping, id target, NSString *targetKey) __attribute__((nonnull(1,2,5,6,7)));
