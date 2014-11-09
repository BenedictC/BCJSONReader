//
//  BCJConstants.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 31/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>



#pragma mark - Errors
extern NSString * const BCJErrorDomain;

extern NSString * const BCJJSONSourceErrorKey;

extern NSString * const BCJEnumMappingErrorKey;

extern NSString * const BCJUnderlyingErrorKey;



enum : NSInteger {
    BCJUnknownEnumMappingKeyError,
    BCJUnexpectedElementTypeError,
    BCJElementMappingError,
    BCJMissingValueError,
    BCJUnexpectedTypeError,
    BCJInvalidValueError,
    BCJInvalidJSONPathError,
};
