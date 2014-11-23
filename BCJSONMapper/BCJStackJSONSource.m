//
//  BCJStackJSONSource.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 21/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJStackJSONSource.h"

#import "BCJJSONSource.h"



#pragma mark - Source pushing/popping
static inline NSMutableArray *BCJJSONSourceStack() {
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
    [BCJJSONSourceStack() addObject:sourceObject];
}



id BCJTopSourceObject() {
    return [BCJJSONSourceStack() lastObject];
}



void BCJPopSourceObject() {
    return [BCJJSONSourceStack() removeLastObject];
}





#pragma mark - BCJStackJSONSource
@interface BCJStackJSONSource : BCJJSONSource
@end



@implementation BCJStackJSONSource

- (instancetype)initWithJSONPath:(NSString *)JSONPath expectedClass:(Class)expectedClass options:(BCJJSONSourceOptions)options defaultValue:(id)defaultValue
{
    id placeHolder = @"";
    return [super initWithObject:placeHolder JSONPath:JSONPath expectedClass:expectedClass options:options defaultValue:defaultValue];
}



- (id)object
{
    return BCJTopSourceObject();
}

@end





#pragma mark - BCJJSONSource convience constructors for sources that implictly use the current source objects
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(NSString *JSONPath, Class expectClass, BCJJSONSourceOptions options, id defaultValue) {
    return [[BCJStackJSONSource alloc] initWithJSONPath:JSONPath expectedClass:expectClass options:options defaultValue:defaultValue];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(NSString *JSONPath, BCJJSONSourceOptions options, id defaultValue) {
    return [[BCJStackJSONSource alloc] initWithJSONPath:JSONPath expectedClass:nil options:options defaultValue:defaultValue];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(NSString *JSONPath, BCJJSONSourceOptions options) {
    return [[BCJStackJSONSource alloc] initWithJSONPath:JSONPath expectedClass:nil options:options defaultValue:nil];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(NSString *JSONPath) {
    return [[BCJStackJSONSource alloc] initWithJSONPath:JSONPath expectedClass:nil options:0 defaultValue:nil];
}
