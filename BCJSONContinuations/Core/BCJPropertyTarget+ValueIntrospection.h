//
//  BCJPropertyTarget+ValueIntrospection.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 21/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJPropertyTarget.h"


typedef NS_ENUM(NSUInteger, BCJPropertyTargetValueEligabilityStatus) {
    BCJPropertyTargetValueEligabilityStatusForbidden,
    BCJPropertyTargetValueEligabilityStatusPermitted,
    BCJPropertyTargetValueEligabilityStatusUnknown,
};



@interface BCJPropertyTarget (ValueIntrospection)

-(BCJPropertyTargetValueEligabilityStatus)canReceiveValue:(id)value;

-(Class)expectedClass;

@end
