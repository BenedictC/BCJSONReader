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
 Checks if BCJJSONSourceOptionMustReturnValue has been set.

 @param options the options to check.

 @return YES if options contains BCJJSONSourceOptionMustReturnValue, other wise NO.
 */
static inline BOOL BCJTreatValueNotFoundAsSuccess(BCJJSONSourceOptions options) {
    return (options & BCJJSONSourceOptionTreatValueNotFoundAsSuccess) != 0;
}

/**
 Checks if BCJJSONSourceOptionPathMustEvaluateToValue has been set.

 @param options the options to check.

 @return YES if options contains BCJJSONSourceOptionPathMustEvaluateToValue, other wise NO.
 */
static inline BOOL BCJPathMustEvaluateToValue(BCJJSONSourceOptions options) {
    return (options & BCJJSONSourceOptionPathMustEvaluateToValue) != 0;
}

/**
 Checks if BCJJSONSourceOptionReplaceNullWithDefaultValue has been set.

 @param options the options to check.

 @return YES if options contains BCJJSONSourceOptionReplaceNullWithDefaultValue, other wise NO.
 */
static inline BOOL BCJReplaceNullWithNil(BCJJSONSourceOptions options) {
    return (options & BCJJSONSourceOptionReplaceNullWithNil) != 0;
}



#endif
