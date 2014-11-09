//
//  BCJAdditionalTypes.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 31/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BCLContinuation.h"
#import "BCJDefines.h"

@class BCJJSONSource;
@class BCJJSONTarget;



#pragma mark - NSDate epoch
BOOL BCJ_OVERLOADABLE BCJGetDateFromTimeIntervalSinceEpoch(BCJJSONSource *source, NSDate **outDate, NSError **outError) BCJ_REQUIRED(1,2,3);
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromTimeIntervalSinceEpoch(BCJJSONTarget *target, BCJJSONSource *source) BCJ_REQUIRED(1,2);

#pragma mark - NSDate ISO 8601
NSDate *BCJDateFromISO8601String(NSString *dateString) BCJ_REQUIRED(1);
BOOL BCJ_OVERLOADABLE BCJGetDateFromISO8601String(BCJJSONSource *source, NSDate **outDate, NSError **outError) BCJ_REQUIRED(1,2);
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromISO8601String(BCJJSONTarget *target, BCJJSONSource *source) BCJ_WARN_UNUSED BCJ_REQUIRED(1,2);

#pragma mark - NSURL
BOOL BCJ_OVERLOADABLE BCJGetURL(BCJJSONSource *source, NSURL **outURL, NSError **outError) BCJ_REQUIRED(1,2,3);
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetURL(BCJJSONTarget *target, BCJJSONSource *source) BCJ_REQUIRED(1,2);

#pragma mark - Enums
/**
  The default value of the source is the default mapping key NOT mapping value.

 @param source      <#source description#>
 @param enumMapping <#enumMapping description#>
 @param outValue    <#outValue description#>
 @param outError    <#outError description#>

 @return <#return value description#>
 */
BOOL BCJ_OVERLOADABLE BCJGetEnum(BCJJSONSource *source, NSDictionary *enumMapping, id *outValue, NSError **outError) BCJ_REQUIRED(1,2,3,4);
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetEnum(BCJJSONTarget *target, BCJJSONSource *source, NSDictionary *enumMapping) BCJ_REQUIRED(1,2,3);
