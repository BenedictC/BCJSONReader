//
//  BCJDeserialization.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 27/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLContinuation.h"
#import "BCJDeserialization.h"
#import "BCJCore.h"



#pragma mark - deserialization function
static inline BOOL deserializeJSON(NSData *data, Class class, BCJJSONReadingOptions options, id __strong *outValue, NSError **outError) {
    //Reset outValue
    *outValue = nil;

    //Translate BCJJSONReadingOptions into NSJSONReadingOptions
    NSJSONReadingOptions jsonOptions = NSJSONReadingAllowFragments;
    if (BCJIsOptionSet(BCJJSONReadingMutableContainers, options)) jsonOptions |= NSJSONReadingMutableContainers;
    if (BCJIsOptionSet(BCJJSONReadingMutableLeaves, options))     jsonOptions |= NSJSONReadingMutableLeaves;

    //Create the JSON
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:jsonOptions error:outError];
    if (jsonObject == nil) {
        return NO;
    }

    //Check the type
    if (![jsonObject isKindOfClass:class]) {
        if (outError != NULL) *outError = [NSError errorWithDomain:@"TODO: Wrong class type" code:0 userInfo:nil];
        return NO;
    }

    //Success!
    *outValue = jsonObject;
    return YES;
}



#pragma mark - JSON Deserialization continuations
//BCJContainer result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(NSData *data, BCJJSONReadingOptions options, BCJContainer *emptyContainer) {
    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        id content;
        if (!deserializeJSON(data, NSObject.class, options, &content, outError)) return NO;

        [emptyContainer setContentAndSeal:content];

        return YES;
    });
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(NSData *data, BCJContainer *emptyContainer) {
    return BCJDeserializeJSON(data, 0, emptyContainer);
}



//Block result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(NSData *data, Class class, BCJJSONReadingOptions options, BOOL(^successBlock)(id fragment, NSError **outError)) {
    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        id content;
        if (!deserializeJSON(data, class, options, &content, outError)) return NO;

        return successBlock(content, outError);
    });
}
