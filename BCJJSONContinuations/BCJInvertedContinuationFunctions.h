//
//  BCJInvertedFunctions.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 11/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

/**
 The functions in this file exist so that the order of target and source can be switched. This file will be removed once it's been decided which form is better.
 
 Rational for (target, source): Setters in Core Foundation follow the conventional that the struct being mutated is the first argument to the function.
 Rational for (source, target): It feels more natural that the arguments describe the flow of data from the source to the target.
 */


id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromTimeIntervalSince1970(BCJJSONSource *source, BCJJSONTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromISO8601String(BCJJSONSource *source, BCJJSONTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetURL(BCJJSONSource *source, BCJJSONTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetEnum(BCJJSONSource *source, BCJJSONTarget *target, NSDictionary *enumMapping) BCJ_REQUIRED(1,2,3) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetValue(BCJJSONSource *source, BCJJSONTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(BCJJSONSource *source, BCJJSONTarget *target, Class elementClass, BCJMapOptions options, id(^fromArrayMap)(NSUInteger elementIndex, id elementValue, NSError **outError)) BCJ_REQUIRED(1,2,5) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(BCJJSONSource *source, BCJJSONTarget *target, Class elementClass, BCJMapOptions options, NSArray *sortDescriptors, id(^fromDictionaryMap)(id elementKey, id elementValue, NSError **outError)) BCJ_REQUIRED(1,2,6) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(BCJJSONSource *source, BCJJSONTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(BCJJSONSource *source, BCJJSONTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(BCJJSONSource *source, BCJJSONTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(BCJJSONSource *source, BCJJSONTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(BCJJSONSource *source, BCJJSONTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(BCJJSONSource *source, BCJJSONTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(BCJJSONSource *source, BCJJSONTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(BCJJSONSource *source, BCJJSONTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;

