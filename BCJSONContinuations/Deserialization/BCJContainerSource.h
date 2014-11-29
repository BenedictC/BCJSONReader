//
//  BCJContainerSource.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 21/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#ifndef BCJContainer_h_
#define BCJContainer_h_

#import "BCJDefines.h"
#import "BCJContainerProtocol.h"
#import "BCJSourceConstants.h"

@class BCJSource;



#pragma mark - Constructors
BCJSource * BCJ_OVERLOADABLE BCJCreateSource(id<BCJContainer> objectContainer, NSString *JSONPath, Class expectClass, BCJSourceOptions options, id defaultValue) BCJ_REQUIRED(1,2);
BCJSource * BCJ_OVERLOADABLE BCJCreateSource(id<BCJContainer> objectContainer, NSString *JSONPath, BCJSourceOptions options, id defaultValue) BCJ_REQUIRED(1,2);
BCJSource * BCJ_OVERLOADABLE BCJCreateSource(id<BCJContainer> objectContainer, NSString *JSONPath, BCJSourceOptions options) BCJ_REQUIRED(1,2);
BCJSource * BCJ_OVERLOADABLE BCJCreateSource(id<BCJContainer> objectContainer, NSString *JSONPath) BCJ_REQUIRED(1,2);



#endif
