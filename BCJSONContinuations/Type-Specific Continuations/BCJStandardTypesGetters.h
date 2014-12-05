//
//  BCJStandardTypesGetters.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 31/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BCLContinuations/BCLContinuations.h>
#import "BCJDefines.h"

@class BCJSource;
@class BCJTarget;


id<BCLContinuation> BCJ_OVERLOADABLE BCJGetArray(BCJSource *source, BOOL(^block)(NSArray *array, NSError **outError)) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJGetMutableArray(BCJSource *source, BOOL(^block)(NSMutableArray *array, NSError **outError)) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJGetDictionary(BCJSource *source, BOOL(^block)(NSDictionary *dict, NSError **outError)) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJGetMutableDictionary(BCJSource *source, BOOL(^block)(NSMutableDictionary *dict, NSError **outError)) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJGetString(BCJSource *source, BOOL(^block)(NSString *string, NSError **outError)) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJGetMutableString(BCJSource *source, BOOL(^block)(NSMutableString *string, NSError **outError)) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJGetNumber(BCJSource *source, BOOL(^block)(NSNumber *number, NSError **outError)) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJGetNull(BCJSource *source, BOOL(^block)(NSNull *null, NSError **outError)) BCJ_REQUIRED(1,2) BCJ_WARN_UNUSED;
