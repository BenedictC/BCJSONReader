//
//  BCJReader+PropertyListAdditions.m
//  BCJSONReader
//
//  Created by Benedict Cohen on 07/01/2015.
//  Copyright (c) 2015 Benedict Cohen. All rights reserved.
//

#import "BCJSONReader.h"
#import "BCJError.h"



@implementation BCJSONReader (PropertyListAdditions)

-(NSData *)dataAt:(NSString *)jsonPath
{
    return [self objectAt:jsonPath type:NSData.class options:self.defaultOptions defaultValue:nil didSucceed:NULL];
}



-(NSData *)dataAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(NSData *)defaultValue didSucceed:(BOOL *)didSucceed
{
    return [self objectAt:jsonPath type:NSData.class options:options defaultValue:defaultValue didSucceed:didSucceed];
}



-(NSDate *)dateAt:(NSString *)jsonPath
{
    return [self objectAt:jsonPath type:NSDate.class options:self.defaultOptions defaultValue:nil didSucceed:NULL];
}



-(NSDate *)dateAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(NSDate *)defaultValue didSucceed:(BOOL *)didSucceed
{
    return [self objectAt:jsonPath type:NSDate.class options:options defaultValue:defaultValue didSucceed:didSucceed];
}

@end
