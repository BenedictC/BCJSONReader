//
//  BCJTarget+ValueIntrospection.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 21/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJTarget.h"


typedef NS_ENUM(NSUInteger, BCJTargetValueEligabilityStatus) {
    BCJTargetValueEligabilityStatusForbidden,
    BCJTargetValueEligabilityStatusPermitted,
    BCJTargetValueEligabilityStatusUnknown,
};



@interface BCJTarget (ValueIntrospection)

-(id)receiver;
-(NSString *)key;

-(BCJTargetValueEligabilityStatus)canReceiveValue:(id)value;

-(Class)expectedClass;

@end
