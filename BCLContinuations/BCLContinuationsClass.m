//
//  BCLContinuationsClass.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 27/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLContinuationsClass.h"
#import "BCLContinuationsClass+AdditionalControlFlow.h"



NSString * const BCLErrorDomain = @"BCLErrorDomain";

NSString * const BCLDetailedErrorsKey = @"BCLDetailedErrorsKey";



@interface BCLContinuations ()

@property(nonatomic, readonly) NSArray *continuations;

@end



@implementation BCLContinuations

#pragma mark - Additional control flow

+(NSError *)untilEndWithContinuations:(NSArray *)continuations
{
    __block NSError *returnError = nil;

    [self continueUntilError:continuations completionHandler:^(BOOL didSucceed, NSError *error) {
        returnError = (didSucceed) ? nil : error;
    }];

    return returnError;
}



+(NSError *)untilErrorWithContinuations:(NSArray *)continuations
{
    __block NSError *returnError = nil;

    [self continueUntilError:continuations completionHandler:^(BOOL didSucceed, NSError *error) {
        returnError = (didSucceed) ? nil : error;
    }];

    return returnError;
}



+(void)continueUntilEnd:(NSArray *)continuations errors:(NSArray *)errors completionHandler:(void (^)(BOOL didSucceed, NSError *error))completionHandler
{
    id<BCLContinuation> continuation = [continuations firstObject];
    if (continuation == nil) {
        BOOL didSucceed = errors.count == 0;
        NSError *error = (didSucceed) ? nil : [NSError errorWithDomain:BCLErrorDomain code:BCLMultipleErrorsError userInfo:@{BCLDetailedErrorsKey:errors}];
        completionHandler(YES, error);
        return;
    }

    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        NSArray *nextErrors = (!didSucceed && error == nil) ? [errors arrayByAddingObject:error] : errors;
        NSArray *remainingContinuations = [continuations subarrayWithRange:(NSRange){.location = 1, .length = continuations.count-1}];
        [BCLContinuations continueUntilEnd:remainingContinuations errors:nextErrors completionHandler:completionHandler];
    }];
}



+(void)continueUntilError:(NSArray *)continuations completionHandler:(void (^)(BOOL didSucceed, NSError *error))completionHandler
{
    id<BCLContinuation> continuation = [continuations firstObject];
    if (continuation == nil) {
        completionHandler(YES, nil);
        return;
    }

    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        if (!didSucceed) {
            completionHandler(NO, error);
            return;
        }

        NSArray *remainingContinuations = [continuations subarrayWithRange:(NSRange){.location = 1, .length = continuations.count-1}];
        [BCLContinuations continueUntilError:remainingContinuations completionHandler:completionHandler];
    }];
}



#pragma mark - Public control flow
+(void)untilEndWithCompletionHandler:(void(^)(BOOL didSucceed, NSError *error))completionHandler continuations:(id<BCLContinuation>)firstContinuation, ...
{
    NSArray *continuations = BCJ_CONTINUATIONS_ARRAY_FROM_VARGS(firstContinuation);
    [self continueUntilEnd:continuations errors:@[] completionHandler:completionHandler];
}



+(void)untilErrorWithCompletionHandler:(void(^)(BOOL didSucceed, NSError *error))completionHandler continuations:(id<BCLContinuation>)firstContinuation, ...
{
    NSArray *continuations = BCJ_CONTINUATIONS_ARRAY_FROM_VARGS(firstContinuation);
    [self continueUntilError:continuations completionHandler:completionHandler];
}



+(NSError *)untilEnd:(id<BCLContinuation>)firstContinuation, ...
{
    NSArray *continuations = BCJ_CONTINUATIONS_ARRAY_FROM_VARGS(firstContinuation);
    return [BCLContinuations untilEndWithContinuations:continuations];
}



+(NSError *)untilError:(id<BCLContinuation>)firstContinuation, ...
{
    NSArray *continuations = BCJ_CONTINUATIONS_ARRAY_FROM_VARGS(firstContinuation);
    return [BCLContinuations untilErrorWithContinuations:continuations];
}

@end
