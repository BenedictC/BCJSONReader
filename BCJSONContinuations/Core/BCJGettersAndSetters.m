//
//  BCJGettersAndSetters.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 01/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJGettersAndSetters.h"
#import "BCJSource.h"
#import "BCJTarget.h"
#import "BCJError.h"



#pragma mark - Get arbitary object continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJGetValue(BCJSource *source, BOOL(^successBlock)(id value, NSError **outError)) {
    BCJParameterExpectation(source != nil);
    BCJParameterExpectation(successBlock != nil);

    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        id value;
        BCJSourceResult result = [source getValue:&value error:outError];
        switch (result) {
            case BCJSourceResultValueNotFound: return YES;
            case BCJSourceResultSuccess: return successBlock(value, outError);
            default: //This isn't necessary but I'm paranoid.
            case BCJSourceResultFailure: return NO;
        }
    });
}



#pragma mark - Set arbitary object continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetValue(BCJSource *source, BCJTarget *target) {
    BCJParameterExpectation(target != nil);
    BCJParameterExpectation(source != nil);


    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        BCJWarnIfPossibleToSetScalarPropertyToNil(source, target);
        
        id value;
        BCJSourceResult result = [source getValue:&value error:outError];
        switch (result) {
            case BCJSourceResultValueNotFound:
                return YES;

            case BCJSourceResultSuccess:
                return [target setValue:value error:outError];

            case BCJSourceResultFailure:
                return NO;
        }
    });
}
