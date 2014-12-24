//
//  BCJValidation.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 31/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <BCLContinuations/BCLContinuations.h>
#import "BCJDefines.h"
#import "BCJTarget.h"
#import "BCJError.h"



#pragma mark - Type checking continuations
BOOL BCJ_OVERLOADABLE BCJIsOfKindClass(id value, Class class, NSError **outError) {
    BCJParameterExpectation(class != nil);
    BOOL isValid = [value isKindOfClass:class];
    if (!isValid) {
        if (outError != NULL) {
            NSString *criteria = [NSString stringWithFormat:@"value.class == %@", NSStringFromClass(class)];
            *outError = [BCJError invalidValueErrorWithJSONSource:nil value:value criteria:criteria];
        }
        return NO;
    }

    return YES;
}



#pragma mark - Validation functions
BOOL BCJ_OVERLOADABLE BCJValidate(id value, NSPredicate *predicate, NSError **outError) {
    BCJParameterExpectation(predicate != nil);
    BOOL isValid = [predicate evaluateWithObject:value];
    if (!isValid) {
        if (outError != NULL) *outError = [BCJError invalidValueErrorWithJSONSource:nil value:value criteria:predicate.predicateFormat];
        return NO;
    }

    return YES;
}



BOOL BCJ_OVERLOADABLE BCJValidate(id value, NSString *predicateString, NSError **outError) {
    return BCJValidate(value, [NSPredicate predicateWithFormat:predicateString], outError);
}



#pragma mark - Validation setter function
BOOL BCJ_OVERLOADABLE BCJValidateAndSet(id value,BCJTarget *target, NSPredicate *predicate, NSError **outError) {
    if (!BCJValidate(value, predicate, outError)) return NO;

    return [target setValue:value error:outError];
}



BOOL BCJ_OVERLOADABLE BCJValidateAndSet(id value, BCJTarget *target, NSString *predicateString, NSError **outError) {
    return  BCJValidateAndSet(target, value, [NSPredicate predicateWithFormat:predicateString], outError);
}
