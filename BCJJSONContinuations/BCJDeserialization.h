//
//  BCJDeserialization.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 27/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BCLContinuationProtocol.h"
#import "BCJDefines.h"

@class BCJContainer;



#pragma mark - Constants
typedef NS_OPTIONS(NSUInteger, BCJJSONReadingOptions) {
    BCJJSONReadingMutableContainers  = (1UL  << 0),
    BCJJSONReadingMutableLeaves  = (1UL  << 1),
};



#pragma mark - deserialization function
BOOL BCJ_OVERLOADABLE BCJDeserializeJSON(NSData *data, Class class, BCJJSONReadingOptions options, id __strong *outValue, NSError **outError) BCJ_REQUIRED(1,4);

#pragma mark - JSON Deserialization continuations
//BCJContainer result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(BCJContainer *emptyContainer, NSData *data, BCJJSONReadingOptions options) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(BCJContainer *emptyContainer, NSData *data) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;

//Block result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(NSData *data, Class class, BCJJSONReadingOptions options, BOOL(^successBlock)(id fragment, NSError **outError)) BCJ_REQUIRED(1,2,4) BCJ_WARN_UNUSED;
