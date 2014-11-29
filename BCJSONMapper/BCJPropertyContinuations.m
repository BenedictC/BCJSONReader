//
//  BCJPropertyContinuations.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 21/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJPropertyContinuations.h"

#import "BCJSource.h"
#import "BCJAdditionalTypes.h"
#import "BCJMap.h"
#import "BCJStackSource.h"
#import "BCJStackTarget.h"
#import "BCJTarget+ValueIntrospection.h"

#import <BCLContinuations/BCLBlockContinuation.h>



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetProperty(BCJSource *source, BCJTarget *target) {
    NSCParameterAssert(source != nil);
    NSCParameterAssert(target != nil);

    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {

        //0. Get the value
        id value;
        BCJSourceResult result = [source getValue:&value error:outError];
        switch (result) {
            case BCJSourceResultValueNotFound:
                return YES;
            case BCJSourceResultFailure:
                return NO;
            case BCJSourceResultSuccess:
                break;
        }

        //Attempt to set the value
#pragma message "TODO: Warn if attempting to set nil for a scalar value on an object that does not respond to setNilValueForKey:"        
        switch ([target canReceiveValue:value]) {
            case BCJTargetValueEligabilityStatusPermitted:
                return [target setValue:value error:outError];
            case BCJTargetValueEligabilityStatusUnknown:
                return [target setValue:value error:outError];

            case BCJTargetValueEligabilityStatusForbidden:
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
    return BCJSetProperty(BCJCreateSource(jsonPath), BCJCreateTarget(propertyKey));
}



#pragma mark - Convienince constructors that implicitly take the current target
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetEnum(NSString *sourceJSONPath, NSString *targetPropertyKey, NSDictionary *enumMapping)  {
    return BCJSetEnum(BCJCreateSource(sourceJSONPath), BCJCreateTarget(targetPropertyKey), enumMapping);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(NSString *sourceJSONPath, NSString *targetPropertyKey, Class elementClass, BCJMapOptions options, id(^fromArrayMap)(NSUInteger elementIndex, id elementValue, NSError **outError))  {
    return BCJSetMap(BCJCreateSource(sourceJSONPath), BCJCreateTarget(targetPropertyKey), elementClass, options, fromArrayMap);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(NSString *sourceJSONPath, NSString *targetPropertyKey, Class elementClass, BCJMapOptions options, NSArray *sortDescriptors, id(^fromDictionaryMap)(id elementKey, id elementValue, NSError **outError))  {
    return BCJSetMap(BCJCreateSource(sourceJSONPath), BCJCreateTarget(targetPropertyKey), elementClass, options, sortDescriptors, fromDictionaryMap);
}
