//
//  BCLContinuationsClass.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 27/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCLContinuationProtocol.h"



/**
 <#Description#>
 */
extern NSString * const BCLErrorDomain;

extern NSString * const BCLDetailedErrorsKey;



enum : NSInteger {
    BCLMultipleErrorsError,
    BCLUnknownError,
};



@interface BCLContinuations : NSObject

//Synchronous execution
+(NSError *)untilEnd:(id<BCLContinuation>)firstContinuation, ... NS_REQUIRES_NIL_TERMINATION;
+(NSError *)untilError:(id<BCLContinuation>)firstContinuation, ... NS_REQUIRES_NIL_TERMINATION;

+(BOOL)withError:(NSError **)outError untilEnd:(id<BCLContinuation>)firstContinuation, ... NS_REQUIRES_NIL_TERMINATION;
+(BOOL)withError:(NSError **)outError untilError:(id<BCLContinuation>)firstContinuation, ... NS_REQUIRES_NIL_TERMINATION;

//Asynchronous execution
//TODO:

+(BCLContinuations *)currentContinuations;
-(void)abortWithError:(NSError *)errror;

@end
