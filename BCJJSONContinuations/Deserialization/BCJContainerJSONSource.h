//
//  BCJContainerJSONSource.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 21/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#ifndef BCJContainer_h_
#define BCJContainer_h_

#import "BCJDefines.h"
#import "BCJContainerProtocol.h"
#import "BCJJSONSourceConstants.h"

@class BCJJSONSource;



#pragma mark - Strict Constructors
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> objectContainer, NSString *JSONPath, Class expectClass, BCJJSONSourceOptions options, id defaultValue) BCJ_REQUIRED(1,2);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> objectContainer, NSUInteger idx,     Class expectClass, BCJJSONSourceOptions options, id defaultValue) BCJ_REQUIRED(1);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> objectContainer, NSString *JSONPath, Class expectClass, BCJJSONSourceOptions options) BCJ_REQUIRED(1,2);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> objectContainer, NSUInteger idx,     Class expectClass, BCJJSONSourceOptions options) BCJ_REQUIRED(1);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> objectContainer, NSString *JSONPath, Class expectClass) BCJ_REQUIRED(1,2);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> objectContainer, NSUInteger idx,     Class expectClass) BCJ_REQUIRED(1);

#pragma mark - Constructors with nil expectClass
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> objectContainer, NSString *JSONPath, BCJJSONSourceOptions options, id defaultValue) BCJ_REQUIRED(1,2);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> objectContainer, NSUInteger idx,     BCJJSONSourceOptions options, id defaultValue) BCJ_REQUIRED(1);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> objectContainer, NSString *JSONPath, BCJJSONSourceOptions options) BCJ_REQUIRED(1,2);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> objectContainer, NSUInteger idx,     BCJJSONSourceOptions options) BCJ_REQUIRED(1);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> objectContainer, NSString *JSONPath) BCJ_REQUIRED(1,2);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> objectContainer, NSUInteger idx)     BCJ_REQUIRED(1);



#endif
