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

#import "BCJPropertyTarget+ExpectedClass.h"

#import "BCLBlockContinuation.h"



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

        //1. Attempt to set the value
        if ([target canReceiveValue:value]) {
            return [target setValue:value error:outError];
        }

        //2. Check for special cases
        Class expectedClass = [target expectedClass];

        //a. String->URL
        BOOL isValueAString = [value isKindOfClass:NSString.class];
        BOOL isTargetAURL = [expectedClass isEqual:NSURL.class]; //TODO: Should we consider NSURL subclasses too?
        if (isValueAString && isTargetAURL) {
            NSURL *url = [NSURL URLWithString:value];
            if (url == nil) {
                if (outError != NULL) *outError = [NSError errorWithDomain:@"TODO" code:0 userInfo:nil];
                return NO;
            }
            return [target setValue:url error:outError];
        }

        //b. Number->Date
        BOOL isValueANumber = [value isKindOfClass:NSNumber.class];
        BOOL isTargetADate = [expectedClass isEqual:NSDate.class];  //TODO: Should we consider NSURL subclasses too?
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

        //3. Bust! Nothing left to try.
        if (outError != NULL) *outError = [NSError errorWithDomain:@"TODO: source is not compatible with target" code:0 userInfo:nil];
        return NO;
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
