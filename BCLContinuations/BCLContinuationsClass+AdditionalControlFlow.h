//
//  BCLContinuationsClass+AdditionalControlFlow.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 30/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLContinuations.h"


#pragma mark - helper macros
#define BCJ_CONTINUATIONS_ARRAY_FROM_VARGS(FIRST_CONTINUATION) ({ \
va_list args; \
va_start(args, FIRST_CONTINUATION); \
\
NSMutableArray *__continuations__ = [NSMutableArray new]; \
id<BCLContinuation> __currentContination__ = FIRST_CONTINUATION; \
\
while (__currentContination__ != nil) { \
    [__continuations__ addObject:__currentContination__]; \
    __currentContination__ = va_arg(args, id<BCLContinuation>); \
} \
va_end(args); \
__continuations__; \
})



@interface BCLContinuations (AdditionalControlFlow)

+(void)continueUntilEnd:(NSArray *)continuations errors:(NSArray *)errors completionHandler:(void (^)(BOOL didSucceed, NSError *error))completionHandler;

+(void)continueUntilError:(NSArray *)continuations completionHandler:(void (^)(BOOL didSucceed, NSError *error))completionHandler;

+(NSError *)untilEndWithContinuations:(NSArray *)continuations;

+(NSError *)untilErrorWithContinuations:(NSArray *)continuations;

@end
