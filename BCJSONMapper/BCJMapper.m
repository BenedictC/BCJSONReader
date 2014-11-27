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
#import <BCLContinuations/BCLContinuations.h>
#import <BCLContinuations/BCLContinuationsDefines.h>



@implementation BCJMapper

#pragma mark - mapping
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



+(NSError *)mapSourceObject:(id)sourceObject intoObject:(id)targetObject options:(BCJMapperOptions)options usingContinuations:(id<BCLContinuation>)firstContinuation, ...
{
    NSArray *continuations = BCJ_CONTINUATIONS_ARRAY_FROM_VARGS(firstContinuation);

    return [self mapSourceObject:sourceObject intoObject:targetObject options:options usingContinuationsArray:continuations];
}



#pragma mark - reading
+(NSError *)readSourceObject:(id)sourceObject options:(BCJMapperOptions)options continuationsArray:(NSArray *)continuations
{
    BCJPushSourceObject(sourceObject);

    BOOL shouldAbortOnError = (options & BCJMapperOptionAbortOnError) != 0;
    NSError *error = (shouldAbortOnError) ? [BCLContinuations untilErrorWithContinuations:continuations] :  [BCLContinuations untilEndWithContinuations:continuations];

    BCJPopSourceObject();

    return error;
}



+(NSError *)readJSONObject:(NSData *)jsonData options:(BCJMapperOptions)options usingContinuations:(id<BCLContinuation>)firstContinuation, ...
{
    NSCParameterAssert(jsonData != nil);

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

    return [self readSourceObject:sourceObject options:options continuationsArray:continuations];
}



+(NSError *)readSourceObject:(id)sourceObject options:(BCJMapperOptions)options usingContinuations:(id<BCLContinuation>)firstContinuation, ...
{
    NSArray *continuations = BCJ_CONTINUATIONS_ARRAY_FROM_VARGS(firstContinuation);

    return [self readSourceObject:sourceObject options:options continuationsArray:continuations];
}



#pragma mark - object stacks
+(id)sourceObject
{
    return BCJTopSourceObject();
}



+(id)targetObject
{
    return BCJTopTargetObject();
}

@end
