//
//  BCJStandardTypes.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 31/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLContinuation.h"
#import "BCJDefines.h"
#import "BCJConstants.h"
#import "BCJContainerProtocols.h"



#pragma mark - Set NSArray continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSArray *defaultValue)  __attribute__((nonnull(1,2,3)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx) __attribute__((nonnull(1,2,3)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSArray *defaultValue)  __attribute__((nonnull(1,2,3,4)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key) __attribute__((nonnull(1,2,3,4)));



#pragma mark - Set NSMutableArray continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSMutableArray *defaultValue)  __attribute__((nonnull(1,2,3)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx) __attribute__((nonnull(1,2,3)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSMutableArray *defaultValue)  __attribute__((nonnull(1,2,3,4)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key) __attribute__((nonnull(1,2,3,4)));



#pragma mark - Set NSDictionary continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSDictionary *defaultValue)  __attribute__((nonnull(1,2,3)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx) __attribute__((nonnull(1,2,3)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSDictionary *defaultValue) __attribute__((nonnull(1,2,3,4)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key)__attribute__((nonnull(1,2,3,4)));



#pragma mark - Set NSMutableDictionary continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSMutableDictionary *defaultValue)  __attribute__((nonnull(1,2,3)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx) __attribute__((nonnull(1,2,3)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSMutableDictionary *defaultValue) __attribute__((nonnull(1,2,3,4)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key)__attribute__((nonnull(1,2,3,4)));



#pragma mark - Set NSString continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSString *defaultValue)  __attribute__((nonnull(1,2,3)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx) __attribute__((nonnull(1,2,3)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSString *defaultValue) __attribute__((nonnull(1,2,3,4)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key) __attribute__((nonnull(1,2,3,4)));



#pragma mark - Set NSMutableString continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSMutableString *defaultValue)  __attribute__((nonnull(1,2,3)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx) __attribute__((nonnull(1,2,3)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSMutableString *defaultValue) __attribute__((nonnull(1,2,3,4)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key) __attribute__((nonnull(1,2,3,4)));



#pragma mark - Set NSNumber continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSNumber *defaultValue)  __attribute__((nonnull(1,2,3)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx) __attribute__((nonnull(1,2,3)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSNumber *defaultValue) __attribute__((nonnull(1,2,3,4)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key) __attribute__((nonnull(1,2,3,4)));



#pragma mark - Set NSNull continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options) __attribute__((nonnull(1,2,3)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx) __attribute__((nonnull(1,2,3)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key, BCJGetterOptions options) __attribute__((nonnull(1,2,3,4)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key) __attribute__((nonnull(1,2,3,4)));
