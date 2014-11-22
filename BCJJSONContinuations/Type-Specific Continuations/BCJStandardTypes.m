//
//  BCJStandardTypes.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 31/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJStandardTypes.h"
#import "BCJJSONSource+DeferredClassCheck.h"
#import "BCJPropertyTarget.h"



#pragma mark - (private) generic setter
static inline id<BCLContinuation> BCJ_OVERLOADABLE BCJSetValue(BCJJSONSource *source, BCJPropertyTarget *target, Class expectedClass) {
    NSCParameterAssert(target != nil);
    NSCParameterAssert(source != nil);
    NSCAssert(source.expectedClass == nil, @"A source must not have a defaultExpectedClass when passed to a type-specific getter or setter.");

    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        id value;
        BCJJSONSourceResult result = [source getValue:&value ofKind:expectedClass error:outError];
        switch (result) {
            case BCJJSONSourceResultValueNotFound: return YES;
            case BCJJSONSourceResultSuccess: return [target setValue:value error:outError];
            default: //This isn't necessary but I'm paranoid.
            case BCJJSONSourceResultFailure: return NO;
        }
    });
}



#pragma mark - type specific setters
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(BCJJSONSource *source, BCJPropertyTarget *target) {
    return BCJSetValue(source, target, NSArray.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(BCJJSONSource *source, BCJPropertyTarget *target) {
    return BCJSetValue(source, target, NSMutableArray.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(BCJJSONSource *source, BCJPropertyTarget *target) {
    return BCJSetValue(source, target, NSDictionary.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(BCJJSONSource *source, BCJPropertyTarget *target) {
    return BCJSetValue(source, target, NSMutableDictionary.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(BCJJSONSource *source, BCJPropertyTarget *target) {
    return BCJSetValue(source, target, NSString.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(BCJJSONSource *source, BCJPropertyTarget *target) {
    return BCJSetValue(source, target, NSMutableString.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(BCJJSONSource *source, BCJPropertyTarget *target) {
    return BCJSetValue(source, target, NSNumber.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(BCJJSONSource *source, BCJPropertyTarget *target) {
    NSCAssert(({
        BOOL isReplaceNullSet = (source.options & BCJJSONSourceOptionReplaceNullWithNil) != 0;
        isReplaceNullSet;
    }), @"Invalid option <BCJGetterOptionReplaceNullWithNil> is not permitted when setting NSNull");
    return BCJSetValue(source, target, NSNull.class);
}
