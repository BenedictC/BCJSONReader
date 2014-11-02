//
//  BCLContinuation+ControlFlow.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 27/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

@import Foundation;



extern NSString * const BCLErrorDomain;

extern NSString * const BCLDetailedErrorsKey;



enum : NSInteger {
    BCLMultipleErrorsError,
    BCLUnknownError,
};



@interface BCLContinuation : NSObject

+(NSError *)untilEnd:(id<BCLContinuation>)firstContinuations, ... NS_REQUIRES_NIL_TERMINATION;
+(NSError *)untilError:(id<BCLContinuation>)firstContinuations, ... NS_REQUIRES_NIL_TERMINATION;

+(BCLContinuation *)currentContinuation;
-(void)abortWithError:(NSError *)errror;

@end
