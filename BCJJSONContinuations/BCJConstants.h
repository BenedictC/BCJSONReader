//
//  BCJConstants.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 31/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>



#pragma mark - Errors
/**
 The BCJJSONContinuation error domain.
 */
extern NSString * const BCJErrorDomain;

/**
 userInfo key for the BCJJSONSource instance involved in the error.
 */
extern NSString * const BCJJSONSourceErrorKey;

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



enum : NSInteger {
    BCJUnknownEnumMappingKeyError,
    BCJUnexpectedElementTypeError,
    BCJElementMappingError,
    BCJMissingValueError,
    BCJUnexpectedTypeError,
    BCJInvalidValueError,
    BCJInvalidJSONPathError,
};
