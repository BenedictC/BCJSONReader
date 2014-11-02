//
//  BCJGettersAndSetter.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 01/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJGettersAndSetter.h"
#import "BCJCore.h"



#pragma mark - Get arbitary object continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJGetValue(id<BCJIndexedContainer> array, NSUInteger idx, Class class, BCJGetterOptions options, id defaultValue, BOOL(^successBlock)(id value, NSError **outError)) {
    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        id value;
        if (!BCJGetValue(array, idx, class, options, defaultValue, &value, outError)) return NO;

        return successBlock(value, outError);
    });
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJGetValue(id<BCJKeyedContainer> dict, id key, Class class, BCJGetterOptions options, id defaultValue, BOOL(^successBlock)(id value, NSError **outError)) {
    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        id value;
        if (!BCJGetValue(dict, key, class, options, defaultValue, &value, outError)) return NO;

        return successBlock(value, outError);
    });
}



#pragma mark - Set arbitary object continuations
//KVC result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetValue(id<BCJIndexedContainer> array, NSUInteger idx, Class class, BCJGetterOptions options, id defaultValue, id target, NSString *targetKey) {
    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        id value;
        if (!BCJGetValue(array, idx, class, options, defaultValue, &value, outError)) return NO;

        return BCJSetValue(target, targetKey, value, outError);
    });
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetValue(id<BCJKeyedContainer> dict, id key, Class class, BCJGetterOptions options, id defaultValue, id target, NSString *targetKey) {
    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        id value;
        if (!BCJGetValue(dict, key, class, options, defaultValue, &value, outError)) return NO;

        return BCJSetValue(target, targetKey, value, outError);
    });
}
