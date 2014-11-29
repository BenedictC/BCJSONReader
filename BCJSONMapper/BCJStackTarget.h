//
//  BCJStackTarget.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 21/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCJDefines.h"

@class BCJTarget;



#pragma mark - Target pushing/popping
void BCJPushTargetObject(id targetObject) BCJ_REQUIRED(1);
id BCJTopTargetObject(void);
void BCJPopTargetObject(void);



BCJTarget * BCJ_OVERLOADABLE BCJCreateTarget(NSString *key) BCJ_WARN_UNUSED BCJ_REQUIRED(1);
