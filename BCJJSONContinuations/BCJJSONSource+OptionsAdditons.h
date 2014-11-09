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

static inline BOOL BCJShouldReplaceNullWithNil(BCJSourceOptions options) {
    return (options & BCJSourceOptionReplaceNullWithNil) != 0;
}

static inline BOOL BCJShouldReplaceNilWithDefaultValue(BCJSourceOptions options) {
    return (options & BCJSourceOptionReplaceNilWithDefaultValue) != 0;
}

static inline BOOL BCJShouldAllowNilValue(BCJSourceOptions options) {
    return (options & BCJSourceOptionAllowsNilValue) != 0;
}



#endif
