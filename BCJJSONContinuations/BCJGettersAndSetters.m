//
//  BCJGettersAndSetters.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 01/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJGettersAndSetters.h"
#import "BCJJSONSource.h"
#import "BCJJSONTarget.h"



#pragma mark - Get arbitary object continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJGetValue(BCJJSONSource *source, BOOL(^successBlock)(id value, NSError **outError)) {
    NSCParameterAssert(source != nil);
    NSCParameterAssert(successBlock != nil);

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
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetValue(BCJJSONTarget *target, BCJJSONSource *source) {
    NSCParameterAssert(target != nil);
    NSCParameterAssert(source != nil);

    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        id value;
        BCJSourceResult result = [source getValue:&value error:outError];
        switch (result) {
            case BCJSourceResultValueNotFound: return YES;
            case BCJSourceResultSuccess: return [target setValue:value error:outError];
            default: //This isn't necessary but I'm paranoid.
            case BCJSourceResultFailure: return NO;
        }
    });
}
