//
//  BCJPropertyTarget+ExpectedClass.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 21/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJPropertyTarget.h"



@interface BCJPropertyTarget (ExpectedClass)

-(NSString *)expectedObjCType;

-(Class)expectedClass;

-(BOOL)canReceiveValue:(id)value;

@end
