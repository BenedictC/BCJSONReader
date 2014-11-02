//
//  BCJValidation.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 31/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLContinuation.h"
#import "BCJDefines.h"



#pragma mark - Type checking functions
BOOL BCJ_OVERLOADABLE BCJIsOfKindClass(id value, Class class, NSError **outError) __attribute__((nonnull(1,2,3)));



#pragma mark - Validation functions
BOOL BCJ_OVERLOADABLE BCJValidate(id value, NSPredicate *predicate, NSError **outError) __attribute__((nonnull(1,2,3)));
BOOL BCJ_OVERLOADABLE BCJValidate(id value, NSString *predicateString, NSError **outError) __attribute__((nonnull(1,2,3)));



#pragma mark - Validation setter functions
BOOL BCJ_OVERLOADABLE BCJValidateAndSet(id value, NSPredicate *predicate, id target, NSString *targetKey, NSError **outError) __attribute__((nonnull(1,2,3,4,5)));
BOOL BCJ_OVERLOADABLE BCJValidateAndSet(id value, NSString *predicateString, id target, NSString *targetKey, NSError **outError) __attribute__((nonnull(1,2,3,4,5)));
