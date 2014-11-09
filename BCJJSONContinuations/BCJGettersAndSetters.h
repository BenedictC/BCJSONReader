//
//  BCJGettersAndSetters.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 01/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BCLContinuation.h"
#import "BCJDefines.h"

@class BCJJSONSource;
@class BCJJSONTarget;



#pragma mark - Get arbitary object continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJGetValue(BCJJSONSource *source, BOOL(^successBlock)(id value, NSError **outError)) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;



#pragma mark - Set arbitary object continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetValue(BCJJSONTarget *target, BCJJSONSource *source) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
