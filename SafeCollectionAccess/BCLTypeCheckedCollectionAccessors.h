//
//  BCLTypeCheckedCollectionAccessors.h
//  BCLTypeCheckedCollectionAccessors
//
//  Created by Benedict Cohen on 20/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#ifndef BCLTypeCheckedCollectionAccessors_h
#define BCLTypeCheckedCollectionAccessors_h

#import <Foundation/Foundation.h>

/**
 BCLTypeCheckedCollectionAccessors is a collection of functions for type safe access to NSArray and NSDictionary. They 
 were created to be used when accessing JSON objects but their use is not limited to JSON objects.
 
 The functions follow the convention of returning nil on success and an NSError instance on failure. When an out value
 is specific required this will always be nil on failure. (The decision to use the error object as return value
 rather than using the result as the return value is due to the fact that nil can be a valid result for the
 optional and nullable functions. Using the result as the return value for these function would become confusing.)

 */


#pragma mark - Constants
static NSString * const BCLErrorDomain = @"BCLErrorDomain";

typedef NS_ENUM(NSUInteger, BCLError){
    BCLErrorUnknownError,
    BCLErrorInvalidSubscript,
    BCLErrorUnexpectedValueType,
};



#pragma mark - Type Checkers
/**
 <#Description#>

 @param object         <#object description#>
 @param class          <#class description#>

 @return <#return value description#>
 */
static inline NSError *BCLIsKindOfClass(id object, Class class) {
    return ([object isKindOfClass:class]) ? nil : [NSError errorWithDomain:BCLErrorDomain code:BCLErrorUnexpectedValueType userInfo:
                                                   @{
                                                     NSLocalizedDescriptionKey : NSLocalizedString(@"Failed to access object in collection", nil),
                                                     NSLocalizedFailureReasonErrorKey : [NSString stringWithFormat:NSLocalizedString(@"Expected object <%@> to be an instance of class <%@>.", nil), [object debugDescription], NSStringFromClass(class)]
                                                     }];
}



#pragma mark - NSArray Accessors
/**
 <#Description#>

 @param array          <#array description#>
 @param idx            <#idx description#>
 @param class          <#class description#>
 @param outValue       <#outValue description#>

 @return <#return value description#>
 */
static inline NSError *BCLArrayGetMandatoryObject(NSArray *array, NSUInteger idx, Class class, id *outValue) {
    *outValue = nil; //Ensure that there isn't junk in the outValue.
    NSUInteger count = [array count];
    if (!(idx < count)) {
        return [NSError errorWithDomain:BCLErrorDomain code:BCLErrorInvalidSubscript userInfo:
                @{
                  NSLocalizedDescriptionKey : NSLocalizedString(@"Failed to access object in collection", nil),
                  NSLocalizedFailureReasonErrorKey : [NSString stringWithFormat:NSLocalizedString(@"Subscript <%@> not valid for collection <%@>.", nil), @(idx), array]
                  }];

    }
    *outValue = [array objectAtIndex:idx];
    BOOL isValidClass = [*outValue isKindOfClass:class];
    if (!isValidClass) {
        id value = *outValue; //Store the outValue for userInfo.
        *outValue = nil; //We've failed so nil out the value.
        return [NSError errorWithDomain:BCLErrorDomain code:BCLErrorUnexpectedValueType userInfo:
                @{
                  NSLocalizedDescriptionKey : NSLocalizedString(@"Failed to access object in collection", nil),
                  NSLocalizedFailureReasonErrorKey : [NSString stringWithFormat:NSLocalizedString(@"Expected object <%@> to be an instance of class <%@>.", nil), [value debugDescription], NSStringFromClass(class)]
                  }];

    }
    return nil;
}



/**
 <#Description#>

 @param array          <#array description#>
 @param idx            <#idx description#>
 @param nullSubstitute <#nullSubstitute description#>
 @param class          <#class description#>
 @param outValue       <#outValue description#>

 @return <#return value description#>
 */
static inline NSError *BCLArrayGetNullableObject(NSArray *array, NSUInteger idx, id nullSubstitute, Class class, id *outValue) {
    *outValue = nil; //Ensure that there isn't junk in the outValue.
    NSUInteger count = [array count];
    if (!(idx < count)) {
        return [NSError errorWithDomain:BCLErrorDomain code:BCLErrorInvalidSubscript userInfo:
                @{
                  NSLocalizedDescriptionKey : NSLocalizedString(@"Failed to access object in collection", nil),
                  NSLocalizedFailureReasonErrorKey : [NSString stringWithFormat:NSLocalizedString(@"Subscript <%@> not valid for collection <%@>.", nil), @(idx), array]
                  }];

    }
    *outValue = [array objectAtIndex:idx];

    BOOL isNull = [[*outValue class] isEqual:[NSNull class]];
    if (isNull) {
        *outValue = nullSubstitute;
        return nil;
    }

    BOOL isValidClass = [*outValue isKindOfClass:class];
    if (!isValidClass) {
        id value = *outValue; //Store the outValue for userInfo.
        *outValue = nil; //We've failed so nil out the value.
        return [NSError errorWithDomain:BCLErrorDomain code:BCLErrorUnexpectedValueType userInfo:
                @{
                  NSLocalizedDescriptionKey : NSLocalizedString(@"Failed to access object in collection", nil),
                  NSLocalizedFailureReasonErrorKey : [NSString stringWithFormat:NSLocalizedString(@"Expected object <%@> to be an instance of class <%@>.", nil), [value debugDescription], NSStringFromClass(class)]
                  }];

    }
    return nil;
}



#pragma mark - NSDictionary Accessors
/**
 <#Description#>

 @param dict           <#dict description#>
 @param key            <#key description#>
 @param class          <#class description#>
 @param outValue       <#outValue description#>

 @return <#return value description#>
 */
static inline NSError *BCLDictionaryGetMandatoryObject(NSDictionary *dict, id key, Class class, id *outValue) {
    *outValue = [dict objectForKey:key];
    if (*outValue == nil) {
        return [NSError errorWithDomain:BCLErrorDomain code:BCLErrorInvalidSubscript userInfo:
                @{
                  NSLocalizedDescriptionKey : NSLocalizedString(@"Failed to access object in collection", nil),
                  NSLocalizedFailureReasonErrorKey : [NSString stringWithFormat:NSLocalizedString(@"Subscript <%@> not valid for collection <%@>.", nil), key, dict]
                  }];

    }
    BOOL isValidClass = [*outValue isKindOfClass:class];
    if (!isValidClass) {
        id value = *outValue; //Store the outValue for userInfo.
        *outValue = nil; //We've failed so nil out the value.
        return [NSError errorWithDomain:BCLErrorDomain code:BCLErrorUnexpectedValueType userInfo:
                @{
                  NSLocalizedDescriptionKey : NSLocalizedString(@"Failed to access object in collection", nil),
                  NSLocalizedFailureReasonErrorKey : [NSString stringWithFormat:NSLocalizedString(@"Expected object <%@> to be an instance of class <%@>.", nil), [value debugDescription], NSStringFromClass(class)]
                  }];

    }

    return nil;
}



/**
 <#Description#>

 @param dict           <#dict description#>
 @param key            <#key description#>
 @param class          <#class description#>
 @param nullSubstitute <#nullSubstitute description#>
 @param outValue       <#outValue description#>

 @return <#return value description#>
 */
static inline NSError *BCLDictionaryGetNullableObject(NSDictionary *dict, id key, Class class, id nullSubstitute, id *outValue) {
    *outValue = [dict objectForKey:key];
    if (*outValue == nil) {
        return [NSError errorWithDomain:BCLErrorDomain code:BCLErrorInvalidSubscript userInfo:
                @{
                  NSLocalizedDescriptionKey : NSLocalizedString(@"Failed to access object in collection", nil),
                  NSLocalizedFailureReasonErrorKey : [NSString stringWithFormat:NSLocalizedString(@"Subscript <%@> not valid for collection <%@>.", nil), key, dict]
                  }];

    }

    BOOL isNull = [[*outValue class] isEqual:[NSNull class]];
    if (isNull) {
        *outValue = nullSubstitute;
        return nil;
    }

    BOOL isValidClass = [*outValue isKindOfClass:class];
    if (!isValidClass) {
        id value = *outValue; //Store the outValue for userInfo.
        *outValue = nil; //We've failed so nil out the value.
        return [NSError errorWithDomain:BCLErrorDomain code:BCLErrorUnexpectedValueType userInfo:
                @{
                  NSLocalizedDescriptionKey : NSLocalizedString(@"Failed to access object in collection", nil),
                  NSLocalizedFailureReasonErrorKey : [NSString stringWithFormat:NSLocalizedString(@"Expected object <%@> to be an instance of class <%@>.", nil), [value debugDescription], NSStringFromClass(class)]
                  }];

    }

    return nil;
}



/**
 <#Description#>

 @param dict           <#dict description#>
 @param key            <#key description#>
 @param class          <#class description#>
 @param defaultValue   <#defaultValue description#>
 @param outValue       <#outValue description#>

 @return <#return value description#>
 */
static inline NSError *BCLDictionaryGetOptionalObject(NSDictionary *dict, id key, Class class, id defaultValue, id *outValue) {
    *outValue = [dict objectForKey:key];
    if (*outValue == nil) {
        *outValue = defaultValue;
        return nil;
    }

    BOOL isValidClass = [*outValue isKindOfClass:class];
    if (!isValidClass) {
        id value = *outValue; //Store the outValue for userInfo.
        *outValue = nil; //We've failed so nil out the value.
        return [NSError errorWithDomain:BCLErrorDomain code:BCLErrorUnexpectedValueType userInfo:
                @{
                  NSLocalizedDescriptionKey : NSLocalizedString(@"Failed to access object in collection", nil),
                  NSLocalizedFailureReasonErrorKey : [NSString stringWithFormat:NSLocalizedString(@"Expected object <%@> to be an instance of class <%@>.", nil), [value debugDescription], NSStringFromClass(class)]
                  }];
        
    }
    
    return nil;
}



#endif
