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
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSArray *defaultValue, id target, NSString *targetKey)  __attribute__((nonnull(1,5,6)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(id<BCJIndexedContainer> array, NSUInteger idx, id target, NSString *targetKey) __attribute__((nonnull(1,3,4)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSArray *defaultValue, id target, NSString *targetKey)  __attribute__((nonnull(1,2,5,6)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(id<BCJKeyedContainer> dict, id key, id target, NSString *targetKey) __attribute__((nonnull(1,2,3,4)));



#pragma mark - Set NSMutableArray continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSMutableArray *defaultValue, id target, NSString *targetKey)  __attribute__((nonnull(1,5,6)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(id<BCJIndexedContainer> array, NSUInteger idx, id target, NSString *targetKey) __attribute__((nonnull(1,3,4)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSMutableArray *defaultValue, id target, NSString *targetKey)  __attribute__((nonnull(1,2,5,6)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(id<BCJKeyedContainer> dict, id key, id target, NSString *targetKey) __attribute__((nonnull(1,2,3,4)));



#pragma mark - Set NSDictionary continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSDictionary *defaultValue, id target, NSString *targetKey)  __attribute__((nonnull(1,5,6)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(id<BCJIndexedContainer> array, NSUInteger idx, id target, NSString *targetKey) __attribute__((nonnull(1,3,4)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSDictionary *defaultValue, id target, NSString *targetKey) __attribute__((nonnull(1,2,5,6)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(id<BCJKeyedContainer> dict, id key, id target, NSString *targetKey)__attribute__((nonnull(1,2,3,4)));



#pragma mark - Set NSMutableDictionary continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSMutableDictionary *defaultValue, id target, NSString *targetKey)  __attribute__((nonnull(1,5,6)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(id<BCJIndexedContainer> array, NSUInteger idx, id target, NSString *targetKey) __attribute__((nonnull(1,3,4)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSMutableDictionary *defaultValue, id target, NSString *targetKey) __attribute__((nonnull(1,2,5,6)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(id<BCJKeyedContainer> dict, id key, id target, NSString *targetKey)__attribute__((nonnull(1,2,3,4)));



#pragma mark - Set NSString continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSString *defaultValue, id target, NSString *targetKey)  __attribute__((nonnull(1,5,6)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(id<BCJIndexedContainer> array, NSUInteger idx, id target, NSString *targetKey) __attribute__((nonnull(1,3,4)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSString *defaultValue, id target, NSString *targetKey) __attribute__((nonnull(1,2,5,6)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(id<BCJKeyedContainer> dict, id key, id target, NSString *targetKey) __attribute__((nonnull(1,2,3,4)));



#pragma mark - Set NSMutableString continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSMutableString *defaultValue, id target, NSString *targetKey)  __attribute__((nonnull(1,5,6)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(id<BCJIndexedContainer> array, NSUInteger idx, id target, NSString *targetKey) __attribute__((nonnull(1,3,4)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSMutableString *defaultValue, id target, NSString *targetKey) __attribute__((nonnull(1,2,5,6)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(id<BCJKeyedContainer> dict, id key, id target, NSString *targetKey) __attribute__((nonnull(1,2,3,4)));



#pragma mark - Set NSNumber continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSNumber *defaultValue, id target, NSString *targetKey)  __attribute__((nonnull(1,5,6)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(id<BCJIndexedContainer> array, NSUInteger idx, id target, NSString *targetKey) __attribute__((nonnull(1,3,4)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSNumber *defaultValue, id target, NSString *targetKey) __attribute__((nonnull(1,2,5,6)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(id<BCJKeyedContainer> dict, id key, id target, NSString *targetKey) __attribute__((nonnull(1,2,3,4)));



#pragma mark - Set NSNull continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, id target, NSString *targetKey) __attribute__((nonnull(1,4,5)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(id<BCJIndexedContainer> array, NSUInteger idx, id target, NSString *targetKey) __attribute__((nonnull(1,3,4)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, id target, NSString *targetKey) __attribute__((nonnull(1,2,4,5)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(id<BCJKeyedContainer> dict, id key, id target, NSString *targetKey) __attribute__((nonnull(1,2,3,4)));
