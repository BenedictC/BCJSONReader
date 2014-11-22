//
//  BCJMappingContinuations.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 21/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJMappingContinuations.h"

#import "BCJJSONSource.h"
#import "BCJAdditionalTypes.h"
#import "BCJMap.h"
#import "BCJStackJSONSource.h"
#import "BCJStackPropertyTarget.h"

#import "BCJPropertyTarget+ExpectedType.h"

#import "BCLBlockContinuation.h"



static inline Class BCJClassFromObjCType(NSString *objCType) {
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^T@\"([^\"]*)\"" options:0 error:NULL];
//    NSTextCheckingResult *match = [regex firstMatchInString:propertyString options:0 range:NSMakeRange(0, [propertyString length])];
//    NSRange range = [match rangeAtIndex:1];
//    (match == nil) ? nil : [propertyString substringWithRange:range];

#warning TODO:
    return [NSObject class];
}



static inline BOOL BCJStorageOfTypeCanReceiveValue(NSString *objCType, NSValue *value) {
#warning TODO:
    return YES;
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJMapping(BCJJSONSource *source, BCJPropertyTarget *target) {
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

        //1. nil value
        if (value == nil) {
            return [target setValue:value error:outError];
        }

        //2. See if value & target are of the same kind
        NSString *targetObjCType = [target expectedType];
        Class expectedClass = BCJClassFromObjCType(targetObjCType);
        if ([value isKindOfClass:expectedClass]) {
            return [target setValue:value error:outError];
        }

        //3. Check if value is an NSValue
        BOOL isValueType = [value isKindOfClass:NSValue.class];
        if (isValueType && BCJStorageOfTypeCanReceiveValue(targetObjCType, value)) {
            return [target setValue:value error:outError];
        }

        //4. Check for special cases
        //a. string->URL
        BOOL isValueAString = [value isKindOfClass:NSString.class];
        BOOL isTargetAURL = [expectedClass isEqual:NSURL.class];
        if (isValueAString && isTargetAURL) {
            NSURL *url = [NSURL URLWithString:value];
            if (url == nil) {
                if (outError != NULL) *outError = [NSError errorWithDomain:@"TODO" code:0 userInfo:nil];
                return NO;
            }
            return [target setValue:url error:outError];
        }

        //b. number->Date
        BOOL isValueANumber = [value isKindOfClass:NSNumber.class];
        BOOL isTargetADate = [expectedClass isEqual:NSDate.class];
        if (isValueANumber && isTargetADate) {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[value integerValue]];
            return [target setValue:date error:outError];
        }

        //c. string->Date
        if (isValueAString && isTargetADate) {
            NSDate *date = BCJDateFromISO8601String(value);
            if (date == nil) {
                if (outError != NULL) *outError = [NSError errorWithDomain:@"TODO" code:0 userInfo:nil];
                return NO;
            }
            return [target setValue:date error:outError];
        }

        //Attempt to set the value
        if (outError != NULL) *outError = [NSError errorWithDomain:@"TODO: source is not compatible with target" code:0 userInfo:nil];
        return NO;
    });
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJMapping(NSString *jsonPath, NSString *propertyKey) {
    return BCJMapping(BCJSource(jsonPath), BCJTarget(propertyKey));
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
