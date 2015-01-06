//
//  BCJReader+StandardTypes.m
//  BCJSONReader
//
//  Created by Benedict Cohen on 05/01/2015.
//  Copyright (c) 2015 Benedict Cohen. All rights reserved.
//

#import "BCJSONReader.h"



@implementation BCJSONReader (StandardTypes)

-(NSString *)stringAt:(NSString *)jsonPath
{
    return [self objectAt:jsonPath type:NSString.class options:self.defaultOptions defaultValue:nil didSucceed:NULL];
}



-(NSString *)stringAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(NSString *)defaultValue didSucceed:(BOOL *)didSucceed
{
    return [self objectAt:jsonPath type:NSString.class options:options defaultValue:defaultValue didSucceed:didSucceed];
}



-(NSNull *)nullAt:(NSString *)jsonPath
{
    return [self objectAt:jsonPath type:NSNull.class options:self.defaultOptions defaultValue:nil didSucceed:NULL];
}



-(NSNull *)nullAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options didSucceed:(BOOL *)didSucceed
{
    return [self objectAt:jsonPath type:NSNull.class options:options defaultValue:nil didSucceed:didSucceed];
}



-(NSArray *)arrayAt:(NSString *)jsonPath
{
    return [self objectAt:jsonPath type:NSArray.class options:self.defaultOptions defaultValue:nil didSucceed:NULL];
}



-(NSArray *)arrayAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(NSArray *)defaultValue didSucceed:(BOOL *)didSucceed
{
    return [self objectAt:jsonPath type:NSArray.class options:options defaultValue:defaultValue didSucceed:didSucceed];
}



-(NSDictionary *)dictionaryAt:(NSString *)jsonPath
{
    return [self objectAt:jsonPath type:NSDictionary.class options:self.defaultOptions defaultValue:nil didSucceed:NULL];
}



-(NSDictionary *)dictionaryAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(NSDictionary *)defaultValue didSucceed:(BOOL *)didSucceed
{
    return [self objectAt:jsonPath type:NSDictionary.class options:options defaultValue:defaultValue didSucceed:didSucceed];
}



-(NSNumber *)numberAt:(NSString *)jsonPath
{
    return [self objectAt:jsonPath type:NSNumber.class options:self.defaultOptions defaultValue:nil didSucceed:NULL];
}



-(NSNumber *)numberAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(NSNumber *)defaultValue didSucceed:(BOOL *)didSucceed
{
    return [self objectAt:jsonPath type:NSNumber.class options:options defaultValue:defaultValue didSucceed:didSucceed];
}



-(BOOL)boolAt:(NSString *)jsonPath
{
    return [[self objectAt:jsonPath type:NSNumber.class options:self.defaultOptions defaultValue:nil didSucceed:NULL] boolValue];
}



-(BOOL)boolAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(BOOL)defaultValue didSucceed:(BOOL *)didSucceed
{
    return [[self objectAt:jsonPath type:NSNumber.class options:options defaultValue:@(defaultValue) didSucceed:didSucceed] boolValue];
}



-(int64_t)integerAt:(NSString *)jsonPath
{
    return [[self objectAt:jsonPath type:NSNumber.class options:self.defaultOptions defaultValue:nil didSucceed:NULL] longLongValue];
}



-(int64_t)integerAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(int64_t)defaultValue didSucceed:(BOOL *)didSucceed
{
    return [[self objectAt:jsonPath type:NSNumber.class options:options defaultValue:@(defaultValue) didSucceed:didSucceed] longLongValue];
}



-(double)doubleAt:(NSString *)jsonPath
{
    return [[self objectAt:jsonPath type:NSNumber.class options:self.defaultOptions defaultValue:nil didSucceed:NULL] doubleValue];
}



-(double)doubleAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(double)defaultValue didSucceed:(BOOL *)didSucceed
{
    return [[self objectAt:jsonPath type:NSNumber.class options:options defaultValue:@(defaultValue) didSucceed:didSucceed] doubleValue];
}

@end
