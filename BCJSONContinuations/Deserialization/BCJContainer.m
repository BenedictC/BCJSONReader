//
//  BCJContainer.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 30/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJContainer.h"

#import "BCJSource.h"



@implementation BCJContainer

#pragma mark - instance life cycle
-(instancetype)initWithContent:(id)content
{
    NSParameterAssert(content);
    if (self == nil) return nil;

    _content = content;

    return self;
}



#pragma mark - properties
-(void)setContentAndSeal:(id)content
{
    NSParameterAssert(content);
    NSAssert(_content == nil, @"Attempting to set content after container has been sealed.");
    _content = content;
}



-(BOOL)isSealed
{
    return _content != nil;
}



#pragma mark - BCJContainerProtocol
-(id)containedObject
{
    return _content;
}

@end
