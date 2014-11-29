//
//  BCJSourceConstants.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 20/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#ifndef BCJJSONContinuations_BCJSourceConstants_h
#define BCJJSONContinuations_BCJSourceConstants_h

#import <Foundation/Foundation.h>



#pragma mark - Results
/**
 The result type for getting a value from a source.
 */
typedef NS_ENUM(NSUInteger, BCJSourceResult){
    /**
     The get failed.
     */
    BCJSourceResultFailure,
    /**
     The get succeed.
     */
    BCJSourceResultSuccess,
    /**
     The get did not retrieve a value from the source.
     */
    BCJSourceResultValueNotFound,
};



#pragma mark - Source options
/**
 Options to modifiy the behaviour of the source. It is reccommend that these values are not used directly. Instead use a BCJSourceMode value which are pre-defined combinations of BCJSourceOptions.
 */
typedef NS_OPTIONS(NSUInteger, BCJSourceOptions){
    /**
     If the JSONPath evaluates to nil then the source will return BCJSourceResultFailure,
     */
    BCJSourceOptionPathMustEvaluateToValue     = (1UL << 0),
    /**
     If the JSONPath evaluates to NSNull then this will be replaced with nil.
     */
    BCJSourceOptionReplaceNullWithNil          = (1UL << 1),
    /**
     If the JSONPath evaluates to nil then the source will not return BCJSourceResultValueNotFound.
     */
    BCJSourceOptionTreatValueNotFoundAsSuccess = (1UL << 2),
};



#pragma mark - Source modes (i.e. predefined source options)
/**
 BCJSourceMode are pre-defined combinations of BCJSourceOptions which describe common behaviours.
 */
typedef BCJSourceOptions BCJSourceMode;

/**
 The source will return BCJSourceResultValueNotFound if JSONPath evaluates to nil.
 */
const static BCJSourceMode BCJSourceModeOptional     = 0;
/**
 The source will return BCJSourceResultValueNotFound if JSONPath evaluates to NSNull or nil.
 */
const static BCJSourceMode BCJSourceModeNullOptional = BCJSourceOptionReplaceNullWithNil;
/**
 The source will return defaultValue if JSONPath evaluates to nil.
 */
const static BCJSourceMode BCJSourceModeDefaultable  = BCJSourceOptionTreatValueNotFoundAsSuccess;
/**
 The source will return defaultValue if JSONPath evaluates to NSNull or nil.
 */
const static BCJSourceMode BCJSourceModeNullDefaultable  = BCJSourceOptionReplaceNullWithNil | BCJSourceOptionTreatValueNotFoundAsSuccess;
/**
 The source will fail if JSONPath evaluates to nil.
 */
const static BCJSourceMode BCJSourceModeStrict  = BCJSourceOptionPathMustEvaluateToValue;
/**
 The source will fail if JSONPath evaluates to nil. If JSONPath evaluates to NSNull then it will return defaultValue which maybe nil.
 */
const static BCJSourceMode BCJSourceModeNullStrict  = BCJSourceOptionReplaceNullWithNil | BCJSourceOptionPathMustEvaluateToValue;



#endif
