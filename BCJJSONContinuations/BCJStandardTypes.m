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
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSArray *defaultValue, id target, NSString *targetKey) {
    return BCJSetValue(array, idx, NSArray.class, options, defaultValue, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(id<BCJIndexedContainer> array, NSUInteger idx, id target, NSString *targetKey) {
    return BCJSetValue(array, idx, NSArray.class, 0, nil, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSArray *defaultValue, id target, NSString *targetKey) {
    return BCJSetValue(dict, key, NSArray.class, options, defaultValue, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(id<BCJKeyedContainer> dict, id key, id target, NSString *targetKey) {
    return BCJSetValue(dict, key, NSArray.class, 0, nil, target, targetKey);
}



#pragma mark - Set NSMutableArray continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSMutableArray *defaultValue, id target, NSString *targetKey) {
    return BCJSetValue(array, idx, NSMutableArray.class, options, defaultValue, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(id<BCJIndexedContainer> array, NSUInteger idx, id target, NSString *targetKey) {
    return BCJSetValue(array, idx, NSMutableArray.class, 0, nil, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSMutableArray *defaultValue, id target, NSString *targetKey) {
    return BCJSetValue(dict, key, NSMutableArray.class, options, defaultValue, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(id<BCJKeyedContainer> dict, id key, id target, NSString *targetKey) {
    return BCJSetValue(dict, key, NSMutableArray.class, 0, nil, target, targetKey);
}



#pragma mark - Set NSDictionary continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSDictionary *defaultValue, id target, NSString *targetKey) {
    return BCJSetValue(array, idx, NSDictionary.class, options, defaultValue, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(id<BCJIndexedContainer> array, NSUInteger idx, id target, NSString *targetKey) {
    return BCJSetValue(array, idx, NSDictionary.class, 0, nil, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSDictionary *defaultValue, id target, NSString *targetKey) {
    return BCJSetValue(dict, key, NSDictionary.class, options, defaultValue, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(id<BCJKeyedContainer> dict, id key, id target, NSString *targetKey) {
    return BCJSetValue(dict, key, NSDictionary.class, 0, nil, target, targetKey);
}



#pragma mark - Set NSMutableDictionary continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSMutableDictionary *defaultValue, id target, NSString *targetKey) {
    return BCJSetValue(array, idx, NSMutableDictionary.class, options, defaultValue, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(id<BCJIndexedContainer> array, NSUInteger idx, id target, NSString *targetKey) {
    return BCJSetValue(array, idx, NSMutableDictionary.class, 0, nil, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSMutableDictionary *defaultValue, id target, NSString *targetKey) {
    return BCJSetValue(dict, key, NSMutableDictionary.class, options, defaultValue, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(id<BCJKeyedContainer> dict, id key, id target, NSString *targetKey) {
    return BCJSetValue(dict, key, NSMutableDictionary.class, 0, nil, target, targetKey);
}



#pragma mark - Set NSString continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSString *defaultValue, id target, NSString *targetKey) {
    return BCJSetValue(array, idx, NSString.class, options, defaultValue, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(id<BCJIndexedContainer> array, NSUInteger idx, id target, NSString *targetKey) {
    return BCJSetValue(array, idx, NSString.class, 0, nil, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSString *defaultValue, id target, NSString *targetKey) {
    return BCJSetValue(dict, key, NSString.class, options, defaultValue, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(id<BCJKeyedContainer> dict, id key, id target, NSString *targetKey) {
    return BCJSetValue(dict, key, NSString.class, 0, nil, target, targetKey);
}



#pragma mark - Set NSMutableString continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSMutableString *defaultValue, id target, NSString *targetKey) {
    return BCJSetValue(array, idx, NSMutableString.class, options, defaultValue, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(id<BCJIndexedContainer> array, NSUInteger idx, id target, NSString *targetKey) {
    return BCJSetValue(array, idx, NSMutableString.class, 0, nil, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSMutableString *defaultValue, id target, NSString *targetKey) {
    return BCJSetValue(dict, key, NSMutableString.class, options, defaultValue, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(id<BCJKeyedContainer> dict, id key, id target, NSString *targetKey) {
    return BCJSetValue(dict, key, NSMutableString.class, 0, nil, target, targetKey);
}



#pragma mark - Set NSNumber continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSNumber *defaultValue, id target, NSString *targetKey) {
    return BCJSetValue(array, idx, NSNumber.class, options, defaultValue, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(id<BCJIndexedContainer> array, NSUInteger idx, id target, NSString *targetKey) {
    return BCJSetValue(array, idx, NSNumber.class, 0, nil, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSNumber *defaultValue, id target, NSString *targetKey) {
    return BCJSetValue(dict, key, NSNumber.class, options, defaultValue, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(id<BCJKeyedContainer> dict, id key, id target, NSString *targetKey) {
    return BCJSetValue(dict, key, NSNumber.class, 0, nil, target, targetKey);
}



#pragma mark - Set NSNull continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, id target, NSString *targetKey) {
    NSCAssert(BCJShouldReplaceNullWithNil(options), @"Invalid option <BCJGetterOptionReplaceNullWithNil> is not permitted when setting NSNull");
    return BCJSetValue(array, idx, NSNull.class, options, [NSNull null], target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(id<BCJIndexedContainer> array, NSUInteger idx, id target, NSString *targetKey) {
    return BCJSetValue(array, idx, NSNull.class, 0, [NSNull null], target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, id target, NSString *targetKey) {
    NSCAssert(BCJShouldReplaceNullWithNil(options), @"Invalid option <BCJGetterOptionReplaceNullWithNil> is not permitted when setting NSNull");
    return BCJSetValue(dict, key, NSNull.class, options, [NSNull null], target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(id<BCJKeyedContainer> dict, id key, id target, NSString *targetKey) {
    return BCJSetValue(dict, key, NSNull.class, 0, [NSNull null], target, targetKey);
}
