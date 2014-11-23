//
//  BCJJSONSourceConstants.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 20/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#ifndef BCJJSONContinuations_BCJJSONSourceConstants_h
#define BCJJSONContinuations_BCJJSONSourceConstants_h

#import <Foundation/Foundation.h>



#pragma mark - Results
/**
 The result type for getting a value from a source.
 */
typedef NS_ENUM(NSUInteger, BCJJSONSourceResult){
    /**
     The get failed.
     */
    BCJJSONSourceResultFailure,
    /**
     The get succeed.
     */
    BCJJSONSourceResultSuccess,
    /**
     The get did not retrieve a value from the source.
     */
    BCJJSONSourceResultValueNotFound,
};



#pragma mark - Source options
/**
 Options to modifiy the behaviour of the source. It is reccommend that these values are not used directly. Instead use a BCJJSONSourceMode value which are pre-defined combinations of BCJJSONSourceOptions.
 */
typedef NS_OPTIONS(NSUInteger, BCJJSONSourceOptions){
    /**
     If the JSONPath evaluates to nil then the source will return BCJJSONSourceResultFailure,
     */
    BCJJSONSourceOptionPathMustEvaluateToValue     = (1UL << 0),
    /**
     If the JSONPath evaluates to NSNull then this will be replaced with nil.
     */
    BCJJSONSourceOptionReplaceNullWithNil          = (1UL << 1),
    /**
     If the JSONPath evaluates to nil then the source will not return BCJJSONSourceResultValueNotFound.
     */
    BCJJSONSourceOptionTreatValueNotFoundAsSuccess = (1UL << 2),
};



#pragma mark - Source modes (i.e. predefined source options)
/**
 BCJJSONSourceMode are pre-defined combinations of BCJJSONSourceOptions which describe common behaviours.
 */
typedef BCJJSONSourceOptions BCJJSONSourceMode;

/**
 The source will return BCJJSONSourceResultValueNotFound if JSONPath evaluates to nil.
 */
const static BCJJSONSourceMode BCJJSONSourceModeOptional     = 0;
/**
 The source will return BCJJSONSourceResultValueNotFound if JSONPath evaluates to NSNull or nil.
 */
const static BCJJSONSourceMode BCJJSONSourceModeNullOptional = BCJJSONSourceOptionReplaceNullWithNil;
/**
 The source will return defaultValue if JSONPath evaluates to nil.
 */
const static BCJJSONSourceMode BCJJSONSourceModeDefaultable  = BCJJSONSourceOptionTreatValueNotFoundAsSuccess;
/**
 The source will return defaultValue if JSONPath evaluates to NSNull or nil.
 */
const static BCJJSONSourceMode BCJJSONSourceModeNullDefaultable  = BCJJSONSourceOptionReplaceNullWithNil | BCJJSONSourceOptionTreatValueNotFoundAsSuccess;
/**
 The source will fail if JSONPath evaluates to nil.
 */
const static BCJJSONSourceMode BCJJSONSourceModeStrict  = BCJJSONSourceOptionPathMustEvaluateToValue;
/**
 The source will fail if JSONPath evaluates to nil. If JSONPath evaluates to NSNull then it will return defaultValue which maybe nil.
 */
const static BCJJSONSourceMode BCJJSONSourceModeNullStrict  = BCJJSONSourceOptionReplaceNullWithNil | BCJJSONSourceOptionPathMustEvaluateToValue;



#endif
