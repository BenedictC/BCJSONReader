//
//  BCJPropertyContinuations.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 21/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJPropertyContinuations.h"

#import "BCJJSONSource.h"
#import "BCJAdditionalTypes.h"
#import "BCJMap.h"
#import "BCJStackJSONSource.h"
#import "BCJStackPropertyTarget.h"
#import "BCJPropertyTarget+ValueIntrospection.h"

#import <BCLContinuations/BCLBlockContinuation.h>



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetProperty(BCJJSONSource *source, BCJPropertyTarget *target) {
    NSCParameterAssert(source != nil);
    NSCParameterAssert(target != nil);

    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {

        //0. Get the value
        id value;
        BCJJSONSourceResult result = [source getValue:&value error:outError];
        switch (result) {
            case BCJJSONSourceResultValueNotFound:
                return YES;
            case BCJJSONSourceResultFailure:
                return NO;
            case BCJJSONSourceResultSuccess:
                break;
        }

        //Attempt to set the value
        switch ([target canReceiveValue:value]) {
            case BCJPropertyTargetValueEligabilityStatusPermitted:
                return [target setValue:value error:outError];
            case BCJPropertyTargetValueEligabilityStatusUnknown:
                return [target setValue:value error:outError];

            case BCJPropertyTargetValueEligabilityStatusForbidden:
                break;
        }

        //Try and fix up value so that it is acceptable.
        Class expectedClass = [target expectedClass];
        BOOL isValueAString = [value isKindOfClass:NSString.class];
        BOOL isValueANumber = [value isKindOfClass:NSNumber.class];
        BOOL isTargetAURL = [expectedClass isEqual:NSURL.class];
        BOOL isTargetADate = [expectedClass isEqual:NSDate.class];

        //a. String->URL
        if (isValueAString && isTargetAURL) {
            NSURL *url = [NSURL URLWithString:value];
            if (url == nil) {
                if (outError != NULL) *outError = [NSError errorWithDomain:@"TODO" code:0 userInfo:nil];
                return NO;
            }
            return [target setValue:url error:outError];
        }

        //b. Number->Date
        if (isValueANumber && isTargetADate) {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[value integerValue]];
            return [target setValue:date error:outError];
        }

        //c. String->Date
        if (isValueAString && isTargetADate) {
            NSDate *date = BCJDateFromISO8601String(value);
            if (date == nil) {
                if (outError != NULL) *outError = [NSError errorWithDomain:@"TODO" code:0 userInfo:nil];
                return NO;
            }
            return [target setValue:date error:outError];
        }

        //2. We were unable to convert value to a known good value. This is a hail Mary.
        //TODO: Would it be better to just fail?
        return [target setValue:value error:outError];
    });
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetProperty(NSString *jsonPath, NSString *propertyKey) {
    return BCJSetProperty(BCJSource(jsonPath), BCJTarget(propertyKey));
}



#pragma mark - Convienince constructors that implicitly take the current target
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetEnum(NSString *sourceJSONPath, NSString *targetPropertyKey, NSDictionary *enumMapping)  {
    return BCJSetEnum(BCJSource(sourceJSONPath), BCJTarget(targetPropertyKey), enumMapping);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(NSString *sourceJSONPath, NSString *targetPropertyKey, Class elementClass, BCJMapOptions options, id(^fromArrayMap)(NSUInteger elementIndex, id elementValue, NSError **outError))  {
    return BCJSetMap(BCJSource(sourceJSONPath), BCJTarget(targetPropertyKey), elementClass, options, fromArrayMap);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(NSString *sourceJSONPath, NSString *targetPropertyKey, Class elementClass, BCJMapOptions options, NSArray *sortDescriptors, id(^fromDictionaryMap)(id elementKey, id elementValue, NSError **outError))  {
    return BCJSetMap(BCJSource(sourceJSONPath), BCJTarget(targetPropertyKey), elementClass, options, sortDescriptors, fromDictionaryMap);
}
