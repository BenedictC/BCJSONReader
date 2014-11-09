//
//  BCLBlockContinuation.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 27/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLContinuation.h"



id<BCLContinuation> BCLContinuationWithBlock(BOOL(^block)(NSError **outError)) __attribute__((warn_unused_result));



@interface BCLBlockContinuation : NSObject <BCLContinuation>

-(instancetype)initWithBlock:(BOOL(^)(NSError **outError))block;
@property(nonatomic, readonly, copy) BOOL(^block)(NSError **outError);

@end
