//
//  BCJStandardTypes.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 31/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJStandardTypes.h"
#import "BCJGettersAndSetter.h"
#import "BCJCore.h"



#pragma mark - Set NSArray continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSArray *defaultValue) {
    return BCJSetValue(target, targetKey, array, idx, NSArray.class, options, defaultValue);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx) {
    return BCJSetValue(target, targetKey, array, idx, NSArray.class, 0, nil);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSArray *defaultValue) {
    return BCJSetValue(target, targetKey, dict, key, NSArray.class, options, defaultValue);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key) {
    return BCJSetValue(target, targetKey, dict, key, NSArray.class, 0, nil);
}



#pragma mark - Set NSMutableArray continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSMutableArray *defaultValue) {
    return BCJSetValue(target, targetKey, array, idx, NSMutableArray.class, options, defaultValue);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx) {
    return BCJSetValue(target, targetKey, array, idx, NSMutableArray.class, 0, nil);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSMutableArray *defaultValue) {
    return BCJSetValue(target, targetKey, dict, key, NSMutableArray.class, options, defaultValue);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key) {
    return BCJSetValue(target, targetKey, dict, key, NSMutableArray.class, 0, nil);
}



#pragma mark - Set NSDictionary continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSDictionary *defaultValue) {
    return BCJSetValue(target, targetKey, array, idx, NSDictionary.class, options, defaultValue);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx) {
    return BCJSetValue(target, targetKey, array, idx, NSDictionary.class, 0, nil);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSDictionary *defaultValue) {
    return BCJSetValue(target, targetKey, dict, key, NSDictionary.class, options, defaultValue);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key) {
    return BCJSetValue(target, targetKey, dict, key, NSDictionary.class, 0, nil);
}



#pragma mark - Set NSMutableDictionary continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSMutableDictionary *defaultValue) {
    return BCJSetValue(target, targetKey, array, idx, NSMutableDictionary.class, options, defaultValue);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx) {
    return BCJSetValue(target, targetKey, array, idx, NSMutableDictionary.class, 0, nil);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSMutableDictionary *defaultValue) {
    return BCJSetValue(target, targetKey, dict, key, NSMutableDictionary.class, options, defaultValue);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key) {
    return BCJSetValue(target, targetKey, dict, key, NSMutableDictionary.class, 0, nil);
}



#pragma mark - Set NSString continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSString *defaultValue) {
    return BCJSetValue(target, targetKey, array, idx, NSString.class, options, defaultValue);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx) {
    return BCJSetValue(target, targetKey, array, idx, NSString.class, 0, nil);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSString *defaultValue) {
    return BCJSetValue(target, targetKey, dict, key, NSString.class, options, defaultValue);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key) {
    return BCJSetValue(target, targetKey, dict, key, NSString.class, 0, nil);
}



#pragma mark - Set NSMutableString continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSMutableString *defaultValue) {
    return BCJSetValue(target, targetKey, array, idx, NSMutableString.class, options, defaultValue);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx) {
    return BCJSetValue(target, targetKey, array, idx, NSMutableString.class, 0, nil);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSMutableString *defaultValue) {
    return BCJSetValue(target, targetKey, dict, key, NSMutableString.class, options, defaultValue);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key) {
    return BCJSetValue(target, targetKey, dict, key, NSMutableString.class, 0, nil);
}



#pragma mark - Set NSNumber continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSNumber *defaultValue) {
    return BCJSetValue(target, targetKey, array, idx, NSNumber.class, options, defaultValue);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx) {
    return BCJSetValue(target, targetKey, array, idx, NSNumber.class, 0, nil);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSNumber *defaultValue) {
    return BCJSetValue(target, targetKey, dict, key, NSNumber.class, options, defaultValue);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key) {
    return BCJSetValue(target, targetKey, dict, key, NSNumber.class, 0, nil);
}



#pragma mark - Set NSNull continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options) {
    NSCAssert(BCJShouldReplaceNullWithNil(options), @"Invalid option <BCJGetterOptionReplaceNullWithNil> is not permitted when setting NSNull");
    return BCJSetValue(target, targetKey, array, idx, NSNull.class, options, [NSNull null]);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx) {
    return BCJSetValue(target, targetKey, array, idx, NSNull.class, 0, [NSNull null]);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key, BCJGetterOptions options) {
    NSCAssert(BCJShouldReplaceNullWithNil(options), @"Invalid option <BCJGetterOptionReplaceNullWithNil> is not permitted when setting NSNull");
    return BCJSetValue(target, targetKey, dict, key, NSNull.class, options, [NSNull null]);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key) {
    return BCJSetValue(target, targetKey, dict, key, NSNull.class, 0, [NSNull null]);
}
