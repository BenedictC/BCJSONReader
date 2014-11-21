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
#import "BCJJSONSource.h"

@class BCJPropertyTarget;



#pragma mark - NSDate from 1970
/**
 Return by reference an NSDate created by fetching an NSNumber from source and using it as the argument to dateWithTimeIntervalSince1970:.

 @param source   A source that references an NSNumber.
 @param outDate  On success contains an NSDate, otherwise nil.
 @param outError On failure contains an NSError that describes the reason for failure, otherwise nil.

 @return The result of getting the value from the source or BCJJSONSourceResultFailure if the result could not be converted to a date.
 */
BCJJSONSourceResult BCJ_OVERLOADABLE BCJGetDateFromTimeIntervalSince1970(BCJJSONSource *source, NSDate **outDate, NSError **outError) BCJ_REQUIRED(1,2,3);
/**
 Return a continuation that fetches an NSNumber from source, uses the NSNumber to create an NSDate with dateWithTimeIntervalSince1970: and if a value was fetched invokes setValue:outError: on target with the NSDate.

 @param target A target that references an NSDate property.
 @param source A source that references an NSNumber.

 @return A continuation.
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromTimeIntervalSince1970(BCJPropertyTarget *target, BCJJSONSource *source) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;

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

 @return The result of getting the value from the source or BCJJSONSourceResultFailure if the result could not be converted to a date.
 */
BCJJSONSourceResult BCJ_OVERLOADABLE BCJGetDateFromISO8601String(BCJJSONSource *source, NSDate **outDate, NSError **outError) BCJ_REQUIRED(1,2);
/**
 Returns a continuation that calls BCJGetDateFromISO8601String and if a value was fetched invokes setValue:outError: on target with the NSDate.

 @param target A target that references an NSDate property.
 @param source A source that references an NSString.

 @return A continuation.
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromISO8601String(BCJPropertyTarget *target, BCJJSONSource *source) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;

#pragma mark - NSURL
/**
 Returns by reference an NSURL created by fetching an NSString from source and uses it to create an NSURL with URLWithString:.

 @param source   A source that references an NSString that represents a URL.
 @param outURL   On success contains an NSURL, otherwise nil.
 @param outError On failure contains an NSError that describes the reason for failure, otherwise nil.

 @return The result of getting the value from the source or BCJJSONSourceResultFailure if the result could not be converted to a URL.
 */
BCJJSONSourceResult BCJ_OVERLOADABLE BCJGetURL(BCJJSONSource *source, NSURL **outURL, NSError **outError) BCJ_REQUIRED(1,2,3);
/**
  Returns a continuation that calls BCJGetURL and if a value was fetched invokes setValue:outError: on target with the NSURL.

 @param target A target the references an NSURL property.
 @param source A source that references an NSString.

 @return A continuation.
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetURL(BCJPropertyTarget *target, BCJJSONSource *source) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
