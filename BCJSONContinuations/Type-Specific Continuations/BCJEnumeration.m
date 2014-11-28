//
//  BCJEnumeration.m
//  BCJSONMapper
//
//  Created by Benedict Cohen on 27/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJEnumeration.h"
#import "BCJJSONSource+DeferredClassCheck.h"
#import "BCJValidation.h"
#import "BCJError.h"



id<BCLContinuation> BCJ_OVERLOADABLE BCJEnumerateArray(BCJJSONSource *source, Class elementClass, BOOL(^enumerator)(NSUInteger idx, id value, NSError **outError)) {
    NSCParameterAssert(source != nil);
    NSCParameterAssert(enumerator != nil);

    return BCLContinuationWithBlock(@(__FUNCTION__), ^BOOL(NSError *__autoreleasing *outError) {
        NSArray *array;
        BCJJSONSourceResult result = [source getValue:&array ofKind:NSArray.class error:outError];
        switch (result) {
            case BCJJSONSourceResultFailure:
                return NO;
            case BCJJSONSourceResultValueNotFound:
                return YES;                
            case BCJJSONSourceResultSuccess:
                break;
        }

        NSInteger idx = 0;
        for (id element in array) {
            //Validate
            if (!BCJIsOfKindClass(element, elementClass, outError)) {
                if (*outError == nil) {
                    *outError = [BCJError errorWithDomain:@"TODO: Unknown enumeration error" code:0 userInfo:nil];
                }
             return NO;
            }

            //Enumerate
            if (!enumerator(idx, element, outError)) {
                if (*outError == nil) {
                    *outError = [BCJError errorWithDomain:@"TODO: Unknown enumeration error" code:0 userInfo:nil];
                }
                return NO;
            }

            idx++;
        }

        return YES;
    });
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJEnumerateDictionary(BCJJSONSource *source, Class keyClass, Class elementClass, BOOL(^enumerator)(id key, id value, NSError **outError)) {
    NSCParameterAssert(source != nil);
    NSCParameterAssert(enumerator != nil);

    return BCLContinuationWithBlock(@(__FUNCTION__), ^BOOL(NSError *__autoreleasing *outError) {
        NSDictionary *dictionary;
        BCJJSONSourceResult result = [source getValue:&dictionary ofKind:NSDictionary.class error:outError];
        switch (result) {
            case BCJJSONSourceResultFailure:
                return NO;

            case BCJJSONSourceResultValueNotFound:
                return YES;

            case BCJJSONSourceResultSuccess:
                break;
        }

        __block BOOL didError = NO;
        __block NSError *enumerationError = nil;
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id element, BOOL *stop) {
            //Validate
            BOOL didValidate = BCJIsOfKindClass(key, keyClass, &enumerationError) && BCJIsOfKindClass(element, elementClass, &enumerationError);
            if (!didValidate) {
                    if (enumerationError == nil) {
                        enumerationError = [BCJError errorWithDomain:@"TODO: Unknown enumeration error" code:0 userInfo:nil];
                    }
                    *stop = YES;
                    didError = YES;
                    return;
                }

            //Enumerate
            if (!enumerator(key, element, &enumerationError)) {
                if (enumerationError == nil) {
                    enumerationError = [BCJError errorWithDomain:@"TODO: Unknown enumeration error" code:0 userInfo:nil];
                }
                *stop = YES;
                didError = YES;
                return;
            }
        }];

        *outError = enumerationError;
        return !didError;
    });
}
