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
#import "BCJJSONSource+OptionsAdditons.h"



#pragma mark - (private) generic setter
static inline id<BCLContinuation> BCJ_OVERLOADABLE BCJSetValue(BCJPropertyTarget *target, BCJJSONSource *source, Class expectedClass) {
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
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(BCJPropertyTarget *target, BCJJSONSource *source) {
    return BCJSetValue(target, source, NSArray.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(BCJPropertyTarget *target, BCJJSONSource *source) {
    return BCJSetValue(target, source, NSMutableArray.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(BCJPropertyTarget *target, BCJJSONSource *source) {
    return BCJSetValue(target, source, NSDictionary.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(BCJPropertyTarget *target, BCJJSONSource *source) {
    return BCJSetValue(target, source, NSMutableDictionary.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(BCJPropertyTarget *target, BCJJSONSource *source) {
    return BCJSetValue(target, source, NSString.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(BCJPropertyTarget *target, BCJJSONSource *source) {
    return BCJSetValue(target, source, NSMutableString.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(BCJPropertyTarget *target, BCJJSONSource *source) {
    return BCJSetValue(target, source, NSNumber.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(BCJPropertyTarget *target, BCJJSONSource *source) {
    NSCAssert(BCJReplaceNullWithNil(source.options), @"Invalid option <BCJGetterOptionReplaceNullWithNil> is not permitted when setting NSNull");
    return BCJSetValue(target, source, NSNull.class);
}
