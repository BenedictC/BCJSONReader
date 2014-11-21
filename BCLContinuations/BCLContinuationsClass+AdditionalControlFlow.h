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
/**
 Synchronous execution the supplied continuations. If one or more errors occurs then the returned error will be an NSError with code BCLMultipleErrorsError.

 @param continuations an NSArray of id<BCLContinuation> objects.

 @return On success nil, otherwise and NSError.
 */
+(NSError *)untilEndWithContinuations:(NSArray *)continuations;
/**
 Synchronous execution the supplied continuations. If an error occurs then the continutions are abort and the error returned.

 @param continuations an NSArray of id<BCLContinuation> objects.

 @return On success nil, otherwise and NSError.
 */
+(NSError *)untilErrorWithContinuations:(NSArray *)continuations;

@end
