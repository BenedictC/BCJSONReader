//
//  BCJStandardTypes.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 31/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJStandardTypes.h"
#import "BCJJSONSource+LateBoundClassCheck.h"
#import "BCJJSONTarget.h"
#import "BCJJSONSource+OptionsAdditons.h"



#pragma mark - (private) generic setter
static inline id<BCLContinuation> BCJ_OVERLOADABLE BCJSetValue(BCJJSONTarget *target, BCJJSONSource *source, Class expectedClass) {
    NSCParameterAssert(target != nil);
    NSCParameterAssert(source != nil);
    NSCAssert(source.expectedClass == nil, @"A source must not have a defaultExpectedClass when passed to a type-specific getter or setter.");

    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        id value;
        if (![source getValue:&value ofKind:expectedClass error:outError]) return NO;

        return [target setWithValue:value outError:outError];
    });
}



#pragma mark - type specific setters
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(BCJJSONTarget *target, BCJJSONSource *source) {
    return BCJSetValue(target, source, NSArray.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(BCJJSONTarget *target, BCJJSONSource *source) {
    return BCJSetValue(target, source, NSMutableArray.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(BCJJSONTarget *target, BCJJSONSource *source) {
    return BCJSetValue(target, source, NSDictionary.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(BCJJSONTarget *target, BCJJSONSource *source) {
    return BCJSetValue(target, source, NSMutableDictionary.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(BCJJSONTarget *target, BCJJSONSource *source) {
    return BCJSetValue(target, source, NSString.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(BCJJSONTarget *target, BCJJSONSource *source) {
    return BCJSetValue(target, source, NSMutableString.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(BCJJSONTarget *target, BCJJSONSource *source) {
    return BCJSetValue(target, source, NSNumber.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(BCJJSONTarget *target, BCJJSONSource *source) {
    NSCAssert(BCJShouldReplaceNullWithNil(source.options), @"Invalid option <BCJGetterOptionReplaceNullWithNil> is not permitted when setting NSNull");
    return BCJSetValue(target, source, NSNull.class);
}
