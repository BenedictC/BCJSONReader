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
 
 The functions follow the convention of returning nil on success and an NSError instance on failure. The result is 
 returned via an out parameter. If the operation fails the value of the out parameter will be nil. (The decision to use
 the error object as return value rather than using the result as the return value is due to the fact that nil is  a 
 valid result for the optional and nullable functions. Using the result as the return value for these function 
 would become confusing.)

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
 Checks if the object is of the specified class.

 @param object         The object is inspect.
 @param class          The class that the object is expected to be.

 @return nil if the object is of type class otherwise an NSError describing the failure reason.
 */
 __attribute__((nonnull(1, 2)))
static inline NSError *BCLIsKindOfClass(id object, Class class) {
    return ([object isKindOfClass:class]) ? nil : [NSError errorWithDomain:BCLErrorDomain code:BCLErrorUnexpectedValueType userInfo:
                                                   @{
                                                     NSLocalizedDescriptionKey : NSLocalizedString(@"Failed to access object in collection", nil),
                                                     NSLocalizedFailureReasonErrorKey : [NSString stringWithFormat:NSLocalizedString(@"Expected object <%@> to be an instance of class <%@>.", nil), [object debugDescription], NSStringFromClass(class)]
                                                     }];
}



#pragma mark - NSArray Accessors
/**
 Fetches an object from array at idx providing it is of type class.

 @param array          The array to fetch the object from.
 @param idx            The index of in array.
 @param class          The type that the object is expected to be.
 @param outValue       Pointer to store the fetched object. On success contains object otherwise nil.

 @return nil if the fetch is successful otherwise an NSError describing the failure reason.
 */
 __attribute__((nonnull(1, 3, 4)))
static inline NSError * BCLArrayGetMandatoryObject(NSArray *array, NSUInteger idx, Class class, id *outValue) {
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
 Fetches an object from array at idx providing it is of type class or is NSNull. If the object is NSNull then 
 nullSubstitute will be used.
 
 @param array          The array to fetch the object from.
 @param idx            The index of in array.
 @param class          The type that the object is expected to be.
 @param nullSubstitute The object to use as outValue if the object at index in the array is NSNull.
 @param outValue       Pointer to store the fetched object. On success contains object or nullSubstitute otherwise nil.

 @return nil if the fetch is successful otherwise an NSError describing the failure reason.
 */
 __attribute__((nonnull(1, 3, 4, 5)))
static inline NSError *BCLArrayGetNullableObject(NSArray *array, NSUInteger idx, Class class, id nullSubstitute, id *outValue) {
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
 Fetches an object from dict using key providing it is of type class.

 @param dict           The dictionary to fetch the object from.
 @param key            The dictionary key to use.
 @param class          The type that the object is expected to be.
 @param outValue       Pointer to store the fetched object. On success contains object or nullSubstitute otherwise nil.

 @return nil if the fetch is successful otherwise an NSError describing the failure reason.
 */
 __attribute__((nonnull(1, 2, 3, 4)))
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
 Fetches an object from dict using key providing it is of type class or is NSNull. If the object is NSNull then
 nullSubstitute will be used.

 @param dict           The dictionary to fetch the object from.
 @param key            The dictionary key to use.
 @param class          The type that the object is expected to be.
 @param nullSubstitute The object to use as outValue if the value for key in dict is NSNull.
 @param outValue       Pointer to store the fetched object. On success contains object or nullSubstitute otherwise nil.

 @return nil if the fetch is successful otherwise an NSError describing the failure reason.
 */
 __attribute__((nonnull(1, 2, 3, 5)))
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
 Fetches an object from dict using key providing it is of type class. If the object is not found then defaultValue
 will be used.

 @param dict           The dictionary to fetch the object from.
 @param key            The dictionary key to use.
 @param class          The type that the object is expected to be.
 @param defaultValue   The object to use as outValue if the value for key is not in dict.
 @param outValue       Pointer to store the fetched object. On success contains object or defaultValue otherwise nil.

 @return nil if the fetch is successful otherwise an NSError describing the failure reason.
 */
 __attribute__((nonnull(1, 2, 3, 5)))
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
