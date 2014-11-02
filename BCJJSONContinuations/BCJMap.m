//
//  BCJMap.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 01/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJMap.h"
#import "BCJCore.h"



#pragma mark - Map functions
BCJ_OVERLOADABLE NSArray *BCJMap(NSDictionary *dict, Class elementClass, BCJMapOptions options, NSArray *sortDescriptors, id(^mapFromDictionary)(id elementKey, id elementValue, NSError **outError), NSError **outError) {
    //Apply the mapping to the elements
    NSMutableArray *values = [NSMutableArray new];
    __block BOOL didError = NO;

    [dict enumerateKeysAndObjectsUsingBlock:^(id elementKey, id elementValue, BOOL *stop) {
        //Check element is of correct kind
        if (![elementValue isKindOfClass:elementClass]) {
            if (outError != NULL) *outError = [NSError errorWithDomain:@"TODO: incorrect element type" code:0 userInfo:nil];
            didError = YES;
            *stop = YES;
            return; //from container enumaration
        }

        //Attempt to map the value
        NSError *elementOutError = nil;
        id mappedValue = mapFromDictionary(elementKey, elementValue, &elementOutError);
        if (mappedValue == nil) {
            BOOL shouldDiscardMappingError = BCJIsOptionSet(BCJMapOptionDiscardMappingErrors, options);
            if (!shouldDiscardMappingError) {
                if (outError != NULL) {
                    NSDictionary *userInfo = (elementOutError == nil) ? nil : @{@"underlyingError": elementOutError};
                    *outError = [NSError errorWithDomain:@"TODO: Mapping failed" code:0 userInfo:userInfo];
                }
                didError = YES;
                *stop = YES;
            }
            return; //from container enumaration
        }

        //Add the mappedValue
        [values addObject:mappedValue];
    }];

#pragma message "TODO: Apply sortDescriptors"

    return (didError) ? nil : values;
}



BCJ_OVERLOADABLE NSArray *BCJMap(NSArray *array, Class elementClass, BCJMapOptions options, id(^mapFromArray)(NSUInteger elementIdx, id elementValue, NSError **outError), NSError **outError) {
    //Apply the mapping to the elements
    NSMutableArray *values = [NSMutableArray new];
    __block BOOL didError = NO;

    [array enumerateObjectsUsingBlock:^(id elementValue, NSUInteger elementIdx, BOOL *stop) {
        //Check element is of correct kind
        if (![elementValue isKindOfClass:elementClass]) {
            if (outError != NULL) *outError = [NSError errorWithDomain:@"TODO: incorrect element type" code:0 userInfo:nil];
            didError = YES;
            *stop = YES;
            return; //from container enumaration
        }

        //Attempt to map the value
        NSError *elementOutError = nil;
        id mappedValue = mapFromArray(elementIdx, elementValue, &elementOutError);
        if (mappedValue == nil) {
            BOOL shouldDiscardMappingError = BCJIsOptionSet(BCJMapOptionDiscardMappingErrors, options);
            if (!shouldDiscardMappingError) {
                if (outError != NULL) {
                    NSDictionary *userInfo = (elementOutError == nil) ? nil : @{@"underlyingError": elementOutError};
                    *outError = [NSError errorWithDomain:@"TODO: Mapping failed" code:0 userInfo:userInfo];
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



#pragma mark - Set Map continuations
static inline BCJGetterOptions getterOptionsFromMapOptions(BCJMapOptions mapOptions) {
    //Create getter options from mapping options
    BCJGetterOptions getterOptions = 0;
    if (BCJIsOptionSet(BCJMapOptionReplaceNullWithNil, mapOptions)) getterOptions |= BCJGetterOptionReplaceNullWithNil;
    if (BCJIsOptionSet(BCJMapOptionReplaceNilWithEmptyCollection, mapOptions)) getterOptions |= BCJGetterOptionReplaceNilWithDefaultValue;
    if (BCJIsOptionSet(BCJMapOptionAllowsNilValue, mapOptions)) getterOptions |= BCJGetterOptionAllowsNilValue;
    return getterOptions;
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(id<BCJIndexedContainer> array, NSUInteger idx, Class elementClass, BCJMapOptions options, id target, NSString *targetKey, NSArray *sortDescriptors, id(^fromDictionaryMap)(id elementKey, id elementValue, NSError **outError)) {
    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {

        //Get the container
        NSDictionary *container;
        if (!BCJGetValue(array, idx, NSDictionary.class, getterOptionsFromMapOptions(options), @{}, &container, outError)) return NO;

        //Perform the mapping
        NSArray *values = BCJMap(container, elementClass, options, sortDescriptors, fromDictionaryMap, outError);
        BOOL didMappingSucceed = (values != nil);
        if (!didMappingSucceed) return NO;

        //Set the value
        return BCJSetValue(values, target, targetKey, outError);
    });
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(id<BCJIndexedContainer> array, NSUInteger idx, Class elementClass, BCJMapOptions options, id target, NSString *targetKey, id(^fromArrayMap)(NSUInteger elementIndex, id elementValue, NSError **outError)) {
    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {

        //Get the container
        NSArray *container;
        if (!BCJGetValue(array, idx, NSArray.class, getterOptionsFromMapOptions(options), @{}, &container, outError)) return NO;

        //Perform the mapping
        NSArray *values = BCJMap(container, elementClass, options, fromArrayMap, outError);
        BOOL didMappingSucceed = (values != nil);
        if (!didMappingSucceed) return NO;

        //Set the value
        return BCJSetValue(values, target, targetKey, outError);
    });
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(id<BCJKeyedContainer> dict, id key, Class elementClass, BCJMapOptions options, id target, NSString *targetKey, NSArray *sortDescriptors, id(^fromDictionaryMap)(id elementKey, id elementValue, NSError **outError)) {
    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {

        //Get the container
        NSDictionary *container;
        if (!BCJGetValue(dict, key, NSDictionary.class, getterOptionsFromMapOptions(options), @{}, &container, outError)) return NO;

        //Perform the mapping
        NSArray *values = BCJMap(container, elementClass, options, sortDescriptors, fromDictionaryMap, outError);
        BOOL didMappingSucceed = (values != nil);
        if (!didMappingSucceed) return NO;

        //Set the value
        return BCJSetValue(values, target, targetKey, outError);
    });
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(id<BCJKeyedContainer> dict, id key, Class elementClass, BCJMapOptions options, id target, NSString *targetKey, id(^fromArrayMap)(NSUInteger elementIndex, id elementValue, NSError **outError)) {
    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {

        //Get the container
        NSArray *container;
        if (!BCJGetValue(dict, key, NSArray.class, getterOptionsFromMapOptions(options), @{}, &container, outError)) return NO;

        //Perform the mapping
        NSArray *values = BCJMap(container, elementClass, options, fromArrayMap, outError);
        BOOL didMappingSucceed = (values != nil);
        if (!didMappingSucceed) return NO;
        
        //Set the value
        return BCJSetValue(values, target, targetKey, outError);
    });
}
