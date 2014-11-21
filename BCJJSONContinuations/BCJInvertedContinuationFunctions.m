//
//  BCJJSONSource.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 04/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJStandardTypes.h"
#import "BCJAdditionalTypes.h"
#import "BCJMap.h"
#import "BCJGettersAndSetters.h"



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromTimeIntervalSince1970(BCJJSONSource *source, BCJPropertyTarget *target) {
    return BCJSetDateFromTimeIntervalSince1970(target, source);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromISO8601String(BCJJSONSource *source, BCJPropertyTarget *target) {
    return BCJSetDateFromISO8601String(target, source);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetURL(BCJJSONSource *source, BCJPropertyTarget *target) {
    return BCJSetURL(target, source);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetEnum(BCJJSONSource *source, BCJPropertyTarget *target, NSDictionary *enumMapping) {
    return BCJSetEnum(target, source, enumMapping);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetValue(BCJJSONSource *source, BCJPropertyTarget *target) {
    return BCJSetValue(target, source);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(BCJJSONSource *source, BCJPropertyTarget *target, Class elementClass, BCJMapOptions options, id(^fromArrayMap)(NSUInteger elementIndex, id elementValue, NSError **outError)) {
    return BCJSetMap(target, source, elementClass, options, fromArrayMap);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(BCJJSONSource *source, BCJPropertyTarget *target, Class elementClass, BCJMapOptions options, NSArray *sortDescriptors, id(^fromDictionaryMap)(id elementKey, id elementValue, NSError **outError)) {
    return BCJSetMap(target, source, elementClass, options, sortDescriptors, fromDictionaryMap);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(BCJJSONSource *source, BCJPropertyTarget *target) {
    return BCJSetArray(target, source);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(BCJJSONSource *source, BCJPropertyTarget *target) {
    return BCJSetMutableArray(target, source);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(BCJJSONSource *source, BCJPropertyTarget *target) {
    return BCJSetDictionary(target, source);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(BCJJSONSource *source, BCJPropertyTarget *target) {
    return BCJSetMutableDictionary(target, source);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(BCJJSONSource *source, BCJPropertyTarget *target) {
    return BCJSetString(target, source);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(BCJJSONSource *source, BCJPropertyTarget *target) {
    return BCJSetMutableString(target, source);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(BCJJSONSource *source, BCJPropertyTarget *target) {
    return BCJSetNumber(target, source);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(BCJJSONSource *source, BCJPropertyTarget *target) {
    return BCJSetNull(target, source);
}
