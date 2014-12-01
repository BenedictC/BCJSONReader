//
//  BCJStandardTypesGetters.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 31/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJStandardTypesGetters.h"
#import "BCJSource+DeferredClassCheck.h"
#import "BCJTarget.h"
#import "BCJError.h"



#pragma mark - (private) generic setter
static inline id<BCLContinuation> BCJ_OVERLOADABLE BCJGetValue(BCJSource *source, BOOL(^block)(id, NSError **), Class expectedClass) {
    BCJParameterExpectation(source != nil);
    BCJParameterExpectation(block != NULL);
    BCJExpectation(source.expectedClass == nil, @"A source must not have a defaultExpectedClass when passed to a type-specific getter or setter.");

    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        id value;
        BCJSourceResult result = [source getValue:&value ofKind:expectedClass error:outError];
        switch (result) {
            case BCJSourceResultValueNotFound: return YES;
            case BCJSourceResultSuccess: return block(value, outError);
            case BCJSourceResultFailure: return NO;
        }
    });
}



#pragma mark - type specific setters
id<BCLContinuation> BCJ_OVERLOADABLE BCJGetArray(BCJSource *source, BOOL(^block)(NSArray *array, NSError **outError)) {
    return BCJGetValue(source, block, NSArray.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJGetMutableArray(BCJSource *source, BOOL(^block)(NSMutableArray *array, NSError **outError)) {
    return BCJGetValue(source, block, NSMutableArray.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJGetDictionary(BCJSource *source, BOOL(^block)(NSDictionary *dict, NSError **outError)) {
    return BCJGetValue(source, block, NSDictionary.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJGetMutableDictionary(BCJSource *source, BOOL(^block)(NSMutableDictionary *dict, NSError **outError)) {
    return BCJGetValue(source, block, NSMutableDictionary.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJGetString(BCJSource *source, BOOL(^block)(NSString *string, NSError **outError)) {
    return BCJGetValue(source, block, NSString.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJGetMutableString(BCJSource *source, BOOL(^block)(NSMutableString *string, NSError **outError)) {
    return BCJGetValue(source, block, NSMutableString.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJGetNumber(BCJSource *source, BOOL(^block)(NSNumber *number, NSError **outError)) {
    return BCJGetValue(source, block, NSNumber.class);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJGetNull(BCJSource *source, BOOL(^block)(NSNull *null, NSError **outError)) {
    BCJExpectation(({
        BOOL isReplaceNullSet = (source.options & BCJSourceOptionReplaceNullWithNil) != 0;
        isReplaceNullSet;
    }), @"Invalid option <BCJGetterOptionReplaceNullWithNil> is not permitted when setting NSNull");
    return BCJGetValue(source, block, NSNull.class);
}
