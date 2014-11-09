//
//  BCJStandardTypes.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 31/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCLContinuation.h"
#import "BCJDefines.h"

@class BCJJSONTarget;
@class BCJJSONSource;



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(BCJJSONTarget *target, BCJJSONSource *source) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(BCJJSONTarget *target, BCJJSONSource *source) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(BCJJSONTarget *target, BCJJSONSource *source) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(BCJJSONTarget *target, BCJJSONSource *source) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(BCJJSONTarget *target, BCJJSONSource *source) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(BCJJSONTarget *target, BCJJSONSource *source) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(BCJJSONTarget *target, BCJJSONSource *source) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(BCJJSONTarget *target, BCJJSONSource *source) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
