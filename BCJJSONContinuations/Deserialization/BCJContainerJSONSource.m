//
//  BCJContainerJSONSource.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 21/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJContainerJSONSource.h"
#import "BCJJSONSource.h"



@interface BCJContainerJSONSource : BCJJSONSource
@end



@implementation  BCJContainerJSONSource

-(id)object
{
    return [super.object containedObject];
}

@end



#pragma mark - Strict Constructors
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> objectContainer, NSString *JSONPath, Class expectClass, BCJJSONSourceOptions options, id defaultValue) {
    return [[BCJContainerJSONSource alloc] initWithObject:objectContainer JSONPath:JSONPath expectedClass:expectClass options:options defaultValue:defaultValue];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> objectContainer, NSUInteger idx, Class expectClass, BCJJSONSourceOptions options, id defaultValue) {
    NSString *JSONPath = [NSString stringWithFormat:@"%lu", [@(idx) unsignedLongValue]];
    return [[BCJContainerJSONSource alloc] initWithObject:objectContainer JSONPath:JSONPath expectedClass:expectClass options:options defaultValue:defaultValue];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> objectContainer, NSString *JSONPath, Class expectClass, BCJJSONSourceOptions options) {
    return [[BCJContainerJSONSource alloc] initWithObject:objectContainer JSONPath:JSONPath expectedClass:expectClass options:options defaultValue:nil];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> objectContainer, NSUInteger idx, Class expectClass, BCJJSONSourceOptions options) {
    NSString *JSONPath = [NSString stringWithFormat:@"%lu", [@(idx) unsignedLongValue]];
    return [[BCJContainerJSONSource alloc] initWithObject:objectContainer JSONPath:JSONPath expectedClass:expectClass options:options defaultValue:nil];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> objectContainer, NSString *JSONPath, Class expectClass) {
    return [[BCJContainerJSONSource alloc] initWithObject:objectContainer JSONPath:JSONPath expectedClass:expectClass options:BCJJSONSourceModeOptional defaultValue:nil];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> objectContainer, NSUInteger idx, Class expectClass) {
    NSString *JSONPath = [NSString stringWithFormat:@"%lu", [@(idx) unsignedLongValue]];
    return [[BCJContainerJSONSource alloc] initWithObject:objectContainer JSONPath:JSONPath expectedClass:expectClass options:BCJJSONSourceModeOptional defaultValue:nil];
}



#pragma mark - Constructors with nil expectClass
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> objectContainer, NSString *JSONPath, BCJJSONSourceOptions options, id defaultValue) {
    return [[BCJContainerJSONSource alloc] initWithObject:objectContainer JSONPath:JSONPath expectedClass:nil options:options defaultValue:nil];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> objectContainer, NSUInteger idx, BCJJSONSourceOptions options, id defaultValue) {
    NSString *JSONPath = [NSString stringWithFormat:@"%lu", [@(idx) unsignedLongValue]];
    return [[BCJContainerJSONSource alloc] initWithObject:objectContainer JSONPath:JSONPath expectedClass:nil options:options defaultValue:defaultValue];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> objectContainer, NSString *JSONPath, BCJJSONSourceOptions options) {
    return [[BCJContainerJSONSource alloc] initWithObject:objectContainer JSONPath:JSONPath expectedClass:nil options:BCJJSONSourceModeOptional defaultValue:nil];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> objectContainer, NSUInteger idx, BCJJSONSourceOptions options) {
    NSString *JSONPath = [NSString stringWithFormat:@"%lu", [@(idx) unsignedLongValue]];
    return [[BCJContainerJSONSource alloc] initWithObject:objectContainer JSONPath:JSONPath expectedClass:nil options:options defaultValue:nil];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> objectContainer, NSString *JSONPath) {
    return [[BCJContainerJSONSource alloc] initWithObject:objectContainer JSONPath:JSONPath expectedClass:nil options:BCJJSONSourceModeOptional defaultValue:nil];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> objectContainer, NSUInteger idx) {
    NSString *JSONPath = [NSString stringWithFormat:@"%lu", [@(idx) unsignedLongValue]];
    return [[BCJContainerJSONSource alloc] initWithObject:objectContainer JSONPath:JSONPath expectedClass:nil options:BCJJSONSourceModeOptional defaultValue:nil];
}
