//
//  BCJMapperClass.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 20/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLContinuationProtocol.h"



typedef NS_OPTIONS(NSUInteger, BCJMapperOptions) {
    BCJMapperOptionAbortOnError = (1UL << 0),
    BCJMapperOptionMutipleLeaves = (1UL << 1),
    BCJMapperOptionMutipleContainers = (1UL << 2),
};



@interface BCJMapper : NSObject

+(NSError *)mapJSONData:(NSData *)jsonData intoObject:(id)targetObject options:(BCJMapperOptions)options usingContinuations:(id<BCLContinuation>)firstContinuation, ...;

+(NSError *)mapSourceObject:(id)sourceObject intoObject:(id)targetObject options:(BCJMapperOptions)options usingContinuations:(id<BCLContinuation>)firstContinuation, ...;

//Source and target object stacks access.
+(id)sourceObject;
+(id)targetObject;

@end
