//
//  BCJAdditionalTypes.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 31/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BCLContinuations.h"
#import "BCJDefines.h"

@class BCJJSONSource;
@class BCJJSONTarget;



#pragma mark - NSDate from 1970
/**
 Return by reference an NSDate created by fetching an NSNumber from source and using it as the argument to dateWithTimeIntervalSince1970:.

 @param source   A source that references an NSNumber.
 @param outDate  On success contains an NSDate, otherwise nil.
 @param outError On failure contains an NSError that describes the reason for failure, otherwise nil.

 @return On success YES, otherwise NO.
 */
BOOL BCJ_OVERLOADABLE BCJGetDateFromTimeIntervalSince1970(BCJJSONSource *source, NSDate **outDate, NSError **outError) BCJ_REQUIRED(1,2,3);
/**
 Return a continuation that fetches an NSNumber from source, uses the NSNumber to create an NSDate with dateWithTimeIntervalSince1970: and if a value was fetched invokes setValue:outError: on target with the NSDate.

 @param target A target that references an NSDate property.
 @param source A source that references an NSNumber.

 @return A continuation.
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromTimeIntervalSince1970(BCJJSONTarget *target, BCJJSONSource *source) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;

#pragma mark - NSDate from ISO 8601
/**
 Returns NSDate created by converting dateString to a date. dateString must be in the following ISO 8601 format: yyyy-MM-dd'T'HH:mm:ss.SSSZ (e.g. 2014-11-11T11:32:00+00:00). Other ISO 8601 formats are not allowed.

 @param dateString A string reperesenting an ISO 8601 date.

 @return On success an NSDate representation of the supplied string, otherwise nil.
 */
NSDate *BCJDateFromISO8601String(NSString *dateString) BCJ_REQUIRED(1);
/**
 Returns by reference an NSDate created by fetching an NSString from source and uses it to create a date with BCJDateFromISO8601String.

 @param source   A source that references an NSString that represents an ISO 8601 date.
 @param outDate  On success contains an NSDate, otherwise nil.
 @param outError On failure contains an NSError that describes the reason for failure, otherwise nil.

 @return On success YES, otherwise NO.
 */
BOOL BCJ_OVERLOADABLE BCJGetDateFromISO8601String(BCJJSONSource *source, NSDate **outDate, NSError **outError) BCJ_REQUIRED(1,2);
/**
 Returns a continuation that calls BCJGetDateFromISO8601String and if a value was fetched invokes setValue:outError: on target with the NSDate.

 @param target A target that references an NSDate property.
 @param source A source that references an NSString.

 @return A continuation.
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromISO8601String(BCJJSONTarget *target, BCJJSONSource *source) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;

#pragma mark - NSURL
/**
 Returns by reference an NSURL created by fetching an NSString from source and uses it to create an NSURL with URLWithString:.

 @param source   A source that references an NSString that represents a URL.
 @param outURL   On success contains an NSURL, otherwise nil.
 @param outError On failure contains an NSError that describes the reason for failure, otherwise nil.

 @return On success YES, otherwise NO.
 */
BOOL BCJ_OVERLOADABLE BCJGetURL(BCJJSONSource *source, NSURL **outURL, NSError **outError) BCJ_REQUIRED(1,2,3);
/**
  Returns a continuation that calls BCJGetURL and if a value was fetched invokes setValue:outError: on target with the NSURL.

 @param target A target the references an NSURL property.
 @param source A source that references an NSString.

 @return A continuation.
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetURL(BCJJSONTarget *target, BCJJSONSource *source) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;

#pragma mark - Enums
/**
 Returns by references the a value from enumMapping. The value is fetched by getting the value from source and using this as the key in enumMapping.

 @warning source.defaultValue, if required, is used as the key for the mapping, it is NOT the final value.

 @param source      A source that references a key in enumMapping.
 @param enumMapping A dictionary.
 @param outValue    On success contains the value, otherwise nil.
 @param outError    On failure contains an NSError describing the reason for failure, otherwise nil.

 @return On success YES, otherwise NO.
 */
BOOL BCJ_OVERLOADABLE BCJGetEnum(BCJJSONSource *source, NSDictionary *enumMapping, id *outValue, NSError **outError) BCJ_REQUIRED(1,2,3,4);
/**
 Returns a continuation that calls BCJGetEnum and if a value was fetched invokes setValue:outError: on target with the value from BCJGetEnum.

 @param target      A target that references the same type as the values of enumMapping.
 @param source      A source that references the same type as the keys of enumMapping.
 @param enumMapping A dictionary.

 @return A continuation.
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetEnum(BCJJSONTarget *target, BCJJSONSource *source, NSDictionary *enumMapping) BCJ_REQUIRED(1,2,3) BCJ_WARN_UNUSED;
