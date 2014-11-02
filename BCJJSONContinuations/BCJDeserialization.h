//
//  BCJDeserialization.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 27/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJDefines.h"
#import "BCJContainer.h"



#pragma mark - Constants
typedef NS_OPTIONS(NSUInteger, BCJJSONReadingOptions) {
    BCJJSONReadingMutableContainers  = (1UL  << 0),
    BCJJSONReadingMutableLeaves  = (1UL  << 1),
};



#pragma mark - JSON Deserialization continuations
//BCJContainer result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(NSData *data, BCJJSONReadingOptions options, BCJContainer *emptyContainer) __attribute__((nonnull(1,3)));
id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(NSData *data, BCJContainer *emptyContainer) __attribute__((nonnull(1,2)));

//Block result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(NSData *data, Class class, BCJJSONReadingOptions options, BOOL(^successBlock)(id fragment, NSError **outError)) __attribute__((nonnull(1,2,4)));
