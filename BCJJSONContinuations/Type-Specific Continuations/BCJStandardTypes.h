//
//  BCJStandardTypes.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 31/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCLContinuations.h"
#import "BCJDefines.h"

@class BCJJSONSource;
@class BCJPropertyTarget;



/**
 Returns a continuation that attempts to get an NSArray from source and if successful attempts to set the value of target with the fetched value.

 @param target A target that references an NSArray property.
 @param source A source that references an NSArray.

 @return A continuation.
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(BCJJSONSource *source, BCJPropertyTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
/**
 Returns a continuation that attempts to get an NSMutableArray from source and if successful attempts to set the value of target with the fetched value.

 @param target A target that references an NSMutableArray property.
 @param source A source that references an NSMutableArray.

 @return A continuation.
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(BCJJSONSource *source, BCJPropertyTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
/**
 Returns a continuation that attempts to get an NSDictionary from source and if successful attempts to set the value of target with the fetched value.

 @param target A target that references an NSDictionary property.
 @param source A source that references an NSDictionary.

 @return A continuation.
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(BCJJSONSource *source, BCJPropertyTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
/**
 Returns a continuation that attempts to get an NSMutableDictionary from source and if successful attempts to set the value of target with the fetched value.

 @param target A target that references an NSMutableDictionary property.
 @param source A source that references an NSMutableDictionary.

 @return A continuation.
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(BCJJSONSource *source, BCJPropertyTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
/**
 Returns a continuation that attempts to get an NSString from source and if successful attempts to set the value of target with the fetched value.

 @param target A target that references an NSString property.
 @param source A source that references an NSString.

 @return A continuation.
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(BCJJSONSource *source, BCJPropertyTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
/**
 Returns a continuation that attempts to get an NSMutableString from source and if successful attempts to set the value of target with the fetched value.

 @param target A target that references an NSMutableString property.
 @param source A source that references an NSMutableString.

 @return A continuation.
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(BCJJSONSource *source, BCJPropertyTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
/**
 Returns a continuation that attempts to get an NSNumber from source and if successful attempts to set the value of target with the fetched value.

 @param target A target that references an NSNumber or number scalar type property.
 @param source A source that references an NSNumber.

 @return A continuation.
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(BCJJSONSource *source, BCJPropertyTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
/**
 Returns a continuation that attempts to get an NSNull from source and if successful attempts to set the value of target with the fetched value.

 @param target A target that references an NSNull property.
 @param source A source that references an NSNull.

 @return A continuation.
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(BCJJSONSource *source, BCJPropertyTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;