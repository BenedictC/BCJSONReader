//
//  BCJMapper.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 20/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <BCLContinuations/BCLContinuations.h>

#import "BCJConstants.h"
#import "BCJDefines.h"



typedef NS_OPTIONS(NSUInteger, BCJMapperOptions) {
    BCJMapperOptionAbortOnError = (1UL << 0),
    BCJMapperOptionMutipleLeaves = (1UL << 1),
    BCJMapperOptionMutipleContainers = (1UL << 2),
};


/**
 BCJMapper allows JSON data to be mapped to objects. The mappings are performed by the supplied continuations. 

 BCJContinuations require a BCJSource and an optional BCJTarget which are created by BCJCreateSource and BCJCreateTarget.
 
 BCJMapper manages a per-thread stack for source objects and target objects.  BCJMapper provides additional overloaded BCJCreateSource and BCJCreateTarget which uses the top object of these stack.s 

 */
@interface BCJMapper : NSObject

+(NSError *)mapJSONData:(NSData *)jsonData intoObject:(id)targetObject options:(BCJMapperOptions)options usingContinuations:(id<BCLContinuation>)firstContinuation, ... BCJ_REQUIRED(1,2);

+(NSError *)mapSourceObject:(id)sourceObject intoObject:(id)targetObject options:(BCJMapperOptions)options usingContinuations:(id<BCLContinuation>)firstContinuation, ... BCJ_REQUIRED(1,2);

+(NSError *)readJSONData:(NSData *)jsonData options:(BCJMapperOptions)options usingContinuations:(id<BCLContinuation>)firstContinuation, ... BCJ_REQUIRED(1);

+(NSError *)readSourceObject:(id)sourceObject options:(BCJMapperOptions)options usingContinuations:(id<BCLContinuation>)firstContinuation, ... BCJ_REQUIRED(1);

//Source and target object stacks access.
+(id)sourceObject;
+(id)targetObject;

@end
