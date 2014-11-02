//
//  BCJContainer.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 30/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJContainer.h"



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



#pragma mark - BCJKeyedContainer
-(id)objectForKey:(id)key
{
    return ([_content respondsToSelector:@selector(objectForKey:)]) ? [_content objectForKey:key] : nil;
}



#pragma mark - BCJIndexedContainer
-(id)objectAtIndex:(NSUInteger)idx
{
    return ([_content respondsToSelector:@selector(objectAtIndex:)]) ? [_content objectAtIndex:idx] : nil;
}



-(NSUInteger)count
{
    return ([_content respondsToSelector:@selector(count)]) ? [_content count] : 0;
}

@end
