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



static inline BOOL BCJIsOptionSet(NSInteger option, NSInteger options) {
    return (options & option) != 0;
}

static inline BOOL BCJMustReturnValue(BCJSourceOptions options) {
    return (options & BCJSourceOptionMustReturnValue) != 0;
}

static inline BOOL BCJPathMustEvaluateToValue(BCJSourceOptions options) {
    return (options & BCJSourceOptionPathMustEvaluateToValue) != 0;
}

static inline BOOL BCJReplaceNullWithDefaultValue(BCJSourceOptions options) {
    return (options & BCJSourceOptionReplaceNullWithDefaultValue) != 0;
}



#endif
