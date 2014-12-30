//
//  BCJPropertyContinuations.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 21/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <BCLContinuations/BCLContinuationProtocol.h>
#import "BCJDefines.h"
#import "BCJSourceConstants.h"
#import "BCJMapOptions.h"

@class BCJSource;
@class BCJTarget;



#pragma mark - Property Continuations
/**
 @param jsonPath     <#jsonPath description#>
 @param propertyKey  <#propertyKey description#>

 @return <#return value description#>
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetProperty(BCJSource *source, BCJTarget *target) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;

/**
 <#Description#>

 @param sourceJsonPath    <#sourceJsonPath description#>
 @param targetPropertyKey <#targetPropertyKey description#>

 @return <#return value description#>
 */
#define BCJ_SET(sourceJsonPath, targetPropertyKey) BCJSetProperty(BCJCreateSource(sourceJsonPath), BCJCreateTarget(BCJ_KEY(targetPropertyKey)))
