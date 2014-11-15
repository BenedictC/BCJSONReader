//
//  BCLBlockContinuation.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 27/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLContinuations.h"



/**
 BCLBlockContinuation conforms to BCLContinuation and is used to create simple continuations.
 */
@interface BCLBlockContinuation : NSObject <BCLContinuation>
/**
 Intialize an instance using the supplied block.

 @param block the contination block.

 @return An initalized continuation.
 */
-(instancetype)initWithBlock:(BOOL(^)(NSError **outError))block;
@property(nonatomic, readonly, copy) BOOL(^block)(NSError **outError);

@end



id<BCLContinuation> BCLContinuationWithBlock(BOOL(^block)(NSError **outError)) __attribute__((warn_unused_result));
