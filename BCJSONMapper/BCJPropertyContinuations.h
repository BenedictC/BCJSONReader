//
//  BCJPropertyContinuations.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 21/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <BCLContinuations/BCLContinuationProtocol.h>
#import "BCJDefines.h"
#import "BCJJSONSourceConstants.h"
#import "BCJMapOptions.h"

@class BCJJSONSource;
@class BCJPropertyTarget;



#pragma mark - Property Continuations
/**
 Performs a mapping from a JSONPath of the source to a property on the target object. Infers and conforms to types based on the target. Special cases for:

 id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromTimeIntervalSince1970(BCJJSONSource *source, BCJPropertyTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
 id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromISO8601String(BCJJSONSource *source, BCJPropertyTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
 id<BCLContinuation> BCJ_OVERLOADABLE BCJSetURL(BCJJSONSource *source, BCJPropertyTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
 id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(BCJJSONSource *source, BCJPropertyTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
 id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(BCJJSONSource *source, BCJPropertyTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;

 Otherwise.

 id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(BCJJSONSource *source, BCJPropertyTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
 id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(BCJJSONSource *source, BCJPropertyTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
 id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(BCJJSONSource *source, BCJPropertyTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
 id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(BCJJSONSource *source, BCJPropertyTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
 id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(BCJJSONSource *source, BCJPropertyTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
 id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(BCJJSONSource *source, BCJPropertyTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;

 id<BCLContinuation> BCJ_OVERLOADABLE BCJSetValue(BCJJSONSource *source, BCJPropertyTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;

 @param jsonPath     <#jsonPath description#>
 @param propertyKey  <#propertyKey description#>

 @return <#return value description#>
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetProperty(BCJJSONSource *source, BCJPropertyTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
/**
 <#Description#>

 @param jsonPath     <#jsonPath description#>
 @param propertyKey  <#propertyKey description#>

 @return <#return value description#>
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetProperty(NSString *sourceJsonPath, NSString *targetPropertyKey) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;


/**
 <#Description#>

 @param sourceJsonPath    <#sourceJsonPath description#>
 @param targetPropertyKey <#targetPropertyKey description#>

 @return <#return value description#>
 */
#define BCJ_SET(sourceJsonPath, targetPropertyKey) BCJSetProperty(sourceJsonPath, BCJ_KEY(targetPropertyKey))



#pragma mark - Convienince constructors that implicitly take the stack source and target
//Setters that BCJMapping cannot infer so must be explicitly used.
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetEnum(NSString *sourceJSONPath, NSString *targetPropertyKey, NSDictionary *enumMapping) BCJ_REQUIRED(1,2,3) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(NSString *sourceJSONPath, NSString *targetPropertyKey, Class elementClass, BCJMapOptions options, id(^fromArrayMap)(NSUInteger elementIndex, id elementValue, NSError **outError)) BCJ_REQUIRED(1,2,5) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(NSString *sourceJSONPath, NSString *targetPropertyKey, Class elementClass, BCJMapOptions options, NSArray *sortDescriptors, id(^fromDictionaryMap)(id elementKey, id elementValue, NSError **outError)) BCJ_REQUIRED(1,2,6) BCJ_WARN_UNUSED;
