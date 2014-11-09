//
//  BCJJSONTarget.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 04/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCJDefines.h"



@interface BCJJSONTarget : NSObject

-(instancetype)initWithObject:(id)object key:(NSString *)key;

@property(nonatomic, readonly) id object;
@property(nonatomic, readonly) NSString *key;

-(BOOL)setWithValue:(id)value outError:(NSError **)outError;

@end



BCJJSONTarget * BCJ_OVERLOADABLE BCJTarget(id object, NSString *key) BCJ_WARN_UNUSED BCJ_REQUIRED(1,2);



#ifdef DEBUG
#define BCJ_KEY(NAME) NSStringFromSelector(@selector(NAME))
#else
#define BCJ_KEY(NAME) @"" #NAME
#endif

#define BCJ_TARGET(OBJECT, KEY) BCJTarget(OBJECT, BCJ_KEY(KEY))
