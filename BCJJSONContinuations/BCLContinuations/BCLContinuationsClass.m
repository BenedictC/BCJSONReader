//
//  BCLContinuationsClass.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 27/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLContinuationsClass.h"


NSString * const BCLErrorDomain = @"BCLErrorDomain";

NSString * const BCLDetailedErrorsKey = @"BCLDetailedErrorsKey";


#pragma mark - helper macros
#define CONTINUATIONS_FROM_VARGS(FIRST_CONTINUATION) ({ \
NSMutableArray *continuations = [NSMutableArray new]; \
va_list args; \
va_start(args, FIRST_CONTINUATION); \
id<BCLContinuation> currentContination = firstContinuation; \
while (currentContination != nil) { \
    [continuations addObject:currentContination]; \
    currentContination = va_arg(args, id<BCLContinuation>); \
} \
va_end(args); \
    continuations; \
 })



@interface BCLContinuations ()

@property(nonatomic, readonly) NSArray *continuations;
@property(nonatomic) BOOL shouldAbort;
@property(nonatomic) NSError *abortionError;

@end



@implementation BCLContinuations

#pragma mark - Continuations Stack
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



+(void)pushContinuations:(BCLContinuations *)continuations
{
    [[BCLContinuations continuationsStack] addObject:continuations];
}



+(void)popContinuations
{
    [[BCLContinuations continuationsStack] removeLastObject];
}



+(BCLContinuations *)currentContinuations
{
    return [[BCLContinuations continuationsStack] lastObject];
}



#pragma mark - instance life cycle
-(instancetype)initWithContinuations:(NSArray *)continuations
{
    self = [super init];

    if (self == nil) return nil;

    _continuations = [continuations copy];

    return self;
}



#pragma mark - Private control flow
-(NSError *)executeUntilEnd
{
    NSMutableArray *errors = [NSMutableArray new];

    [BCLContinuations pushContinuations:self];

    for (id<BCLContinuation> currentContinuation in self.continuations) {

        //Check that we should continue
        if (self.shouldAbort) {
            NSError *error = (self.abortionError) ?: [NSError errorWithDomain:BCLErrorDomain code:BCLUnknownError userInfo:nil];
            [errors addObject:error];
            goto AuRevoir;
        }

        //Execute the continuation
        [currentContinuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
            if (!didSucceed && error != nil) [errors addObject:error];
        }];
    }

    AuRevoir:

    [BCLContinuations popContinuations];

    NSError *error = (errors.count > 0) ? [NSError errorWithDomain:BCLErrorDomain code:BCLMultipleErrorsError userInfo:@{BCLDetailedErrorsKey:errors}] : nil;
    return error;
}



-(NSError *)executeUntilError
{
    __block NSError *exitError = nil;

    [BCLContinuations pushContinuations:self];

    for (id<BCLContinuation> currentContinuation in self.continuations) {

        //Check that we should continue
        if (self.shouldAbort) {
            exitError = (self.abortionError) ?: [NSError errorWithDomain:BCLErrorDomain code:BCLUnknownError userInfo:nil];
            goto AuRevoir;
        }

        //Execute the continuation
        __block BOOL shouldExit = NO;
        [currentContinuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
            shouldExit = !didSucceed;
            exitError = error;
        }];
        if (shouldExit) goto AuRevoir;
    }

    AuRevoir:

    [BCLContinuations popContinuations];

    return exitError;
}



#pragma mark - protected control flow
+(NSError *)untilEndWithContinuations:(NSArray *)continuations
{
    return [[[BCLContinuations alloc] initWithContinuations:continuations] executeUntilEnd];
}



+(NSError *)untilErrorWithContinuations:(NSArray *)continuations
{
    return [[[BCLContinuations alloc] initWithContinuations:continuations] executeUntilError];
}



#pragma mark - Public control flow
+(NSError *)untilEnd:(id<BCLContinuation>)firstContinuation, ...
{
    NSArray *continuations = CONTINUATIONS_FROM_VARGS(firstContinuation);

    return [BCLContinuations untilEndWithContinuations:continuations];
}



+(NSError *)untilError:(id<BCLContinuation>)firstContinuation, ...
{
    NSArray *continuations = CONTINUATIONS_FROM_VARGS(firstContinuation);

    return [BCLContinuations untilErrorWithContinuations:continuations];
}



//TODO: Why do we need this method? Why would we want to cancel a continuation rather than just have a continutation fail?
-(void)abortWithError:(NSError *)error
{
    self.shouldAbort = YES;
    //We only store the first abortion error
    if (self.abortionError == nil) self.abortionError = error;
}

@end
