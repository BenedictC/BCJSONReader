//
//  BCJMapper.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 20/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJMapper.h"
#import "BCJStackJSONSource.h"
#import "BCJStackPropertyTarget.h"
#import "BCLContinuations.h"
#import "BCLContinuationsDefines.h"



@implementation BCJMapper

+(NSError *)mapJSONData:(NSData *)jsonData intoObject:(id)targetObject options:(BCJMapperOptions)options usingContinuations:(id<BCLContinuation>)firstContinuation, ...
{
    NSCParameterAssert(jsonData != nil);
    NSCParameterAssert(targetObject != nil);

    NSJSONReadingOptions jsonOptions = NSJSONReadingAllowFragments;
    jsonOptions ^= (options & BCJMapperOptionMutipleLeaves) ? NSJSONReadingMutableLeaves : 0;
    jsonOptions ^= (options & BCJMapperOptionMutipleContainers) ? NSJSONReadingMutableContainers : 0;
    NSError *error;
    id sourceObject = [NSJSONSerialization JSONObjectWithData:jsonData options:jsonOptions error:&error];

    BOOL didDeserialize = sourceObject != nil;
    if (!didDeserialize) {
        return error;
    }

    NSArray *continuations = BCJ_CONTINUATIONS_ARRAY_FROM_VARGS(firstContinuation);

    return [self mapSourceObject:sourceObject intoObject:targetObject options:options usingContinuationsArray:continuations];
}



+(NSError *)mapSourceObject:(id)sourceObject intoObject:(id)targetObject options:(BCJMapperOptions)options usingContinuationsArray:(NSArray *)continuations
{
    NSCParameterAssert(sourceObject != nil);
    NSCParameterAssert(targetObject != nil);

    BCJPushSourceObject(sourceObject);
    BCJPushTargetObject(targetObject);

    BOOL shouldAbortOnError = (options & BCJMapperOptionAbortOnError) != 0;
    NSError *error = (shouldAbortOnError) ? [BCLContinuations untilErrorWithContinuations:continuations] :  [BCLContinuations untilEndWithContinuations:continuations];

    BCJPopSourceObject();
    BCJPopTargetObject();

    return error;

}



+(NSError *)mapSourceObject:(id)sourceObject intoObject:(id)targetObject options:(BCJMapperOptions)options usingContinuations:(id<BCLContinuation>)firstContinuation, ...
{
    NSArray *continuations = BCJ_CONTINUATIONS_ARRAY_FROM_VARGS(firstContinuation);

    return [self mapSourceObject:sourceObject intoObject:targetObject options:options usingContinuationsArray:continuations];
}



+(id)sourceObject
{
    return BCJTopSourceObject();
}



+(id)targetObject
{
    return BCJTopTargetObject();
}

@end
