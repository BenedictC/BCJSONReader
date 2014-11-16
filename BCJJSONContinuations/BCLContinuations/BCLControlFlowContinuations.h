//
//  BCLControlFlowContinuations.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 30/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLContinuationProtocol.h"



/**
 Creates a continuation that in turn executes the continuations supplied to it using BCLContinuations untilEnd: method.

 @param firstContinuations A nil terminated list of id<BCLContinuation> objects.

 @return a continuation.
 */
id<BCLContinuation> BCLUntilEnd(id<BCLContinuation> firstContinuations, ...) NS_REQUIRES_NIL_TERMINATION __attribute__((warn_unused_result));
/**
 Creates a continuation that in turn executes the continuations supplied to it using BCLContinuations untilError: method.

 @param firstContinuations A nil terminated list of id<BCLContinuation> objects.

 @return a continuation.
 */
id<BCLContinuation> BCLUntilError(id<BCLContinuation> firstContinuations, ...) NS_REQUIRES_NIL_TERMINATION __attribute__((warn_unused_result));
