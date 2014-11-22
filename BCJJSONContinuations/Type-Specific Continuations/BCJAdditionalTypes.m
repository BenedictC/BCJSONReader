//
//  BCJAdditionalTypes.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 31/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJAdditionalTypes.h"
#import "BCJError.h"
#import "BCJJSONSource+DeferredClassCheck.h"
#import "BCJPropertyTarget.h"



#pragma mark - NSDate from 1970
BCJJSONSourceResult BCJ_OVERLOADABLE BCJGetDateFromTimeIntervalSince1970(BCJJSONSource *source, NSDate **outDate, NSError **outError) {
    //Perform additional checks that couldn't be performed when source and target are created
    NSCParameterAssert(source != nil);
    NSCAssert(source.expectedClass == nil, @"A source must not have a defaultExpectedClass when passed to a type-specific getter or setter.");

    //Reset outValue
    *outDate = nil;
    if (outError != NULL) *outError = nil;

    //Get value
    NSNumber *timeInterval;
    BCJJSONSourceResult result = [source getValue:&timeInterval ofKind:NSNumber.class error:outError];
    if (result != BCJJSONSourceResultSuccess) return result;

    //If we don't have a value then we don't need to create a date
    if (timeInterval == nil) return BCJJSONSourceResultSuccess;

    //'Set' value
    *outDate = [NSDate dateWithTimeIntervalSince1970:[timeInterval integerValue]];
    return BCJJSONSourceResultSuccess;
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromTimeIntervalSince1970(BCJJSONSource *source, BCJPropertyTarget *target) {
    //Perform additional checks that couldn't be performed when source and target are created
    NSCParameterAssert(target !=nil);
    NSCParameterAssert(source != nil);
    NSCAssert(source.expectedClass == nil, @"A source must not have a defaultExpectedClass when passed to a type-specific getter or setter.");

    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        NSDate *date;
        if (!BCJGetDateFromTimeIntervalSince1970(source, &date, outError)) return NO;

        return [target setValue:date error:outError];
    });
}



#pragma mark - NSDate ISO 8601
NSDate *BCJDateFromISO8601String(NSString *dateString) {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [NSDateFormatter new];
        formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    });

    NSDate *date = [formatter dateFromString:dateString];
    return date;
}



BCJJSONSourceResult BCJ_OVERLOADABLE BCJGetDateFromISO8601String(BCJJSONSource *source, NSDate **outDate, NSError **outError) {
    //Perform additional checks that couldn't be performed when source and target are created
    NSCParameterAssert(source != nil);
    NSCAssert(source.expectedClass == nil, @"A source must not have a defaultExpectedClass when passed to a type-specific getter or setter.");

    //Reset outValue
    *outDate = nil;
    if (outError != NULL) *outError = nil;

    static NSString * const sentinal = @"SENTINAL";
    NSString *defaultString = (source.defaultValue == nil) ? nil : sentinal;
    BCJJSONSource *stringSource = [[BCJJSONSource alloc] initWithObject:source.object JSONPath:source.JSONPath expectedClass:NSString.class options:source.options defaultValue:defaultString];

    NSString *dateString;
    //TODO: Should we return a different error?
    BCJJSONSourceResult result = [stringSource getValue:&dateString ofKind:nil error:outError];
    if (result != BCJJSONSourceResultSuccess) return result;

    //If we don't have a value then the getter was happy with a nil value so we don't need to create a date.
    if (dateString == nil) return BCJJSONSourceResultSuccess;

    //Did the getter return our sentinal?
    BOOL shouldUseDefault = [dateString isEqualToString:sentinal];
    if (shouldUseDefault) {
        *outDate = source.defaultValue;
        return BCJJSONSourceResultSuccess;
    }

    //Attempt to create a string from the fetched string
    NSDate *possibleDate = BCJDateFromISO8601String(dateString);
    BOOL didFailToCreateDate = (possibleDate == nil);
    if (didFailToCreateDate) {
        if (outError != NULL) {
            NSString *criteria = [NSString stringWithFormat:@"is a valid ISO 8601 date"];
            *outError = [BCJError invalidValueErrorWithJSONSource:source value:possibleDate criteria:criteria];
        }
        return BCJJSONSourceResultFailure;
    }

    //Done!
    *outDate = possibleDate;
    return BCJJSONSourceResultSuccess;
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromISO8601String(BCJJSONSource *source, BCJPropertyTarget *target) {
    //Perform additional checks that couldn't be performed when source and target are created
    NSCParameterAssert(target != nil);
    NSCParameterAssert(source != nil);
    NSCAssert(source.expectedClass == nil, @"A source must not have a defaultExpectedClass when passed to a type-specific getter or setter.");

    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        NSDate *date;
        if (!BCJGetDateFromISO8601String(source, &date, outError)) return NO;

        return [target setValue:date error:outError];
    });
}



#pragma mark - Get NSURL
BCJJSONSourceResult BCJ_OVERLOADABLE BCJGetURL(BCJJSONSource *source, NSURL **outURL, NSError **outError) {
    //Perform additional checks that couldn't be performed when source and target are created
    NSCParameterAssert(source != nil);
    NSCAssert(source.expectedClass == nil, @"A source must not have a defaultExpectedClass when passed to a type-specific getter or setter.");

    //Reset outValue
    *outURL = nil;
    if (outError != NULL) *outError = nil;

    id fetchedValue;
    //TODO: Should we return a different error?
    BCJJSONSourceResult result = [source getValue:&fetchedValue ofKind:nil error:outError];
    if (result != BCJJSONSourceResultSuccess) return result;

    //If the getter succeed with a nil then we're done
    if (fetchedValue == nil) return BCJJSONSourceResultSuccess;

    //The value is a URL so we're done
    if ([fetchedValue isKindOfClass:NSURL.class]) {
        *outURL = fetchedValue;
        return BCJJSONSourceResultSuccess;
    }

    //Attempt to creat URL from the fetched string
    if ([fetchedValue isKindOfClass:NSString.class]) {
        NSURL *url = [NSURL URLWithString:fetchedValue];
        if (url == nil) {
            if (outError != NULL) *outError = [BCJError invalidValueErrorWithJSONSource:source value:fetchedValue criteria:@"is a valid URL"];
            return BCJJSONSourceResultFailure;
        }

        *outURL = url;
        return BCJJSONSourceResultSuccess;
    }

    //The fetch Value was of the wrong type
    if (outError != NULL) *outError = [BCJError unexpectedTypeErrorWithJSONSource:source value:fetchedValue expectedClass:NSString.class];
    return BCJJSONSourceResultFailure;
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetURL(BCJJSONSource *source, BCJPropertyTarget *target) {
    //Perform additional checks that couldn't be performed when source and target are created
    NSCParameterAssert(target != nil);
    NSCParameterAssert(source != nil);
    NSCAssert(source.expectedClass == nil, @"A source must not have a defaultExpectedClass when passed to a type-specific getter or setter.");

    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        NSURL *value;
        if (!BCJGetURL(source, &value, outError)) return NO;

        return [target setValue:value error:outError];
    });
}
