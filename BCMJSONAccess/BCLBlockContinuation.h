//
//  BCLBlockContinuation.h
//  BCMJSONAccess
//
//  Created by Benedict Cohen on 27/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLContinuation.h"



id<BCLContinuation> BCLContinuationWithBlock(BOOL(^block)(NSError **outError));



@interface BCLBlockContinuation : NSObject <BCLContinuation>

-(instancetype)initWithBlock:(BOOL(^)(NSError **outError))block;
@property(nonatomic, readonly, copy) BOOL(^block)(NSError **outError);

@end
