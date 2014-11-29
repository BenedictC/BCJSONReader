//
//  BCJConstants.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 22/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#ifndef BCJJSONContinuations_BCJConstants_h
#define BCJJSONContinuations_BCJConstants_h

#import <Foundation/Foundation.h>



#pragma mark - Errors
/**
 The BCJJSONContinuation error domain.
 */
extern NSString * const BCJErrorDomain;

/**
 userInfo key for the BCJSource instance involved in the error.
 */
extern NSString * const BCJSourceErrorKey;

/**
 userInfo key for the enumMapping NSDictionary involved in a BCJUnknownEnumMappingKeyError error.
 */
extern NSString * const BCJEnumMappingErrorKey;

/**
 userInfo key for the underlying NSError.
 */
extern NSString * const BCJUnderlyingErrorKey;

/**
 userInfo key for the NSNumber position.
 */
extern NSString * const BCJInvalidJSONPathFailurePositionErrorKey;

/**
 userInfo key for the invalid JSON data
 */
extern NSString * const BCJInvalidJSONDataErrorKey;



enum : NSInteger {
    BCJUnknownEnumMappingKeyError,
    BCJUnexpectedElementTypeError,
    BCJElementMappingError,
    BCJUnexpectedTypeError,
    BCJMissingValueError,
    BCJInvalidValueError,
    BCJInvalidJSONPathError,
    BCJInvalidJSONDataError,
};



#pragma mark - options
enum : NSUInteger {
    BCJNoOptions = 0,
};



#endif
