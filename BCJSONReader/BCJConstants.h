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



#pragma mark - Options
enum : NSUInteger {
    BCJNoOptions = 0,
};



#pragma mark - Error domain
/**
 The BCJSONReader error domain.
 */
extern NSString * const BCJErrorDomain;



#pragma mark - Error codes
enum : NSInteger {
    BCJInvalidJSONDataError = 1000,
    BCJInvalidJSONPathError,
    BCJValueNotFoundError,
    BCJUnexpectedTypeError,
    BCJMissingEnumMappingKeyError,
    BCJInvalidValueError,
    BCJCollectionMappingError,
    BCJMultipleErrorsError,
};



#pragma mark - Error userInfo keys

/**
 userInfo key for the invalid JSON data
 */
extern NSString * const BCJInvalidSourceDataErrorKey;

/**
 userInfo key for the NSNumber position.
 */
extern NSString * const BCJInvalidJSONPathFailurePositionErrorKey;

/**
 userInfo key for the enumMapping NSDictionary included in a BCJMissingEnumMappingKeyError error.
 */
extern NSString * const BCJEnumMappingErrorKey;

/**
 userInfo key for the underlying NSError.
 */
extern NSString * const BCJUnderlyingErrorKey;

/**
 <#Description#>
 */
extern NSString * const BCJMultipleErrorsKey;

/**
 <#Description#>
 */
extern NSString * const BCJElementErrorKey;

#endif
