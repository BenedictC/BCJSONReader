//
//  BCLNonBlockingBlockContinuation.h
//  BCJSONMapper
//
//  Created by Benedict Cohen on 25/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLContinuationProtocol.h"


/**
 <#Description#>

 @param BOOL    <#BOOL description#>
 @param NSError <#NSError description#>
 */
typedef void(^BCLFinishContinuation)(BOOL, NSError *);


/**
 BCLNonBlockingBlockContinuation conforms to BCLContinuation and is used to create asynchronous continuations.
 */
@interface BCLNonBlockingBlockContinuation : NSObject <BCLContinuation>
/**
 Intialize an instance using the supplied block.

 @param block the contination block.

 @return An initalized continuation.
 */

-(instancetype)initWithBlock:(void(^)(BCLFinishContinuation))block;

@property(nonatomic, readonly, copy) void(^block)(BCLFinishContinuation);

@end



id<BCLContinuation> BCLNonBlockingContinuationWithBlock(void(^continueBlock)(BCLFinishContinuation)) __attribute__((warn_unused_result));
