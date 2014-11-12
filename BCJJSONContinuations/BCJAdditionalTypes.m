//
//  BCJAdditionalTypes.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 31/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJAdditionalTypes.h"
#import "BCJError.h"
#import "BCJJSONSource+LateBoundClassCheck.h"
#import "BCJJSONTarget.h"



#pragma mark - NSDate from 1970
BOOL BCJ_OVERLOADABLE BCJGetDateFromTimeIntervalSince1970(BCJJSONSource *source, NSDate **outDate, NSError **outError) {
    //Perform additional checks that couldn't be performed when source and target are created
    NSCParameterAssert(source != nil);
    NSCAssert(source.expectedClass == nil, @"A source must not have a defaultExpectedClass when passed to a type-specific getter or setter.");

    //Reset outValue
    *outDate = nil;

    //Get value
    NSNumber *timeInterval;
    if (![source getValue:&timeInterval ofKind:NSNumber.class error:outError]) return NO;

    //If we don't have a value then we don't need to create a date
    if (timeInterval == nil) return YES;

    //'Set' value
    *outDate = [NSDate dateWithTimeIntervalSince1970:[timeInterval integerValue]];
    return YES;
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromTimeIntervalSince1970(BCJJSONTarget *target, BCJJSONSource *source) {
    //Perform additional checks that couldn't be performed when source and target are created
    NSCParameterAssert(target !=nil);
    NSCParameterAssert(source != nil);
    NSCAssert(source.expectedClass == nil, @"A source must not have a defaultExpectedClass when passed to a type-specific getter or setter.");

    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        NSDate *date;
        if (!BCJGetDateFromTimeIntervalSince1970(source, &date, outError)) return NO;

        return [target setWithValue:date outError:outError];
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



BOOL BCJ_OVERLOADABLE BCJGetDateFromISO8601String(BCJJSONSource *source, NSDate **outDate, NSError **outError) {
    //Perform additional checks that couldn't be performed when source and target are created
    NSCParameterAssert(source != nil);
    NSCAssert(source.expectedClass == nil, @"A source must not have a defaultExpectedClass when passed to a type-specific getter or setter.");

    //Reset outValue
    *outDate = nil;

    static NSString * const sentinal = @"SENTINAL";
    NSString *defaultString = (source.defaultValue == nil) ? nil : sentinal;
    BCJJSONSource *stringSource = [[BCJJSONSource alloc] initWithObject:source.object JSONPath:source.JSONPath expectedClass:NSString.class options:source.options defaultValue:defaultString];

    NSString *dateString;
    //TODO: Should we return a different error?
    if (![stringSource getValue:&dateString ofKind:nil error:outError]) return NO;

    //If we don't have a value then the getter was happy with a nil value so we don't need to create a date.
    if (dateString == nil) return YES;

    //Did the getter return our sentinal?
    BOOL shouldUseDefault = [dateString isEqualToString:sentinal];
    if (shouldUseDefault) {
        *outDate = source.defaultValue;
        return YES;
    }

    //Attempt to create a string from the fetched string
    NSDate *possibleDate = BCJDateFromISO8601String(dateString);
    BOOL didFailToCreateDate = (possibleDate == nil);
    if (didFailToCreateDate) {
        if (outError != NULL) {
            NSString *criteria = [NSString stringWithFormat:@"is a valid ISO 8601 date"];
            *outError = [BCJError invalidValueErrorWithJSONSource:source value:possibleDate criteria:criteria];
        }
        return NO;
    }

    //Done!
    *outDate = possibleDate;
    return YES;
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromISO8601String(BCJJSONTarget *target, BCJJSONSource *source) {
    //Perform additional checks that couldn't be performed when source and target are created
    NSCParameterAssert(target != nil);
    NSCParameterAssert(source != nil);
    NSCAssert(source.expectedClass == nil, @"A source must not have a defaultExpectedClass when passed to a type-specific getter or setter.");

    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        NSDate *date;
        if (!BCJGetDateFromISO8601String(source, &date, outError)) return NO;

        return [target setWithValue:date outError:outError];
    });
}



#pragma mark - Get NSURL
BOOL BCJ_OVERLOADABLE BCJGetURL(BCJJSONSource *source, NSURL **outURL, NSError **outError) {
    //Perform additional checks that couldn't be performed when source and target are created
    NSCParameterAssert(source != nil);
    NSCAssert(source.expectedClass == nil, @"A source must not have a defaultExpectedClass when passed to a type-specific getter or setter.");

    //Reset outValue
    *outURL = nil;

    id fetchedValue;
    if (![source getValue:&fetchedValue ofKind:nil error:outError]) return NO;

    //If the getter succeed with a nil then we're done
    if (fetchedValue == nil) return YES;

    //The value is a URL so we're done
    if ([fetchedValue isKindOfClass:NSURL.class]) {
        *outURL = fetchedValue;
        return YES;

    }

    //Attempt to creat URL from the fetched string
    if ([fetchedValue isKindOfClass:NSString.class]) {
        NSURL *url = [NSURL URLWithString:fetchedValue];
        if (url == nil) {
            if (outError != NULL) *outError = [BCJError invalidValueErrorWithJSONSource:source value:fetchedValue criteria:@"is a valid URL"];
            return NO;
        }

        *outURL = url;
        return YES;
    }

    //The fetch Value was of the wrong type
    if (outError != NULL) *outError = [BCJError unexpectedTypeErrorWithJSONSource:source value:fetchedValue expectedClass:NSString.class];
    return NO;
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetURL(BCJJSONTarget *target, BCJJSONSource *source) {
    //Perform additional checks that couldn't be performed when source and target are created
    NSCParameterAssert(target != nil);
    NSCParameterAssert(source != nil);
    NSCAssert(source.expectedClass == nil, @"A source must not have a defaultExpectedClass when passed to a type-specific getter or setter.");

    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        NSURL *value;
        if (!BCJGetURL(source, &value, outError)) return NO;

        return [target setWithValue:value outError:outError];
    });
}



#pragma mark - Get Enum
BOOL BCJ_OVERLOADABLE BCJGetEnum(BCJJSONSource *source, NSDictionary *enumMapping, id *outValue, NSError **outError) {
    NSCParameterAssert(source != nil);
    NSCParameterAssert(enumMapping != nil);
    NSCParameterAssert(outValue != nil);
    NSCParameterAssert(outError != nil);
    //Note that we don't need to check the source type because it will be used as a key to access an enum and we don't
    //care what the enum keys are.

    //Reset outValue
    *outValue = nil;

    //Get the value
    id enumKey;
    if (![source getValue:&enumKey error:outError]) return NO;

    //We don't have a key but that's fine because otherwise the getter out have complained.
    if (enumKey == nil) return YES;

    //Get the value
    id value = enumMapping[enumKey];

    //If the value is nil then the mapping was incomplete.
    if (value == nil) {
        if (outError != NULL) *outError = [BCJError unknownKeyForEnumMappingErrorWithJSONSource:source enumMapping:enumMapping key:enumKey];
        return NO;
    }

    *outValue = value;
    return YES;
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetEnum(BCJJSONTarget *target, BCJJSONSource *source, NSDictionary *enumMapping) {
    //Perform additional checks that couldn't be performed when source and target are created
    NSCParameterAssert(target != nil);
    NSCParameterAssert(source != nil);
    NSCParameterAssert(enumMapping != nil);
    //Note that we don't need to check the source type because it will be used as a key to access an enum and we don't

    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        id value;
        if (!BCJGetEnum(source, enumMapping, &value, outError)) return NO;
        return [target setWithValue:value outError:outError];
    });
}
