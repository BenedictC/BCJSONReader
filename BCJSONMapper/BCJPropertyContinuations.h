//
//  BCJPropertyContinuations.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 21/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <BCLContinuations/BCLContinuationProtocol.h>
#import "BCJDefines.h"
#import "BCJSourceConstants.h"
#import "BCJMapOptions.h"

@class BCJSource;
@class BCJTarget;



#pragma mark - Property Continuations
/**
 Performs a mapping from a JSONPath of the source to a property on the target object. Infers and conforms to types based on the target. Special cases for:

 id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromTimeIntervalSince1970(BCJSource *source, BCJTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
 id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromISO8601String(BCJSource *source, BCJTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
 id<BCLContinuation> BCJ_OVERLOADABLE BCJSetURL(BCJSource *source, BCJTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
 id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(BCJSource *source, BCJTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
 id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(BCJSource *source, BCJTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;

 Otherwise.

 id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(BCJSource *source, BCJTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
 id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(BCJSource *source, BCJTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
 id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(BCJSource *source, BCJTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
 id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(BCJSource *source, BCJTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
 id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(BCJSource *source, BCJTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
 id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(BCJSource *source, BCJTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;

 id<BCLContinuation> BCJ_OVERLOADABLE BCJSetValue(BCJSource *source, BCJTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;

 @param jsonPath     <#jsonPath description#>
 @param propertyKey  <#propertyKey description#>

 @return <#return value description#>
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetProperty(BCJSource *source, BCJTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;

/**
 <#Description#>

 @param sourceJsonPath    <#sourceJsonPath description#>
 @param targetPropertyKey <#targetPropertyKey description#>

 @return <#return value description#>
 */
#define BCJ_SET(sourceJsonPath, targetPropertyKey) BCJSetProperty(BCJCreateSource(sourceJsonPath), BCJCreateTarget(BCJ_KEY(targetPropertyKey)))



#pragma mark - Convienince constructors that implicitly take the stack source and target
//Setters that BCJMapping cannot infer so must be explicitly used.
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetEnum(NSString *sourceJSONPath, NSString *targetPropertyKey, NSDictionary *enumMapping) BCJ_REQUIRED(1,2,3) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(NSString *sourceJSONPath, NSString *targetPropertyKey, Class elementClass, BCJMapOptions options, id(^fromArrayMap)(NSUInteger elementIndex, id elementValue, NSError **outError)) BCJ_REQUIRED(1,2,5) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(NSString *sourceJSONPath, NSString *targetPropertyKey, Class elementClass, BCJMapOptions options, NSArray *sortDescriptors, id(^fromDictionaryMap)(id elementKey, id elementValue, NSError **outError)) BCJ_REQUIRED(1,2,6) BCJ_WARN_UNUSED;
