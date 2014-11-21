//
//  BCJStackPropertyTarget.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 21/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCJDefines.h"

@class BCJPropertyTarget;



#pragma mark - Target pushing/popping
void BCJPushTargetObject(id targetObject) BCJ_REQUIRED(1);
id BCJTopTargetObject(void);
void BCJPopTargetObject(void);



BCJPropertyTarget * BCJ_OVERLOADABLE BCJTarget(NSString *key) BCJ_WARN_UNUSED BCJ_REQUIRED(1);
