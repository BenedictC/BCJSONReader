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
/**
 Options used when desearializing JSON objects using BCJDeserializeJSON functions.
 */
typedef NS_OPTIONS(NSUInteger, BCJJSONReadingOptions){
    /**
     Specifies that arrays and dictionaries are created as mutable objects.
     */
    BCJJSONReadingMutableContainers  =(1UL  << 0),
    /**
     Specifies that leaf strings in the JSON object graph are created as instances of NSMutableString.
     */
    BCJJSONReadingMutableLeaves  =(1UL  << 1),
};



#pragma mark - deserialization function
/**
 Returns by reference Foundation objects representing the supplied JSON data. Internally this function uses NSJSONSerialization to perform the deserialization.

 @param data     The JSON data.
 @param class    The expected class of the root object of the deserialized JSON. If the root object is not of the expected type then deserialization fails. If the nil then type checking is skipped.
 @param options  Deserialization options.
 @param outValue On success contains the value, otherwise nil.
 @param outError On failure contains an NSError describing the reason for failure, otherwise nil.

 @return YES on success, otherwise NO.
 */
BOOL BCJ_OVERLOADABLE BCJDeserializeJSON(NSData *data, Class class, BCJJSONReadingOptions options, id __strong *outValue, NSError **outError) BCJ_REQUIRED(1,4);

#pragma mark - JSON Deserialization continuations
/**
 Returns a continuation that calls BCJDeserializeJSON and if a value was fetched invokes setContentAndSeal: on emptyContainer with the value.

 @param emptyContainer an instance of BCJContainer which is unsealed.
 @param data           The JSON data to deserialize.
 @param options        Deserialzation options.

 @return A continuation.
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(BCJContainer *emptyContainer, NSData *data, BCJJSONReadingOptions options) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
/**
 Calls BCJDeserializeJSON with options 0.

 @param emptyContainer an instance of BCJContainer which is unsealed.
 @param data           The JSON data to deserialize.

 @return A continuation.
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(BCJContainer *emptyContainer, NSData *data) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;

/**
 Returns a continuation that calls BCJDeserializeJSON and if a value was fetched invokes successBlock with the returned data. This function can be used when deserializing JSON fragments.

 @param data          The JSON data to deserialize.
 @param class         The expected class of the root object of the deserialized JSON. If the root object is not of the expected type then deserialization fails. If the nil then type checking is skipped.
 @param options       Deserialization options.
 @param ^successBlock A block that's invoked if deserialization succeeds. The return value of the block is used as the completion status of the continuation.

 @return A continuation.
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(NSData *data, Class class, BCJJSONReadingOptions options, BOOL(^successBlock)(id fragment, NSError **outError)) BCJ_REQUIRED(1,2,4) BCJ_WARN_UNUSED;
