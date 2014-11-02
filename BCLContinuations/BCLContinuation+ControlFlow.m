//
//  BCLContinuation+ControlFlow.m
//  BCMJSONAccess
//
//  Created by Benedict Cohen on 27/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLContinuation.h"


NSString * const BCLErrorDomain = @"BCLErrorDomain";

NSString * const BCLDetailedErrorsKey = @"BCLDetailedErrorsKey";



@interface BCLContinuation ()

@property(nonatomic) BOOL shouldAbort;
@property(nonatomic) NSError *abortionError;

@end



@implementation BCLContinuation

#pragma mark - Continuation Stack
+(NSMutableArray *)continuationsStack
{
    static NSString * const key = @"BCLContinuation.continuationsStack";
    NSMutableArray *stack = [[NSThread currentThread] threadDictionary][key];

    if (stack == nil) {
        stack = [NSMutableArray new];
        [[NSThread currentThread] threadDictionary][key] = stack;
    }

    return stack;
}



+(BCLContinuation *)currentContinuation
{
    return [[BCLContinuation continuationsStack] lastObject];
}



+(void)pushContinuation:(BCLContinuation *)continuation
{
    [[BCLContinuation continuationsStack] addObject:continuation];
}



+(void)popContinuation
{
    [[BCLContinuation continuationsStack] removeLastObject];
}



#pragma mark - Private control flow
-(NSError *)untilEndWithContinuations:(NSArray *)continuations
{
    NSMutableArray *errors = [NSMutableArray new];

    [BCLContinuation pushContinuation:self];

    for (id<BCLContinuation> currentContinuation in continuations) {

        //Check that we should continue
        if (self.shouldAbort) {
            NSError *error = (self.abortionError) ?: [NSError errorWithDomain:BCLErrorDomain code:BCLUnknownError userInfo:nil];
            [errors addObject:error];
            goto AuRevoir;
        }

        //Execute the continuation
        NSError *error = nil;
        if (![currentContinuation executeAndReturnError:&error] && error != nil) {
            [errors addObject:error];
        }
    }

    AuRevoir:

    [BCLContinuation popContinuation];
    NSError *error = (errors.count > 0) ? [NSError errorWithDomain:BCLErrorDomain code:BCLMultipleErrorsError userInfo:@{BCLDetailedErrorsKey:errors}] : nil;

    return error;
}



-(NSError *)untilErrorWithContinuations:(NSArray *)continuations
{
    NSError *error = nil;

    [BCLContinuation pushContinuation:self];

    for (id<BCLContinuation> currentContinuation in continuations) {

        //Check that we should continue
        if (self.shouldAbort) {
            error = (self.abortionError) ?: [NSError errorWithDomain:BCLErrorDomain code:BCLUnknownError userInfo:nil];
            goto AuRevoir;
        }

        //Execute the continuation
        if (![currentContinuation executeAndReturnError:&error]) {
            goto AuRevoir;
        }
    }

    AuRevoir:

    [BCLContinuation popContinuation];

    return error;
}



#pragma mark - protected control flow
+(NSError *)untilEndWithContinuations:(NSArray *)continuations
{
    return [[BCLContinuation new] untilEndWithContinuations:continuations];
}



+(NSError *)untilErrorWithContinuations:(NSArray *)continuations
{
    return [[BCLContinuation new] untilErrorWithContinuations:continuations];
}



#pragma mark - Public control flow
+(NSError *)untilEnd:(id<BCLContinuation>)firstContinuation, ...
{
    NSMutableArray *continuations = [NSMutableArray new];
    va_list args;
    va_start(args, firstContinuation);
    id<BCLContinuation> currentContination = firstContinuation;
    while (currentContination != nil) {
        [continuations addObject:currentContination];

        currentContination = va_arg(args, id<BCLContinuation>);
    }
    va_end(args);

    return [BCLContinuation untilEndWithContinuations:continuations];
}



+(NSError *)untilError:(id<BCLContinuation>)firstContinuation, ...
{
    NSMutableArray *continuations = [NSMutableArray new];
    va_list args;
    va_start(args, firstContinuation);
    id<BCLContinuation> currentContination = firstContinuation;
    while (currentContination != nil) {
        [continuations addObject:currentContination];

        currentContination = va_arg(args, id<BCLContinuation>);
    }
    va_end(args);

    return [BCLContinuation untilErrorWithContinuations:continuations];
}



-(void)abortWithError:(NSError *)error
{
    self.shouldAbort = YES;
    //We only store the first abortion error
    if (self.abortionError == nil) self.abortionError = error;
}

@end
