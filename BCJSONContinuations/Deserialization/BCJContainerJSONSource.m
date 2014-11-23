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



#pragma mark - Constructors
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> objectContainer, NSString *JSONPath, Class expectClass, BCJJSONSourceOptions options, id defaultValue) {
    return [[BCJContainerJSONSource alloc] initWithObject:objectContainer JSONPath:JSONPath expectedClass:expectClass options:options defaultValue:defaultValue];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> objectContainer, NSString *JSONPath, BCJJSONSourceOptions options, id defaultValue) {
    return [[BCJContainerJSONSource alloc] initWithObject:objectContainer JSONPath:JSONPath expectedClass:nil options:options defaultValue:nil];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> objectContainer, NSString *JSONPath, BCJJSONSourceOptions options) {
    return [[BCJContainerJSONSource alloc] initWithObject:objectContainer JSONPath:JSONPath expectedClass:nil options:BCJJSONSourceModeOptional defaultValue:nil];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> objectContainer, NSString *JSONPath) {
    return [[BCJContainerJSONSource alloc] initWithObject:objectContainer JSONPath:JSONPath expectedClass:nil options:BCJJSONSourceModeOptional defaultValue:nil];
}
