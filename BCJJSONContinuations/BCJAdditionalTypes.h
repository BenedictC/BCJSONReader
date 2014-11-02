//
//  BCJAdditionalTypes.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 31/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLContinuation.h"
#import "BCJDefines.h"
#import "BCJConstants.h"
#import "BCJContainerProtocols.h"



#pragma mark - NSDate epoch functions
BOOL BCJ_OVERLOADABLE BCJGetDateFromTimeIntervalSinceEpoch(id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSDate *defaultValue, NSDate **outDate, NSError **outError) __attribute__((nonnull(1,5,6)));

BOOL BCJ_OVERLOADABLE BCJGetDateFromTimeIntervalSinceEpoch(id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSDate *defaultValue, NSDate **outDate, NSError **outError) __attribute__((nonnull(1,2,5,6)));



#pragma mark - NSDate epoch continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromTimeIntervalSinceEpoch(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSDate *defaultValue) __attribute__((nonnull(1,2,3)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromTimeIntervalSinceEpoch(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx) __attribute__((nonnull(1,2,3)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromTimeIntervalSinceEpoch(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSDate *defaultValue) __attribute__((nonnull(1,2,3,4)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromTimeIntervalSinceEpoch(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key) __attribute__((nonnull(1,2,3,4)));



#pragma mark - NSDate ISO 8601 functions
BOOL BCJ_OVERLOADABLE BCJGetDateFromISO8601String(id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSDate *defaultValue, NSDate **outDate, NSError **outError) __attribute__((nonnull(1,5,6)));

BOOL BCJ_OVERLOADABLE BCJGetDateFromISO8601String(id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSDate *defaultValue, NSDate **outDate, NSError **outError) __attribute__((nonnull(1,2,5,6)));



#pragma mark - NSDate ISO 8601 continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromISO8601String(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSDate *defaultValue) __attribute__((nonnull(1,2,3)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromISO8601String(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx) __attribute__((nonnull(1,2,3)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromISO8601String(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSDate *defaultValue) __attribute__((nonnull(1,2,3,4)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromISO8601String(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key) __attribute__((nonnull(1,2,3,4)));



#pragma mark - GET NSURL functions
BOOL BCJ_OVERLOADABLE BCJGetURL(id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSURL *defaultValue, NSURL **outURL, NSError **outError) __attribute__((nonnull(1,5,6)));

BOOL BCJ_OVERLOADABLE BCJGetURL(id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSURL *defaultValue, NSURL **outURL, NSError **outError) __attribute__((nonnull(1,2,5,6)));



#pragma mark - Set NSURL continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetURL(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSURL *defaultValue) __attribute__((nonnull(1,2,3)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetURL(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx) __attribute__((nonnull(1,2,3)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJSetURL(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSURL *defaultValue) __attribute__((nonnull(1,2,3,4)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetURL(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key) __attribute__((nonnull(1,2,3,4)));



#pragma mark - Get Enum functions
BOOL BCJ_OVERLOADABLE BCJGetEnum(id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, id defaultValue, NSDictionary *enumMapping, id *outValue, NSError **outError) __attribute__((nonnull(1,5,6,7)));

BOOL BCJ_OVERLOADABLE BCJGetEnum(id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, id defaultValue, NSDictionary *enumMapping, id *outValue, NSError **outError) __attribute__((nonnull(1,2,5,6,7)));



#pragma mark - Set Enum continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetEnum(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, id defaultValue, NSDictionary *enumMapping) __attribute__((nonnull(1,2,3,6,7)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJSetEnum(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, id defaultValue, NSDictionary *enumMapping) __attribute__((nonnull(1,2,3,4,7)));
