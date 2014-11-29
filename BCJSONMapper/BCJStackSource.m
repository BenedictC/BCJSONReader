//
//  BCJStackSource.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 21/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJStackSource.h"

#import "BCJSource.h"



#pragma mark - Source pushing/popping
static inline NSMutableArray *BCJSourceStack() {
    static NSString *const key = @"propertyMappingSourceObjectStack";

    NSMutableArray *stack = [NSThread currentThread].threadDictionary[key];
    if (stack == nil) {
        stack = [NSMutableArray new];
        [NSThread currentThread].threadDictionary[key] = stack;
    }
    return stack;
}



void BCJPushSourceObject(id sourceObject) {
    NSCParameterAssert(sourceObject != nil);
    [BCJSourceStack() addObject:sourceObject];
}



id BCJTopSourceObject() {
    return [BCJSourceStack() lastObject];
}



void BCJPopSourceObject() {
    return [BCJSourceStack() removeLastObject];
}





#pragma mark - BCJStackJSONSource
@interface BCJStackSource : BCJSource
@end



@implementation BCJStackSource

- (instancetype)initWithJSONPath:(NSString *)JSONPath expectedClass:(Class)expectedClass options:(BCJSourceOptions)options defaultValue:(id)defaultValue
{
    id placeHolder = @"";
    return [super initWithObject:placeHolder JSONPath:JSONPath expectedClass:expectedClass options:options defaultValue:defaultValue];
}



- (id)object
{
    return BCJTopSourceObject();
}

@end





#pragma mark - BCJSource convience constructors for sources that implictly use the current source objects
BCJSource * BCJ_OVERLOADABLE BCJCreateSource(NSString *JSONPath, Class expectClass, BCJSourceOptions options, id defaultValue) {
    return [[BCJStackSource alloc] initWithJSONPath:JSONPath expectedClass:expectClass options:options defaultValue:defaultValue];
}



BCJSource * BCJ_OVERLOADABLE BCJCreateSource(NSString *JSONPath, BCJSourceOptions options, id defaultValue) {
    return [[BCJStackSource alloc] initWithJSONPath:JSONPath expectedClass:nil options:options defaultValue:defaultValue];
}



BCJSource * BCJ_OVERLOADABLE BCJCreateSource(NSString *JSONPath, BCJSourceOptions options) {
    return [[BCJStackSource alloc] initWithJSONPath:JSONPath expectedClass:nil options:options defaultValue:nil];
}



BCJSource * BCJ_OVERLOADABLE BCJCreateSource(NSString *JSONPath) {
    return [[BCJStackSource alloc] initWithJSONPath:JSONPath expectedClass:nil options:0 defaultValue:nil];
}
