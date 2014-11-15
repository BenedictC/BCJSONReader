//
//  BCJJSONSource+OptionsAdditons.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 04/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#ifndef BCJJSONContinuations_BCJJSONSource_OptionsAdditons_h
#define BCJJSONContinuations_BCJJSONSource_OptionsAdditons_h



#import "BCJJSONSource.h"

/**
 Checks if BCJSourceOptionMustReturnValue has been set.

 @param options the options to check.

 @return YES if options contains BCJSourceOptionMustReturnValue, other wise NO.
 */
static inline BOOL BCJTreatValueNotFoundAsSuccess(BCJSourceOptions options) {
    return (options & BCJSourceOptionTreatValueNotFoundAsSuccess) != 0;
}

/**
 Checks if BCJSourceOptionPathMustEvaluateToValue has been set.

 @param options the options to check.

 @return YES if options contains BCJSourceOptionPathMustEvaluateToValue, other wise NO.
 */
static inline BOOL BCJPathMustEvaluateToValue(BCJSourceOptions options) {
    return (options & BCJSourceOptionPathMustEvaluateToValue) != 0;
}

/**
 Checks if BCJSourceOptionReplaceNullWithDefaultValue has been set.

 @param options the options to check.

 @return YES if options contains BCJSourceOptionReplaceNullWithDefaultValue, other wise NO.
 */
static inline BOOL BCJReplaceNullWithNil(BCJSourceOptions options) {
    return (options & BCJSourceOptionReplaceNullWithNil) != 0;
}



#endif
