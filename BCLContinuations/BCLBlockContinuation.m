//
//  BCLBlockContinuation.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 27/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLBlockContinuation.h"



@implementation BCLBlockContinuation

-(instancetype)init
{
    return [self initWithBlock:NULL];
}



-(instancetype)initWithBlock:(BOOL(^)(NSError **outError))block
{
    NSCParameterAssert(block != NULL);
    
    self = [super init];
    if (self == nil) return nil;

    _block = block;

    return self;
}



-(void)executeWithCompletionHandler:(void(^)(BOOL didSucceed, NSError *error))completionHandler
{
    NSError *error = nil;
    BOOL didSucceed = self.block(&error);

    completionHandler(didSucceed, error);
}

@end





id<BCLContinuation> BCLContinuationWithBlock(BOOL(^block)(NSError **outError)) {

    return [[BCLBlockContinuation alloc] initWithBlock:block];
}


