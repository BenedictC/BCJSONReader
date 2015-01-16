//
//  BCJSONPathEvaluation.m
//  BCJSONReader
//
//  Created by Benedict Cohen on 08/01/2015.
//  Copyright (c) 2015 Benedict Cohen. All rights reserved.
//

#import "BCJSONPathEvaluation.h"
#import "BCJSONPathParsing.h"
#import "BCJError.h"



id BCJEvaluateJSONPath(NSString *JSONPath, id object, NSUInteger *outFailedComponentIdx, id *outFailedComponent) {
    BCJParameterExpectation(JSONPath);
    BCJParameterExpectation(object);
    //Reset out vars
    if (outFailedComponentIdx != NULL) *outFailedComponentIdx = NSNotFound;
    if (outFailedComponent != NULL) *outFailedComponent = nil;

    //Get the containedObject if implemented, otherwise just use the object
    __block id lastValue = object;
    NSError *pathError = BCJEnumerateJSONPathComponents(JSONPath, ^(id component, NSUInteger componentIdx, BOOL *stop) {

        if ([component isKindOfClass:[NSNumber class]]) {
            //Index component
            if ([lastValue respondsToSelector:@selector(objectAtIndex:)] && [lastValue respondsToSelector:@selector(count)]) {

                long long componentValue = [component longLongValue];
                BOOL isNegativeIndex = componentValue < 0;
                long long count = [lastValue count];
                long long idx = (!isNegativeIndex) ? componentValue : ({
                    count + componentValue;
                });
                NSUInteger sizeSafeIdx = (NSUInteger)idx; //We do this dance to avoid type conversion warnings. The warnings are is incorrect because... TODO
                lastValue = (idx < count) ? [lastValue objectAtIndex:sizeSafeIdx] : nil;
            }
        } else if ([component isKindOfClass:[NSString class]]) {
            //keyed component
            if ([lastValue respondsToSelector:@selector(objectForKey:)]) {
                lastValue = [lastValue objectForKey:component];
            }
        } else if ([component isKindOfClass:[NSNull class]]) {
            //'self' component
            [lastValue self];
        }

        BOOL didFetchFail = (lastValue == nil);
        if (didFetchFail) {
            if (outFailedComponentIdx != NULL) *outFailedComponentIdx = componentIdx;
            if (outFailedComponent != NULL) *outFailedComponent = component;
            *stop = YES;
        }
    });

    BOOL didEvaluationFail = pathError != nil;
    if (didEvaluationFail) {
        BCJExpectation(pathError == nil, @"Error in JSON path: %@", pathError);
    }

    return lastValue;
}
