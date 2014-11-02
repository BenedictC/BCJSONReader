//
//  BCJAdditionalTypes.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 31/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJAdditionalTypes.h"
#import "BCJCore.h"



#pragma mark - NSDate epoch functions
BOOL BCJ_OVERLOADABLE BCJGetDateFromTimeIntervalSinceEpoch(id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSDate *defaultValue, NSDate **outDate, NSError **outError) {
    *outDate = nil;
    NSNumber *defaultNumber = (defaultValue == nil) ? nil : @([defaultValue timeIntervalSince1970]);
    NSNumber *timeInterval;
    if (!BCJGetValue(array, idx, NSNumber.class, options, defaultNumber, &timeInterval, outError)) return NO;

    //If we don't have a value then we don't need to create a date
    if (timeInterval == nil) return YES;

    *outDate = [NSDate dateWithTimeIntervalSince1970:[timeInterval integerValue]];
    return YES;
}



BOOL BCJ_OVERLOADABLE BCJGetDateFromTimeIntervalSinceEpoch(id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSDate *defaultValue, NSDate **outDate, NSError **outError) {
    *outDate = nil;
    NSNumber *defaultNumber = (defaultValue == nil) ? nil : @([defaultValue timeIntervalSince1970]);
    NSNumber *timeInterval;
    if (!BCJGetValue(dict, key, NSNumber.class, options, defaultNumber, &timeInterval, outError)) return NO;

    //If we don't have a value then we don't need to create a date
    if (timeInterval == nil) return YES;

    *outDate = [NSDate dateWithTimeIntervalSince1970:[timeInterval integerValue]];
    return YES;
}



#pragma mark - NSDate epoch continuations
//Block result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromTimeIntervalSinceEpoch(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSDate *defaultValue) {
    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        NSDate *date;
        if (!BCJGetDateFromTimeIntervalSinceEpoch(array, idx, options, defaultValue, &date, outError)) return NO;
        return BCJSetValue(target, targetKey, date, outError);
    });
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromTimeIntervalSinceEpoch(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx) {
    return BCJSetDateFromTimeIntervalSinceEpoch(target, targetKey, array, idx, 0, nil);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromTimeIntervalSinceEpoch(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSDate *defaultValue) {
    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        NSDate *date;
        if (!BCJGetDateFromTimeIntervalSinceEpoch(dict, key, options, defaultValue, &date, outError)) return NO;
        return BCJSetValue(target, targetKey, date, outError);
    });
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromTimeIntervalSinceEpoch(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key) {
    return BCJSetDateFromTimeIntervalSinceEpoch(target, targetKey, dict, key, 0, nil);
}



#pragma mark - NSDate ISO8601 functions
static inline NSDate *dateFromISO8601String(NSString *dateString) {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [NSDateFormatter new];
        formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    });

    return [formatter dateFromString:dateString];
}



BOOL BCJ_OVERLOADABLE BCJGetDateFromISO8601String(id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSDate *defaultValue, NSDate **outDate, NSError **outError) {
    *outDate = nil;
    //It would be wasteful to create a string representation of the default value. Instead we use a sentinel which
    //cannot be mistaken for a valid value.
    static NSString * const sentinel = @"SENTINEL";
    NSString *defaultString = (defaultValue == nil) ? nil : sentinel;
    NSString *dateString;
    if (!BCJGetValue(array, idx, NSString.class, options, defaultString, &dateString, outError)) return NO;

    //If we don't have a value then we don't need to create a date
    if (dateString == nil) return YES;

    //Convert the string to a date
    NSDate *date = ([dateString isEqualToString:sentinel]) ? defaultValue : dateFromISO8601String(dateString);
    if (date == nil) {
        if (outError == NULL) *outError = [NSError errorWithDomain:@"TODO: Invalid date string" code:0 userInfo:nil];
        return NO;
    }

    *outDate = date;
    return YES;
}



BOOL BCJ_OVERLOADABLE BCJGetDateFromISO8601String(id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSDate *defaultValue, NSDate **outDate, NSError **outError) {
    *outDate = nil;
    //It would be wasteful to create a string representation of the default value. Instead we use a sentinel which
    //cannot be mistaken for a valid value.
    static NSString * const sentinel = @"SENTINEL";
    NSString *defaultString = (defaultValue == nil) ? nil : sentinel;
    NSString *dateString;
    if (!BCJGetValue(dict, key, NSString.class, options, defaultString, &dateString, outError)) return NO;

    //If we don't have a value then we don't need to create a date
    if (dateString == nil) return YES;

    //Convert the string to a date
    NSDate *date = ([dateString isEqualToString:sentinel]) ? defaultValue : dateFromISO8601String(dateString);
    if (date == nil) {
        if (outError == NULL) *outError = [NSError errorWithDomain:@"TODO: Invalid date string" code:0 userInfo:nil];
        return NO;
    }

    *outDate = date;
    return YES;
}



#pragma mark - NSDate ISO8601 continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromISO8601String(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSDate *defaultValue) {
    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        NSDate *date;
        if (!BCJGetDateFromISO8601String(array, idx, options, defaultValue, &date, outError)) return NO;
        return BCJSetValue(target, targetKey, date, outError);
    });
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromISO8601String(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx) {
    return BCJSetDateFromISO8601String(target, targetKey, array, idx, 0, nil);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromISO8601String(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSDate *defaultValue) {
    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        NSDate *date;
        if (!BCJGetDateFromISO8601String(dict, key, options, defaultValue, &date, outError)) return NO;
        return BCJSetValue(target, targetKey, date, outError);
    });
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromISO8601String(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key) {
    return BCJSetDateFromISO8601String(target, targetKey, dict, key, 0, nil);
}



#pragma mark - Get NSURL functions
BOOL BCJ_OVERLOADABLE BCJGetURL(id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSURL *defaultValue, NSURL **outURL, NSError **outError) {
    *outURL = nil;

    NSString *string;
    if (!BCJGetValue(array, idx, NSString.class, options, defaultValue.absoluteString, &string, outError)) return NO;

    //If BCJGetValue succeed and the value is nil then we don't need to try and create a URL
    if (string == nil) return YES;

    //Attempt to create URL from the string
    NSURL *url = [NSURL URLWithString:string];
    if (url == nil) {
        if (outError != NULL) *outError = [NSError errorWithDomain:@"TODO: Invalid URL" code:0 userInfo:nil];
        return NO;
    }

    *outURL = url;
    return YES;
}



BOOL BCJ_OVERLOADABLE BCJGetURL(id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSURL *defaultValue, NSURL **outURL, NSError **outError) {
    *outURL = nil;

    NSString *string;
    if (!BCJGetValue(dict, key, NSString.class, options, defaultValue.absoluteString, &string, outError)) return NO;

    //If BCJGetValue succeed and the value is nil then we don't need to try and create a URL
    if (string == nil) return YES;

    //Attempt to create URL from the string
    NSURL *url = [NSURL URLWithString:string];
    if (url == nil) {
        if (outError != NULL) *outError = [NSError errorWithDomain:@"TODO: Invalid URL" code:0 userInfo:nil];
        return NO;
    }

    *outURL = url;
    return YES;
}



#pragma mark - Set NSURL continuations
//KVC result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetURL(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSURL *defaultValue) {
    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        NSURL *value;
        if (!BCJGetURL(array, idx, options, defaultValue, &value, outError)) return NO;

        return BCJSetValue(target, targetKey, value, outError);
    });
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetURL(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx) {
    return BCJSetURL(target, targetKey, array, idx, 0, nil);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetURL(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSURL *defaultValue) {
    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        NSURL *value;
        if (!BCJGetURL(dict, key, options, defaultValue, &value, outError)) return NO;

        return BCJSetValue(target, targetKey, value, outError);
    });
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetURL(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key) {
    return BCJSetURL(target, targetKey, dict, key, 0, nil);
}



#pragma mark - Get Enum functions
BOOL BCJ_OVERLOADABLE BCJGetEnum(id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, id defaultValue, NSDictionary *enumMapping, id *outValue, NSError **outError) {
    *outValue = nil;
    //Get the value
    NSString *enumString;
    if (!BCJGetValue(array, idx, NSString.class, options, defaultValue, &enumString, outError)) return NO;

    //Look up the value in the mapping
    id value = [enumMapping objectForKey:enumString];
    if (value == nil) {
        if (outError != NULL) *outError = [NSError errorWithDomain:@"TODO: value not found in mapping" code:0 userInfo:nil];
        return NO;
    }

    *outValue = value;
    return YES;
}



BOOL BCJ_OVERLOADABLE BCJGetEnum(id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, id defaultValue, NSDictionary *enumMapping, id *outValue, NSError **outError) {
    *outValue = nil;
    //Get the value
    NSString *enumString;
    if (!BCJGetValue(dict, key, NSString.class, options, defaultValue, &enumString, outError)) return NO;

    //Look up the value in the mapping
    id value = [enumMapping objectForKey:enumString];
    if (value == nil) {
        if (outError != NULL) *outError = [NSError errorWithDomain:@"TODO: value not found in mapping" code:0 userInfo:nil];
        return NO;
    }

    *outValue = value;
    return YES;
}



#pragma mark - Set Enum continuations
//KVC style
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetEnum(id target, NSString *targetKey, id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, id defaultValue, NSDictionary *enumMapping) {
    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        id value;
        if (BCJGetEnum(array, idx, options, defaultValue, enumMapping, &value, outError)) return NO;

        //Success
        return BCJSetValue(target, targetKey, value, outError);
    });
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetEnum(id target, NSString *targetKey, id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, id defaultValue, NSDictionary *enumMapping) {
    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        id value;
        if (BCJGetEnum(dict, key, options, defaultValue, enumMapping, &value, outError)) return NO;

        //Success
        return BCJSetValue(target, targetKey, value, outError);
    });
}
