//
//  BCLBlockContinuation.m
//  BCMJSONAccess
//
//  Created by Benedict Cohen on 27/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLBlockContinuation.h"



id<BCLContinuation> BCLContinuationWithBlock(BOOL(^block)(NSError **)) {

    return [[BCLBlockContinuation alloc] initWithBlock:block];
}



@implementation BCLBlockContinuation

-(instancetype)initWithBlock:(BOOL(^)(NSError **))block
{
    self = [super init];
    if (self == nil) return nil;

    _block = block;

    return nil;
}



-(BOOL)executeAndReturnError:(NSError **)error
{
    return self.block(error);
}

@end
