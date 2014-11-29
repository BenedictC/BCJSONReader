//
//  BCJStandardTypesSetters.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 31/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJStandardTypesSetters.h"
#import "BCJSource+DeferredClassCheck.h"
#import "BCJTarget.h"
#import "BCJLogging.h"
#import "BCJError.h"



#pragma mark - (private) generic setter
static inline id<BCLContinuation> BCJ_OVERLOADABLE BCJSetValue(BCJSource *source, BCJTarget *target, Class expectedClass) {
    BCJParameterExpectation(target != nil);
    BCJParameterExpectation(source != nil);
    BCJExpectation(source.expectedClass == nil, @"A source must not have a defaultExpectedClass when passed to a type-specific getter or setter.");

    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        BCJWarnIfPossibleToSetScalarPropertyToNil(source, target);

        id value;
        BCJSourceResult result = [source getValue:&value ofKind:expectedClass error:outError];
        switch (result) {
            case BCJSourceResultValueNotFound: return YES;
            case BCJSourceResultSuccess: return [target setValue:value error:outError];
            default: //This isn't necessary but I'm paranoid.
            case BCJSourceResultFailure: return NO;
        }
    });
}



#pragma mark - type specific setters
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(BCJSource *source, BCJTarget *target) {
    return BCJSetValue(source, target, NSArray.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(BCJSource *source, BCJTarget *target) {
    return BCJSetValue(source, target, NSMutableArray.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(BCJSource *source, BCJTarget *target) {
    return BCJSetValue(source, target, NSDictionary.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(BCJSource *source, BCJTarget *target) {
    return BCJSetValue(source, target, NSMutableDictionary.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(BCJSource *source, BCJTarget *target) {
    return BCJSetValue(source, target, NSString.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(BCJSource *source, BCJTarget *target) {
    return BCJSetValue(source, target, NSMutableString.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(BCJSource *source, BCJTarget *target) {
    return BCJSetValue(source, target, NSNumber.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(BCJSource *source, BCJTarget *target) {
    BCJExpectation(({
        BOOL isReplaceNullSet = (source.options & BCJSourceOptionReplaceNullWithNil) != 0;
        isReplaceNullSet;
    }), @"Invalid option <BCJGetterOptionReplaceNullWithNil> is not permitted when setting NSNull");
    return BCJSetValue(source, target, NSNull.class);
}
