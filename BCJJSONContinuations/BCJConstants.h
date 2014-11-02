//
//  BCJConstants.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 31/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

@import Foundation;



#pragma mark - Getter options
typedef NS_OPTIONS(NSUInteger, BCJGetterOptions) {
    BCJGetterOptionReplaceNullWithNil  = (1UL  << 0),
    BCJGetterOptionReplaceNilWithDefaultValue = (1UL  << 1),
    BCJGetterOptionAllowsNilValue  = (1UL  << 2),
};



#pragma mark - Getter modes (i.e. predefined getter options)
typedef BCJGetterOptions BCJGetterMode;
const static BCJGetterMode BCJGetterModeMantatory           = 0;

const static BCJGetterMode BCJGetterModeOptional            = BCJGetterOptionAllowsNilValue;
const static BCJGetterMode BCJGetterModeDefaultable         = BCJGetterOptionAllowsNilValue     | BCJGetterOptionReplaceNilWithDefaultValue;

const static BCJGetterMode BCJGetterModeNullableOptional    = BCJGetterOptionReplaceNullWithNil | BCJGetterOptionAllowsNilValue;
const static BCJGetterMode BCJGetterModeNullableDefaultable = BCJGetterOptionReplaceNullWithNil | BCJGetterOptionAllowsNilValue | BCJGetterOptionReplaceNilWithDefaultValue;



#pragma mark - Errors
extern NSString * const BCJErrorDomain;



enum : NSInteger {
    BCJUnexpectedTypeError,
    BCJIndexOutOfBoundsError,
    BCJMissingKeyError,
    BCJInvalidValueError,
};
