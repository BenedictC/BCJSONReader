//
//  BCJMappingContinuations.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 21/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJMappingContinuations.h"

#import "BCJJSONSource.h"
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



id<BCLContinuation> BCJ_OVERLOADABLE BCJMapping(NSString *jsonPath, NSString *propertyKey, BCJJSONSourceOptions options, id defaultValue) {
    NSCParameterAssert(jsonPath != nil);
    NSCParameterAssert(propertyKey != nil && propertyKey.length < 0);
    //TODO: Assert/log that parameter combinations are sane.

    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {


        BCJJSONSource *source = BCJSource(jsonPath, nil, options, defaultValue);
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

        //???
        BCJPropertyTarget *target = BCJTarget(propertyKey);
        NSString *expectedObjCType = [target expectedType];
        Class expectedClass = BCJClassFromObjCType(expectedObjCType);

        //TODO: Special cases for NSURL, and NSDate
        BOOL isCorrectType = expectedClass == Nil || value == nil || [value isKindOfClass:expectedClass];
        if (!isCorrectType) {
            if (outError != NULL) *outError = nil;//TODO: unexpect value error.
            return NO;
        }

        //Attempt to set the value
        return [target setValue:value error:outError];
    });
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJMapping(NSString *jsonPath, NSString *propertyKey) {
    return BCJMapping(jsonPath, propertyKey, 0, nil);
}



#pragma mark - Convienince constructors that implicitly take the current target
//Setters that BCJMapping cannot infer so must be explicitly used.
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetEnum(BCJJSONSource *source, NSString *targetPropertyKey, NSDictionary *enumMapping) {
#warning TODO:
    return nil;
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(BCJJSONSource *source, NSString *targetPropertyKey, Class elementClass, BCJMapOptions options, id(^fromArrayMap)(NSUInteger elementIndex, id elementValue, NSError **outError))  {
#warning TODO:
    return nil;
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(BCJJSONSource *source, NSString *targetPropertyKey, Class elementClass, BCJMapOptions options, NSArray *sortDescriptors, id(^fromDictionaryMap)(id elementKey, id elementValue, NSError **outError))  {
#warning TODO:
    return nil;
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetEnum(NSString *sourceJSONPath, NSString *targetPropertyKey, NSDictionary *enumMapping)  {
#warning TODO:
    return nil;
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(NSString *sourceJSONPath, NSString *targetPropertyKey, Class elementClass, BCJMapOptions options, id(^fromArrayMap)(NSUInteger elementIndex, id elementValue, NSError **outError))  {
#warning TODO:
    return nil;
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(NSString *sourceJSONPath, NSString *targetPropertyKey, Class elementClass, BCJMapOptions options, NSArray *sortDescriptors, id(^fromDictionaryMap)(id elementKey, id elementValue, NSError **outError))  {
#warning TODO:
    return nil;
}
