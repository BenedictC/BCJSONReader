//
//  BCJEnumeration.m
//  BCJSONMapper
//
//  Created by Benedict Cohen on 27/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJEnumeration.h"
#import "BCJSource+DeferredClassCheck.h"
#import "BCJValidation.h"
#import "BCJError.h"



id<BCLContinuation> BCJ_OVERLOADABLE BCJEnumerateArray(BCJSource *source, Class elementClass, BOOL(^enumerator)(NSUInteger idx, id value, NSError **outError)) {
    BCJParameterExpectation(source != nil);
    BCJParameterExpectation(enumerator != nil);

    return BCLContinuationWithBlock(@(__FUNCTION__), ^BOOL(NSError *__autoreleasing *outError) {
        NSArray *array;
        BCJSourceResult result = [source getValue:&array ofKind:NSArray.class error:outError];
        switch (result) {
            case BCJSourceResultFailure:
                return NO;
            case BCJSourceResultValueNotFound:
                return YES;                
            case BCJSourceResultSuccess:
                break;
        }

        NSInteger idx = 0;
        for (id element in array) {
            //Validate
            if (!BCJIsOfKindClass(element, elementClass, outError)) {
                if (*outError == nil) {
                    *outError = [BCJError unexpectedElementTypeErrorWithElement:element subscript:@(idx) expectedElementClass:elementClass];
                }
             return NO;
            }

            //Enumerate
            if (!enumerator(idx, element, outError)) {
                if (*outError == nil) {
                    *outError = [BCJError unknownErrorWithDescription:@"Enumerator failed but did not give an error."];
                }
                return NO;
            }

            idx++;
        }

        return YES;
    });
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJEnumerateDictionary(BCJSource *source, Class keyClass, Class valueClass, BOOL(^enumerator)(id key, id value, NSError **outError)) {
    BCJParameterExpectation(source != nil);
    BCJParameterExpectation(enumerator != nil);

    return BCLContinuationWithBlock(@(__FUNCTION__), ^BOOL(NSError *__autoreleasing *outError) {
        NSDictionary *dictionary;
        BCJSourceResult result = [source getValue:&dictionary ofKind:NSDictionary.class error:outError];
        switch (result) {
            case BCJSourceResultFailure:
                return NO;

            case BCJSourceResultValueNotFound:
                return YES;

            case BCJSourceResultSuccess:
                break;
        }

        __block NSError *error = nil;
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
            NSError *enumerationError = nil;
            //Validate
            if (!BCJIsOfKindClass(key, keyClass, &enumerationError)) {
                error = (enumerationError != nil) ? enumerationError : [BCJError unexpectedKeyTypeErrorWithKey:key expectedKeyClass:keyClass];
                *stop = YES;
                return;
            }
            if (!BCJIsOfKindClass(value, valueClass, &enumerationError)) {
                error = (enumerationError != nil) ? enumerationError : [BCJError unexpectedElementTypeErrorWithElement:value subscript:key expectedElementClass:valueClass];
                *stop = YES;
                return;
            }

            //Enumerate
            if (!enumerator(key, value, &enumerationError)) {
                error = (enumerationError != nil) ? enumerationError : [BCJError unknownErrorWithDescription:@"Enumerator failed but did not give an error."];
                *stop = YES;
                return;
            }
        }];

        BOOL didError = error != nil;
        if (didError && outError != NULL) {
            *outError = error;
        }

        return !didError;
    });
}
