//
//  BCJDeserialization.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 27/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <BCLContinuations/BCLContinuations.h>
#import "BCJDefines.h"
#import "BCJDeserialization.h"
#import "BCJTarget.h"
#import "BCJContainer.h"
#import "BCJError.h"



#pragma mark - helper functions
static inline BOOL isOptionSet(NSInteger option, NSInteger options) {
    return (options & option) != 0;
}



#pragma mark - deserialization function
BOOL BCJ_OVERLOADABLE BCJDeserializeJSON(NSData *data, Class expectedClass, BCJJSONReadingOptions options, id __strong *outValue, NSError **outError) {
    //Reset outValue
    *outValue = nil;
    if (outError != NULL) *outError = nil;

    //Translate BCJJSONReadingOptions into NSJSONReadingOptions
    NSJSONReadingOptions jsonOptions = NSJSONReadingAllowFragments; //Always decode fragments because we do our own type checking later.
    if (isOptionSet(BCJJSONReadingMutableContainers, options)) jsonOptions |= NSJSONReadingMutableContainers;
    if (isOptionSet(BCJJSONReadingMutableLeaves, options))     jsonOptions |= NSJSONReadingMutableLeaves;

    //Create the JSON
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:jsonOptions error:NULL];
    if (jsonObject == nil) {
        if (outError != NULL) *outError = [BCJError invalidJSONDataErrorWithData:data];
        return NO;
    }

    //Check the type
    if (expectedClass != nil && ![jsonObject isKindOfClass:expectedClass]) {
        if (outError != NULL) *outError = [BCJError unexpectedTypeErrorWithSource:nil value:jsonObject expectedClass:expectedClass];
        return NO;
    }

    //Success!
    *outValue = jsonObject;
    return YES;
}



#pragma mark - JSON Deserialization continuations
//BCJContainer result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(BCJContainer *emptyContainer, NSData *data, BCJJSONReadingOptions options) {
    BCJParameterExpectation(emptyContainer != nil);
    BCJParameterExpectation(!emptyContainer.isSealed);
    BCJParameterExpectation(data != nil);

    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        id content;
        if (!BCJDeserializeJSON(data, NSObject.class, options, &content, outError)) return NO;

        [emptyContainer setContentAndSeal:content];

        return YES;
    });
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(BCJContainer *emptyContainer, NSData *data) {
    return BCJDeserializeJSON(emptyContainer, data, 0);
}



//Block result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(NSData *data, Class class, BCJJSONReadingOptions options, BOOL(^successBlock)(id fragment, NSError **outError)) {
    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        id content;
        if (!BCJDeserializeJSON(data, class, options, &content, outError)) return NO;

        return successBlock(content, outError);
    });
}
