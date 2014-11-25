//
//  BCLContinuationsClass.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 27/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLContinuationsClass.h"
#import "BCLContinuationsDefines.h"



NSString * const BCLErrorDomain = @"BCLErrorDomain";

NSString * const BCLDetailedErrorsKey = @"BCLDetailedErrorsKey";



@interface BCLContinuations ()

@end



@implementation BCLContinuations

#pragma mark - Non-blocking
+(void)untilEndWithContinuations:(NSArray *)continuations completionHandler:(void(^)(BOOL didSucceed, NSError *error))completionHandler
{
    [BCLContinuations untilEndWithContinuations:continuations errors:@[] completionHandler:completionHandler];
}



+(void)untilEndWithContinuations:(NSArray *)continuations errors:(NSArray *)errors completionHandler:(void (^)(BOOL didSucceed, NSError *error))completionHandler
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
        [BCLContinuations untilEndWithContinuations:remainingContinuations errors:nextErrors completionHandler:completionHandler];
    }];
}



+(void)untilErrorWithContinuations:(NSArray *)continuations completionHandler:(void (^)(BOOL didSucceed, NSError *error))completionHandler
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
        [BCLContinuations untilErrorWithContinuations:remainingContinuations completionHandler:completionHandler];
    }];
}



#pragma mark - Blocking
+(NSError *)untilEndWithContinuations:(NSArray *)continuations
{
    __block NSError *returnError = nil;

    [self untilEndWithContinuations:continuations errors:@[] completionHandler:^(BOOL didSucceed, NSError *error) {
        returnError = (didSucceed) ? nil : error;
    }];

    return returnError;
}



+(NSError *)untilErrorWithContinuations:(NSArray *)continuations
{
    __block NSError *returnError = nil;

    [self untilErrorWithContinuations:continuations completionHandler:^(BOOL didSucceed, NSError *error) {
        returnError = (didSucceed) ? nil : error;
    }];

    return returnError;
}



+(NSError *)untilEnd:(id<BCLContinuation>)firstContinuation, ...
{
    NSArray *continuations = BCJ_CONTINUATIONS_ARRAY_FROM_VARGS(firstContinuation);
    __block NSError *returnError = nil;

    [self untilEndWithContinuations:continuations errors:@[] completionHandler:^(BOOL didSucceed, NSError *error) {
        returnError = (didSucceed) ? nil : error;
    }];

    return returnError;
}



+(NSError *)untilError:(id<BCLContinuation>)firstContinuation, ...
{
    NSArray *continuations = BCJ_CONTINUATIONS_ARRAY_FROM_VARGS(firstContinuation);
    __block NSError *returnError = nil;

    [self untilErrorWithContinuations:continuations completionHandler:^(BOOL didSucceed, NSError *error) {
        returnError = (didSucceed) ? nil : error;
    }];

    return returnError;
}

@end
