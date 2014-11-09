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
BOOL BCJ_OVERLOADABLE BCJIsOfKindClass(id value, Class class, NSError **outError) BCJ_REQUIRED(1,2,3);



#pragma mark - Validation functions
BOOL BCJ_OVERLOADABLE BCJValidate(id value, NSPredicate *predicate, NSError **outError) BCJ_REQUIRED(1,2,3);
BOOL BCJ_OVERLOADABLE BCJValidate(id value, NSString *predicateString, NSError **outError) BCJ_REQUIRED(1,2,3);



#pragma mark - Validation setter functions
BOOL BCJ_OVERLOADABLE BCJValidateAndSet(BCJJSONTarget *target, id value, NSPredicate *predicate, NSError **outError) BCJ_REQUIRED(1,2,3,4);
BOOL BCJ_OVERLOADABLE BCJValidateAndSet(BCJJSONTarget *target, id value, NSString *predicateString, NSError **outError) BCJ_REQUIRED(1,2,3,4);
