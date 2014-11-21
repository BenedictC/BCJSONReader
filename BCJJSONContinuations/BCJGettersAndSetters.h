//
//  BCJGettersAndSetters.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 01/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BCLContinuations.h"
#import "BCJDefines.h"

@class BCJJSONSource;
@class BCJPropertyTarget;



#pragma mark - Get arbitary object continuations
/**
 Returns a continuation that invokes getValue:error: on target 

 @param source        A source.
 @param ^successBlock A block that's invoked if a value is fetched from source. The return value of the block is used as the completion status of the continuation.

 @return A continuation.
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJGetValue(BCJJSONSource *source, BOOL(^successBlock)(id value, NSError **outError)) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;



#pragma mark - Set arbitary object continuations
/**
 Returns a continuation that  invokes getValue:error: on target and if a value was fetched invokes setValue:outError: on target with the value.

 @param target A target.
 @param source A source.

 @return A continuation.
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetValue(BCJPropertyTarget *target, BCJJSONSource *source) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
