//
//  BCJContainerSource.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 21/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJContainerSource.h"
#import "BCJSource.h"



@interface BCJContainerSource : BCJSource
@end



@implementation  BCJContainerSource

-(id)object
{
    return [super.object containedObject];
}

@end



#pragma mark - Constructors
BCJSource * BCJ_OVERLOADABLE BCJCreateSource(id<BCJContainer> objectContainer, NSString *JSONPath, Class expectClass, BCJSourceOptions options, id defaultValue) {
    return [[BCJContainerSource alloc] initWithObject:objectContainer JSONPath:JSONPath expectedClass:expectClass options:options defaultValue:defaultValue];
}



BCJSource * BCJ_OVERLOADABLE BCJCreateSource(id<BCJContainer> objectContainer, NSString *JSONPath, BCJSourceOptions options, id defaultValue) {
    return [[BCJContainerSource alloc] initWithObject:objectContainer JSONPath:JSONPath expectedClass:nil options:options defaultValue:nil];
}



BCJSource * BCJ_OVERLOADABLE BCJCreateSource(id<BCJContainer> objectContainer, NSString *JSONPath, BCJSourceOptions options) {
    return [[BCJContainerSource alloc] initWithObject:objectContainer JSONPath:JSONPath expectedClass:nil options:BCJSourceModeOptional defaultValue:nil];
}



BCJSource * BCJ_OVERLOADABLE BCJCreateSource(id<BCJContainer> objectContainer, NSString *JSONPath) {
    return [[BCJContainerSource alloc] initWithObject:objectContainer JSONPath:JSONPath expectedClass:nil options:BCJSourceModeOptional defaultValue:nil];
}
