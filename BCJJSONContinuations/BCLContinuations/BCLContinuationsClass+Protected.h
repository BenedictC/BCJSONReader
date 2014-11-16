//
//  BCLContinuationsClass+Protected.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 30/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLContinuations.h"



@interface BCLContinuations (Protected)
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
