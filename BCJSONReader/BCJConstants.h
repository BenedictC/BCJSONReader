//
//  BCJConstants.h
//  BCJSONReader
//
//  Created by Benedict Cohen on 22/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#ifndef BCJSONReader_BCJConstants_h
#define BCJSONReader_BCJConstants_h

#import <Foundation/Foundation.h>



#pragma mark - Errors
/**
 The BCJSONReader error domain.
 */
extern NSString * const BCJErrorDomain;

/**
 userInfo key for the BCJSource instance involved in the error.
 */
extern NSString * const BCJSourceErrorKey;

/**
 userInfo key for the enumMapping NSDictionary involved in a BCJMissingKeyForEnumMappingError error.
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
#pragma mark - Invalid compile time input
    BCJInvalidJSONPathError = 1000,

#pragma mark - Missing data
    BCJMissingSourceValueError,
    BCJMissingKeyForEnumMappingError,

#pragma mark - Unexpected data/value (wrong type or value)
//Invalid value errors
    BCJInvalidJSONDataError,
    BCJInvalidValueError,

//Value type errors
    BCJUnexpectedTypeError,

//Collection type errors
    BCJUnexpectedKeyTypeError,
    BCJUnexpectedElementTypeError,

#pragma mark - Failed completion block errors
    BCJElementMappingError,
    BCJUnknownError,
};



#pragma mark - options
enum : NSUInteger {
    BCJNoOptions = 0,
};



#endif
