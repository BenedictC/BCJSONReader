//
//  BCLContinuation+ControlFlow.m
//  BCMJSONAccess
//
//  Created by Benedict Cohen on 27/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLContinuation.h"



@implementation BCLContinuation

+(NSArray *)untilEnd:(id<BCLContinuation>)firstContinuation, ...
{
    NSMutableArray *errors = [NSMutableArray new];

    va_list args;
    va_start(args, firstContinuation);
    id<BCLContinuation> currentContinuation = firstContinuation;
    while (currentContinuation != nil) {

        NSError *error = nil;
        if (![currentContinuation executeAndReturnError:&error] && error != nil) {
            [errors addObject:error];
        }

        currentContinuation = va_arg(args, id);
    }
    va_end(args);

    return (errors.count == 0) ? nil : errors;
}



+(NSError *)untilError:(id<BCLContinuation>)firstContinuation, ...
{
    va_list args;
    va_start(args, firstContinuation);
    id<BCLContinuation> currentContinuation = firstContinuation;
    while (currentContinuation != nil) {

        NSError *error = nil;
        if (![currentContinuation executeAndReturnError:&error]) {
            return error;
        }

        currentContinuation = va_arg(args, id);
    }
    va_end(args);

    return nil;
}

@end
