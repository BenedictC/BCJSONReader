//
//  BCLContinuation+ControlFlow+Protected.h
//  BCMJSONAccess
//
//  Created by Benedict Cohen on 30/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLContinuation+ControlFlow.h"



@interface BCLContinuation (Protected)

+(NSError *)untilEndWithContinuations:(NSArray *)continuations;
+(NSError *)untilErrorWithContinuations:(NSArray *)continuations;

@end
