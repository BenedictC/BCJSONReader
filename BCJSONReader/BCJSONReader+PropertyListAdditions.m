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
+(NSError *)readPropertyListData:(NSData *)propertyListData defaultOptions:(BCJSONReaderOptions)defaultOptions usingBlock:(void(^)(BCJSONReader *reader))block
{
    if (propertyListData == nil) {
        return [BCJError invalidSourceDataErrorWithData:nil expectedDataFormatName:@"Property List" underlyingError:nil];
    }

    NSPropertyListReadOptions options = NSPropertyListImmutable;
    NSError *error;
    id sourceObject = [NSPropertyListSerialization propertyListWithData:propertyListData options:options format:NULL error:&error];

    BOOL didDeserialize = (sourceObject != nil);
    if (!didDeserialize) {
        return [BCJError invalidSourceDataErrorWithData:nil expectedDataFormatName:@"Property List" underlyingError:error];
    }

    return [self readObject:sourceObject defaultOptions:defaultOptions usingBlock:block];
}



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
