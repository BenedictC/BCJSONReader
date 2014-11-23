//
//  BCJStackPropertyTarget.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 21/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJStackPropertyTarget.h"
#import "BCJPropertyTarget.h"



@interface BCJStackPropertyTarget : BCJPropertyTarget
@end



@implementation BCJStackPropertyTarget

-(instancetype)initWithKey:(NSString *)key
{
    id tempTarget = @{};
    return [super initWithObject:tempTarget key:key];
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
    NSCParameterAssert(targetObject != nil);
    [BCJTargetStack() addObject:targetObject];
}



id BCJTopTargetObject() {
    return [BCJTargetStack() lastObject];
}



void BCJPopTargetObject() {
    return [BCJTargetStack() removeLastObject];
}



BCJPropertyTarget * BCJ_OVERLOADABLE BCJTarget(NSString *key) {
    return [[BCJStackPropertyTarget alloc] initWithKey:key];
}
