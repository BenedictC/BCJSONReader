//
//  BCJMap.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 01/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLContinuation.h"
#import "BCJDefines.h"
#import "BCJConstants.h"
#import "BCJContainerProtocols.h"



#pragma mark - constants
typedef NS_OPTIONS(NSUInteger, BCJMapOptions) {
    //Input handling
    BCJMapOptionReplaceNullWithNil  = (1UL  << 0),
    BCJMapOptionReplaceNilWithEmptyCollection = (1UL  << 1),
    BCJMapOptionAllowsNilValue  = (1UL  << 2),

    //Control flow behaviour
    BCJMapOptionDiscardMappingErrors  = (1UL  << 3),
};



//Mapping modes (i.e. predefined mapping options)
typedef BCJMapOptions BCJMapMode;
const static BCJMapOptions BCJMapModeMandatory           = 0;

const static BCJMapOptions BCJMapModeOptional            = BCJMapOptionAllowsNilValue;
const static BCJMapOptions BCJMapModeDefaultable         = BCJMapOptionAllowsNilValue     | BCJMapOptionReplaceNilWithEmptyCollection;

const static BCJMapOptions BCJMapModeNullableOptional    = BCJMapOptionReplaceNullWithNil | BCJMapOptionAllowsNilValue;
const static BCJMapOptions BCJMapModeNullableDefaultable = BCJMapOptionReplaceNullWithNil | BCJMapOptionAllowsNilValue | BCJMapOptionReplaceNilWithEmptyCollection;

const static BCJMapOptions BCJMapModeMandatoryLenient           = BCJMapOptionDiscardMappingErrors;

const static BCJMapOptions BCJMapModeOptionalLenient            = BCJMapModeOptional | BCJMapOptionDiscardMappingErrors;
const static BCJMapOptions BCJMapModeDefaultableLenient         = BCJMapModeDefaultable | BCJMapOptionDiscardMappingErrors;

const static BCJMapOptions BCJMapModeNullableOptionalLenient    = BCJMapModeNullableOptional | BCJMapOptionDiscardMappingErrors;
const static BCJMapOptions BCJMapModeNullableDefaultableLenient = BCJMapModeNullableDefaultable | BCJMapOptionDiscardMappingErrors;



#pragma mark - Map functions
BCJ_OVERLOADABLE NSArray *BCJMap(NSDictionary *dict, Class elementClass, BCJMapOptions options, NSArray *sortDescriptiors, id(^mapFromDictionary)(id elementKey, id elementValue, NSError **outError), NSError **outError) __attribute__((nonnull(1,2,4,5)));

BCJ_OVERLOADABLE NSArray *BCJMap(NSArray *array, Class elementClass, BCJMapOptions options, id(^mapFromArray)(NSUInteger elementIdx, id elementValue, NSError **outError), NSError **outError) __attribute__((nonnull(1,2,4,5)));



#pragma mark - Set Map continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(id<BCJIndexedContainer> array, NSUInteger idx, Class elementClass, BCJMapOptions options, id target, NSString *targetKey, id(^fromArrayMap)(NSUInteger elementIndex, id elementValue, NSError **outError)) __attribute__((nonnull(1,3,5,6,7)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(id<BCJIndexedContainer> array, NSUInteger idx, Class elementClass, BCJMapOptions options, id target, NSString *targetKey, NSArray *sortDescriptors, id(^fromDictionaryMap)(id elementKey, id elementValue, NSError **outError)) __attribute__((nonnull(1,3,5,6,8)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(id<BCJIndexedContainer> array, NSUInteger idx, Class elementClass, BCJMapOptions options, id target, NSString *targetKey, NSString *sortKey, id(^fromDictionaryMap)(id elementKey, id elementValue, NSError **outError)) __attribute__((nonnull(1,3,5,6,8)));

id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(id<BCJKeyedContainer> dict, id key, Class elementClass, BCJMapOptions options, id target, NSString *targetKey, id(^fromArrayMap)(NSUInteger elementIndex, id elementValue, NSError **outError)) __attribute__((nonnull(1,2,3,5,6,7)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(id<BCJKeyedContainer> dict, id key, Class elementClass, BCJMapOptions options, id target, NSString *targetKey, NSArray *sortDescriptors, id(^fromDictionaryMap)(id elementKey, id elementValue, NSError **outError)) __attribute__((nonnull(1,2,3,5,6,8)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(id<BCJKeyedContainer> dict, id key, Class elementClass, BCJMapOptions options, id target, NSString *targetKey, NSString *sortKey, id(^fromDictionaryMap)(id elementKey, id elementValue, NSError **outError)) __attribute__((nonnull(1,2,3,5,6,8)));
