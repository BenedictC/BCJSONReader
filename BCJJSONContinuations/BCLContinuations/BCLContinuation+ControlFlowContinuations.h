//
//  BCLContinuation+ControlFlowContinuations.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 30/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLContinuationProtocol.h"



id<BCLContinuation> BCLUntilEnd(id<BCLContinuation> firstContinuations, ...) NS_REQUIRES_NIL_TERMINATION;
id<BCLContinuation> BCLUntilError(id<BCLContinuation> firstContinuations, ...) NS_REQUIRES_NIL_TERMINATION;
