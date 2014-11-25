//
//  BCLContinuationsClass.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 27/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCLContinuationProtocol.h"



/**
 The error domain for BCLContinuations.
 */
extern NSString * const BCLErrorDomain;
/**
 The corosponding value is an NSArray of errors generated while executing continuations with untilEnd:.
 */
extern NSString * const BCLDetailedErrorsKey;


enum : NSInteger {
    /**
     Error code to denote that multiple errors occured while executing the continuations.
     */
    BCLMultipleErrorsError,
    /**
     Error code to denote that an unknown error occured while executing the continuations.
     */
    BCLUnknownError,
};


/**
 BCLContinuations provides methods for executing continuations.
 */
@interface BCLContinuations : NSObject

/**
 Synchronous execution the supplied continuations. If one or more errors occurs then the returned error will be an NSError with code BCLMultipleErrorsError.

 @param firstContinuation a nil terminated list of id<BCLContinuation> objects.

 @return On success nil, otherwise and NSError.
 */
+(NSError *)untilEnd:(id<BCLContinuation>)firstContinuation, ... NS_REQUIRES_NIL_TERMINATION;
/**
 Synchronous execution the supplied continuations. If an error occurs then the continutions are abort and the error returned.

 @param firstContinuation a nil terminated list of id<BCLContinuation> objects.

 @return On success nil, otherwise an NSError.
 */
+(NSError *)untilError:(id<BCLContinuation>)firstContinuation, ... NS_REQUIRES_NIL_TERMINATION;



+(NSError *)untilEndWithContinuations:(NSArray *)continuations;

+(NSError *)untilErrorWithContinuations:(NSArray *)continuations;



//execution so that the invoking thread is not blocked.
+(void)untilEndWithContinuations:(NSArray *)continuations completionHandler:(void(^)(BOOL didSucceed, NSError *error))completionHandler;

+(void)untilErrorWithContinuations:(NSArray *)continuations completionHandler:(void(^)(BOOL didSucceed, NSError *error))completionHandler;

@end
