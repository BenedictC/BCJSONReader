//
//  BCJPropertyTarget.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 04/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCJDefines.h"



/**
 BCJPropertyTarget encapsulates the setting of an instance property using KVC. setValue:error: first performs validation with validateValue:forKey:error: and if successful sets the value using setValue:forKey:.
 
 DEBUG builds perform an additional type check to ensure that the property being assigned to is of the correct type. If there's a type mismatch then an exception is raised.

 */
@interface BCJPropertyTarget : NSObject

/**
 Creates an instance of BCJPropertyTarget. BCJTarget constructor function should be used in favour of this method.

 @param object The object to set the value on.
 @param key    The key of the property to set.

 @return an instance of BCJPropertyTarget.
 */
-(instancetype)initWithObject:(id)object key:(NSString *)key;
/**
 The object that the value will be set on.
 */
@property(nonatomic, readonly) id object;
/**
 The key of the property to set.
 */
@property(nonatomic, readonly) NSString *key;

/**
 Sets the value of object to value.

 @param value    The value to set.
 @param outError On failure contains an NSError describing the failure reason.

 @return YES on success, otherwise NO.
 */
-(BOOL)setValue:(id)value error:(NSError **)outError;

@end



BCJPropertyTarget * BCJ_OVERLOADABLE BCJTarget(id object, NSString *key) BCJ_WARN_UNUSED BCJ_REQUIRED(1,2);
