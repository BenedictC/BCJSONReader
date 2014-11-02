//
//  BCLContinuation+ControlFlowContinuations.m
//  BCMJSONAccess
//
//  Created by Benedict Cohen on 30/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLContinuation+ControlFlowContinuations.h"
#import "BCLContinuation+ControlFlow+Protected.h"
#import "BCLBlockContinuation.h"



id<BCLContinuation> BCLUntilEnd(id<BCLContinuation> firstContinuation, ...) {

    NSMutableArray *continuations = [NSMutableArray new];

    va_list args;
    va_start(args, firstContinuation);
    id<BCLContinuation> currentContination = firstContinuation;
    while (currentContination != nil) {
        [continuations addObject:currentContination];
        va_arg(args, id<BCLContinuation>);
    }
    va_end(args);

    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        NSError *error = [BCLContinuation untilEndWithContinuations:continuations];
        if (outError != NULL) *outError = error;
        return (error == nil);
    });
}



id<BCLContinuation> BCLUntilError(id<BCLContinuation> firstContinuation, ...) {

    NSMutableArray *continuations = [NSMutableArray new];

    va_list args;
    va_start(args, firstContinuation);
    id<BCLContinuation> currentContination = firstContinuation;
    while (currentContination != nil) {
        [continuations addObject:currentContination];
        va_arg(args, id<BCLContinuation>);
    }
    va_end(args);

    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        NSError *error = [BCLContinuation untilErrorWithContinuations:continuations];
        if (outError != NULL) *outError = error;
        return (error == nil);
    });
}
