//
//  BCJValidation.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 31/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BCJDefines.h"



#pragma mark - Type checking functions
/**
 Checks that value is of type class.

 @param value    The value to check.
 @param class    The class that value must be of.
 @param outError On failure contains an NSError describing the failure.

 @return YES if value is of type class, otherwise NO.
 */
BOOL BCJ_OVERLOADABLE BCJIsOfKindClass(id value, Class class, NSError **outError) BCJ_REQUIRED(1,2,3);



#pragma mark - Validation functions
/**
 Checks that a value conforms to a predicate.

 @param value     The value to check.
 @param predicate The predicate to evaluate the value against.
 @param outError On failure contains an NSError describing the failure.

 @return YES if value meets the predicate, otherwise NO.
 */
BOOL BCJ_OVERLOADABLE BCJValidate(id value, NSPredicate *predicate, NSError **outError) BCJ_REQUIRED(1,2,3);
/**
 Checks that a value conforms to a predicate. predicateString is used to created the predicate.

 @param value           The value to check.
 @param predicateString A string that is used to create an NSPredicate.
 @param outError        On failure contains an NSError describing the failure.

 @return YES if value meets the predicate, otherwise NO.
 */
BOOL BCJ_OVERLOADABLE BCJValidate(id value, NSString *predicateString, NSError **outError) BCJ_REQUIRED(1,2,3);



#pragma mark - Validation setter functions
/**
 Evaluates value against predicate and sets the target if value meets the predicate.

 @param target    The target
 @param value     The value to evaluate
 @param predicate A predicate
 @param outError  On failure contains an NSError describing the reason for failure.

 @return YES on success, otherwise NO.
 */
BOOL BCJ_OVERLOADABLE BCJValidateAndSet(BCJPropertyTarget *target, id value, NSPredicate *predicate, NSError **outError) BCJ_REQUIRED(1,2,3,4);
/**
 Evaluates value against predicate and sets the target if value meets the predicate.

 @param target          The target
 @param value           The value to evaluate
 @param predicateString A string that is used to create an NSPredicate.
 @param outError        On failure contains an NSError describing the reason for failure.

 @return YES on success, otherwise NO.
 */
BOOL BCJ_OVERLOADABLE BCJValidateAndSet(BCJPropertyTarget *target, id value, NSString *predicateString, NSError **outError) BCJ_REQUIRED(1,2,3,4);
