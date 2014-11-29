//
//  BCJMap.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 01/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJMap.h"
#import "BCJError.h"
#import "BCJSource+DeferredClassCheck.h"
#import "BCJTarget.h"



#pragma mark - helper functions
static inline BOOL isOptionSet(NSInteger option, NSInteger options) {
    return (options & option) != 0;
}



#pragma mark - Get Enum
BCJSourceResult BCJ_OVERLOADABLE BCJGetEnum(BCJSource *source, NSDictionary *enumMapping, id *outValue, NSError **outError) {
    BCJParameterExpectation(source != nil);
    BCJParameterExpectation(enumMapping != nil);
    BCJParameterExpectation(outValue != nil);
    BCJParameterExpectation(outError != nil);
    //Note that we don't need to check the source type because it will be used as a key to access an enum and we don't
    //care what the enum keys are.

    //Reset outValue
    *outValue = nil;
    if (outError != NULL) *outError = nil;

    //Get the value
    id enumKey;
    BCJSourceResult result = [source getValue:&enumKey error:outError];
    if (result != BCJSourceResultSuccess) {
        return result;
    }
    
    //We don't have a key but that's fine because otherwise the getter would have complained.
    if (enumKey == nil) return BCJSourceResultSuccess;

    //Get the value
    id value = enumMapping[enumKey];

    //If the value is nil then the mapping was incomplete.
    if (value == nil) {
        if (outError != NULL) *outError = [BCJError missingKeyForEnumMappingErrorWithJSONSource:source enumMapping:enumMapping key:enumKey];
        return BCJSourceResultFailure;
    }

    *outValue = value;
    return BCJSourceResultSuccess;
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetEnum(BCJSource *source, BCJTarget *target, NSDictionary *enumMapping) {
    //Perform additional checks that couldn't be performed when source and target are created
    BCJParameterExpectation(target != nil);
    BCJParameterExpectation(source != nil);
    BCJParameterExpectation(enumMapping != nil);
    //Note that we don't need to check the source type because it will be used as a key to access an enum and we don't

    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        id value;
        BCJSourceResult result = BCJGetEnum(source, enumMapping, &value, outError);
        switch (result) {
            case BCJSourceResultValueNotFound:
                return YES;
            case BCJSourceResultFailure:
                return NO;
            case BCJSourceResultSuccess:
                break;
        }
        return [target setValue:value error:outError];
    });
}



#pragma mark - Map functions
BCJ_OVERLOADABLE NSArray *BCJGetMap(NSArray *fromArray, Class elementClass, BCJMapOptions options, id(^mapFromArray)(NSUInteger elementIdx, id elementValue, NSError **outError), NSError **outError) {
    BCJParameterExpectation(fromArray != nil);
    BCJParameterExpectation(mapFromArray != nil);

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
            BOOL shouldDiscardMappingError = isOptionSet(BCJMapOptionIgnoreFailedMappings, options);
            if (!shouldDiscardMappingError) {
                if (outError != NULL) {
                    *outError = [BCJError elementMappingErrorWithElement:elementValue subscript:@(elementIdx) underlyingError:elementOutError];
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



BCJ_OVERLOADABLE NSArray *BCJGetMap(NSDictionary *fromDict, Class elementClass, BCJMapOptions options, NSArray *sortDescriptors, id(^mapFromDictionary)(id elementKey, id elementValue, NSError **outError), NSError **outError) {
    BCJParameterExpectation(fromDict != nil);
    BCJParameterExpectation(mapFromDictionary != nil);

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
            BOOL shouldDiscardMappingError = isOptionSet(BCJMapOptionIgnoreFailedMappings, options);
            if (!shouldDiscardMappingError) {
                if (outError != NULL) {
                    *outError = [BCJError elementMappingErrorWithElement:elementValue subscript:elementKey underlyingError:elementOutError];
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
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(BCJSource *source, BCJTarget *target, Class elementClass, BCJMapOptions options, id(^fromArrayMap)(NSUInteger elementIndex, id elementValue, NSError **outError)) {
    BCJParameterExpectation(target != nil);
    BCJParameterExpectation(source != nil);
    BCJParameterExpectation(fromArrayMap != nil);
    BCJExpectation(source.expectedClass == nil, @"A source must not have a defaultExpectedClass when passed to a type-specific getter or setter.");

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
        NSArray *values = BCJGetMap(container, elementClass, options, fromArrayMap, outError);
        BOOL didMappingSucceed = (values != nil);
        if (!didMappingSucceed) return NO;

        //Set the value
        return [target setValue:values error:outError];
    });
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(BCJSource *source, BCJTarget *target, Class elementClass, BCJMapOptions options, NSArray *sortDescriptors, id(^fromDictionaryMap)(id elementKey, id elementValue, NSError **outError)) {
    BCJParameterExpectation(target != nil);
    BCJParameterExpectation(source != nil);
    BCJParameterExpectation(fromDictionaryMap != nil);
    BCJExpectation(source.expectedClass == nil, @"A source must not have a defaultExpectedClass when passed to a type-specific getter or setter.");

    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {

        //Get the container
        NSDictionary *container;
        BCJSourceResult result = [source getValue:&container ofKind:NSDictionary.class error:outError];
        switch (result) {
            case BCJSourceResultValueNotFound: return YES;
            case BCJSourceResultFailure: return NO;
            case BCJSourceResultSuccess:
                break;
        }

        //Perform the mapping
        NSArray *values = BCJGetMap(container, elementClass, options, sortDescriptors, fromDictionaryMap, outError);
        BOOL didMappingSucceed = (values != nil);
        if (!didMappingSucceed) return NO;
        
        //Set the value
        return [target setValue:values error:outError];
    });
}
