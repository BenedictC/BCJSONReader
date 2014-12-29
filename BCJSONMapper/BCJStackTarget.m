//
//  BCJStackTarget.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 21/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJStackTarget.h"
#import "BCJTarget.h"
#import "BCJError.h"



@interface BCJStackTarget : BCJKeyPathTarget
@end



@implementation BCJStackTarget

-(instancetype)initWithKeyPath:(NSString *)keyPath
{
    id tempTarget = @{};
    return [super initWithObject:tempTarget keyPath:keyPath];
}



-(id)object
{
    return BCJTopTargetObject();
}

@end



#pragma mark - Target pushing/popping
static inline NSMutableArray *BCJTargetStack() {
    static NSString *const key = @"propertyMappingTargetObjectStack";

    NSMutableArray *stack = [NSThread currentThread].threadDictionary[key];
    if (stack == nil) {
        stack = [NSMutableArray new];
        [NSThread currentThread].threadDictionary[key] = stack;
    }
    return stack;
}



void BCJPushTargetObject(id targetObject) {
    BCJParameterExpectation(targetObject != nil);
    [BCJTargetStack() addObject:targetObject];
}



id BCJTopTargetObject() {
    return [BCJTargetStack() lastObject];
}



void BCJPopTargetObject() {
    return [BCJTargetStack() removeLastObject];
}



BCJTarget * BCJ_OVERLOADABLE BCJCreateTarget(NSString *keyPath) {
    return [[BCJStackTarget alloc] initWithKeyPath:keyPath];
}
