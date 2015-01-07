//
//  BCJReader+AdditionalTypes.m
//  BCJSONReader
//
//  Created by Benedict Cohen on 05/01/2015.
//  Copyright (c) 2015 Benedict Cohen. All rights reserved.
//

#import "BCJSONReader.h"
#import "BCJError.h"



@implementation BCJSONReader (AdditionalTypes)

-(NSDate *)dateFromTimeIntervalSince1970At:(NSString *)jsonPath
{
    return [self dateFromTimeIntervalSince1970At:jsonPath options:self.defaultOptions defaultValue:nil didSucceed:NULL];
}



-(NSDate *)dateFromTimeIntervalSince1970At:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(NSDate *)defaultValue didSucceed:(BOOL *)didSucceed
{
    NSNumber *timestamp = [self numberAt:jsonPath options:options defaultValue:@(defaultValue.timeIntervalSince1970) didSucceed:didSucceed];
    return (timestamp == nil) ? nil : [NSDate dateWithTimeIntervalSince1970:timestamp.integerValue];
}



-(NSDate *)dateFromISO8601StringAt:(NSString *)jsonPath
{
    return [self dateFromTimeIntervalSince1970At:jsonPath options:self.defaultOptions defaultValue:nil didSucceed:NULL];
}



-(NSDate *)dateFromISO8601StringAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(NSDate *)defaultValue didSucceed:(BOOL *)didSucceed
{
    //We don't want to create an string from the date because that may be lossy. Instead we use a sentinal and substitute it if needed.
    //However we have to be careful not to mistake the sentinal for a fetched value (unlikely but possible). We do this by using a mutable string (to avoiding uniquing) and use pointer comparison.
    NSMutableString *sentinal = [@"SENTINAL" mutableCopy];
    NSString *defaultString = (defaultValue == nil) ? nil : sentinal;

    NSString *dateString = [self stringAt:jsonPath options:options defaultValue:defaultString didSucceed:didSucceed];

    //If we don't have a value then the getter was happy with a nil value so we don't need to create a date.
    if (dateString == nil) return nil;

    //Did the getter return our sentinal?
    BOOL shouldUseDefault = (dateString == sentinal); //See comment above declaration of 'sentinal'.
    if (shouldUseDefault) return defaultValue;

    //Attempt to create a string from the fetched string
    NSDate *possibleDate = ({
        static NSDateFormatter *formatter = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            formatter = [NSDateFormatter new];
            formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
            formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
        });

        [formatter dateFromString:dateString];
    });

    BOOL didFailToCreateDate = (possibleDate == nil);
    if (didFailToCreateDate) {
        NSString *criteria = [NSString stringWithFormat:@"is a valid ISO 8601 date"];
        NSError *error = [BCJError invalidValueErrorWithJSONPath:jsonPath value:possibleDate criteria:criteria];
        [self addError:error];
        if (didSucceed != NULL) *didSucceed = NO;
        return nil;
    }

    return possibleDate;
}



-(NSURL *)URLAt:(NSString *)jsonPath
{
    return [self URLAt:jsonPath options:self.defaultOptions defaultValue:nil didSucceed:NULL];
}



-(NSURL *)URLAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(NSURL *)defaultValue didSucceed:(BOOL *)didSucceed
{
    NSString *urlString = [self stringAt:jsonPath options:options defaultValue:defaultValue.absoluteString didSucceed:didSucceed];
    if (urlString == nil) return nil;

    NSURL *url = [NSURL URLWithString:urlString];
    if (url == nil) {
        NSError *error = [BCJError invalidValueErrorWithJSONPath:jsonPath value:urlString criteria:@"valid URL"];
        [self addError:error];
        if (didSucceed != NULL) *didSucceed = NO;
        return nil;
    }

    return url;
}

@end
