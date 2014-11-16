//
//  BCJMap.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 01/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJMap.h"
#import "BCJError.h"
#import "BCJJSONSource+DeferredClassCheck.h"
#import "BCJJSONTarget.h"



#pragma mark - helper functions
static inline BOOL isOptionSet(NSInteger option, NSInteger options) {
    return (options & option) != 0;
}



#pragma mark - Map functions
BCJ_OVERLOADABLE NSArray *BCJMap(NSArray *fromArray, Class elementClass, BCJMapOptions options, id(^mapFromArray)(NSUInteger elementIdx, id elementValue, NSError **outError), NSError **outError) {
    NSCParameterAssert(fromArray != nil);
    NSCParameterAssert(mapFromArray != nil);

    //Apply the mapping to the elements
    NSMutableArray *values = [NSMutableArray new];
    __block BOOL didError = NO;

    [fromArray enumerateObjectsUsingBlock:^(id elementValue, NSUInteger elementIdx, BOOL *stop) {
        //Check element is of correct kind
        if (![elementValue isKindOfClass:elementClass]) {
            if (outError != NULL) *outError = [BCJError unexpectedElementTypeErrorWithElement:elementValue subscript:@(elementIdx) expectedElementClass:elementClass];
            didError = YES;
            *stop = YES;
            return; //from container enumaration
        }

        //Attempt to map the value
        NSError *elementOutError = nil;
        id mappedValue = mapFromArray(elementIdx, elementValue, &elementOutError);
        if (mappedValue == nil) {
            BOOL shouldDiscardMappingError = isOptionSet(BCJMapOptionDiscardMappingErrors, options);
            if (!shouldDiscardMappingError) {
                if (outError != NULL) {
                    *outError = [BCJError mappingErrorWithElement:elementValue subscript:@(elementIdx) underlyingError:elementOutError];
                }
                didError = YES;
                *stop = YES;
            }
            return; //from container enumaration
        }

        //Add the mappedValue
        [values addObject:mappedValue];
    }];

    return (didError) ? nil : values;
}



BCJ_OVERLOADABLE NSArray *BCJMap(NSDictionary *fromDict, Class elementClass, BCJMapOptions options, NSArray *sortDescriptors, id(^mapFromDictionary)(id elementKey, id elementValue, NSError **outError), NSError **outError) {
    NSCParameterAssert(fromDict != nil);
    NSCParameterAssert(mapFromDictionary != nil);

    //Apply the mapping to the elements
    NSMutableArray *values = [NSMutableArray new];
    __block BOOL didError = NO;

    [fromDict enumerateKeysAndObjectsUsingBlock:^(id elementKey, id elementValue, BOOL *stop) {
        //Check element is of correct kind
        if (![elementValue isKindOfClass:elementClass]) {
            if (outError != NULL) *outError = [BCJError unexpectedElementTypeErrorWithElement:elementValue subscript:elementKey expectedElementClass:elementClass];
            didError = YES;
            *stop = YES;
            return; //from container enumaration
        }

        //Attempt to map the value
        NSError *elementOutError = nil;
        id mappedValue = mapFromDictionary(elementKey, elementValue, &elementOutError);
        if (mappedValue == nil) {
            BOOL shouldDiscardMappingError = isOptionSet(BCJMapOptionDiscardMappingErrors, options);
            if (!shouldDiscardMappingError) {
                if (outError != NULL) {
                    *outError = [BCJError mappingErrorWithElement:elementValue subscript:elementKey underlyingError:elementOutError];
                }
                didError = YES;
                *stop = YES;
            }
            return; //from container enumaration
        }

        //Add the mappedValue
        [values addObject:mappedValue];
    }];

    //Apply sortDescriptors
    [values sortUsingDescriptors:sortDescriptors];

    return (didError) ? nil : values;
}



#pragma mark - Set Map continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(BCJJSONTarget *target, BCJJSONSource *source, Class elementClass, BCJMapOptions options, id(^fromArrayMap)(NSUInteger elementIndex, id elementValue, NSError **outError)) {
    NSCParameterAssert(target != nil);
    NSCParameterAssert(source != nil);
    NSCParameterAssert(fromArrayMap != nil);
    NSCAssert(source.expectedClass == nil, @"A source must not have a defaultExpectedClass when passed to a type-specific getter or setter.");

    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {

        //Get the container
        NSArray *container;
        BCJSourceResult result = [source getValue:&container ofKind:NSArray.class error:outError];
        switch (result) {
            case BCJSourceResultValueNotFound: return YES;
            case BCJSourceResultFailure: return NO;
            case BCJSourceResultSuccess:
                break;
        }

        //Perform the mapping
        NSArray *values = BCJMap(container, elementClass, options, fromArrayMap, outError);
        BOOL didMappingSucceed = (values != nil);
        if (!didMappingSucceed) return NO;

        //Set the value
        return [target setValue:values error:outError];
    });
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(BCJJSONTarget *target, BCJJSONSource *source, Class elementClass, BCJMapOptions options, NSArray *sortDescriptors, id(^fromDictionaryMap)(id elementKey, id elementValue, NSError **outError)) {
    NSCParameterAssert(target != nil);
    NSCParameterAssert(source != nil);
    NSCParameterAssert(fromDictionaryMap != nil);
    NSCAssert(source.expectedClass == nil, @"A source must not have a defaultExpectedClass when passed to a type-specific getter or setter.");

    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {

        //Get the container
        NSDictionary *container;
        if (![source getValue:&container ofKind:NSDictionary.class error:outError]) return NO;

        //Perform the mapping
        NSArray *values = BCJMap(container, elementClass, options, sortDescriptors, fromDictionaryMap, outError);
        BOOL didMappingSucceed = (values != nil);
        if (!didMappingSucceed) return NO;

        //Set the value
        return [target setValue:values error:outError];
    });
}
