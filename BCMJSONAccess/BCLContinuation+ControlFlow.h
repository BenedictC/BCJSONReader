//
//  BCLContinuation+ControlFlow.h
//  BCMJSONAccess
//
//  Created by Benedict Cohen on 27/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface BCLContinuation : NSObject

+(NSArray *)untilEnd:(id<BCLContinuation>)firstContinuations, ... NS_REQUIRES_NIL_TERMINATION;
+(NSError *)untilError:(id<BCLContinuation>)firstContinuations, ... NS_REQUIRES_NIL_TERMINATION;

@end
