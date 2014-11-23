//
//  BCJGettersAndSetters.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 01/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJGettersAndSetters.h"
#import "BCJJSONSource.h"
#import "BCJPropertyTarget.h"



#pragma mark - Get arbitary object continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJGetValue(BCJJSONSource *source, BOOL(^successBlock)(id value, NSError **outError)) {
    NSCParameterAssert(source != nil);
    NSCParameterAssert(successBlock != nil);

    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        id value;
        BCJJSONSourceResult result = [source getValue:&value error:outError];
        switch (result) {
            case BCJJSONSourceResultValueNotFound: return YES;
            case BCJJSONSourceResultSuccess: return successBlock(value, outError);
            default: //This isn't necessary but I'm paranoid.
            case BCJJSONSourceResultFailure: return NO;
        }
    });
}



#pragma mark - Set arbitary object continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetValue(BCJJSONSource *source, BCJPropertyTarget *target) {
    NSCParameterAssert(target != nil);
    NSCParameterAssert(source != nil);

    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        id value;
        BCJJSONSourceResult result = [source getValue:&value error:outError];
        switch (result) {
            case BCJJSONSourceResultValueNotFound: return YES;
            case BCJJSONSourceResultSuccess: return [target setValue:value error:outError];
            default: //This isn't necessary but I'm paranoid.
            case BCJJSONSourceResultFailure: return NO;
        }
    });
}
