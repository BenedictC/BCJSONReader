//
//  BCLControlFlowContinuations.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 30/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLContinuationProtocol.h"



/**
 <#Description#>

 @param firstContinuations <#firstContinuations description#>
 @param ...                <#... description#>

 @return <#return value description#>
 */
id<BCLContinuation> BCLUntilEnd(id<BCLContinuation> firstContinuations, ...) NS_REQUIRES_NIL_TERMINATION __attribute__((warn_unused_result));
id<BCLContinuation> BCLUntilError(id<BCLContinuation> firstContinuations, ...) NS_REQUIRES_NIL_TERMINATION __attribute__((warn_unused_result));
