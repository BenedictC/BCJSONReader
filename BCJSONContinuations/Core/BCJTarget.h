//
//  BCJTarget.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 04/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCJDefines.h"



/**
 <#Description#>
 */
@interface BCJTarget : NSObject

/**
 Sets the value of object to value.

 @param value    The value to set.
 @param outError On failure contains an NSError describing the failure reason.

 @return YES on success, otherwise NO.
 */
-(BOOL)setValue:(id)value error:(NSError **)outError;

@end



/**
 BCJKeyPathTarget encapsulates the setting of an instance property using KVC. setValue:error: first performs validation with validateValue:forKey:error: and if successful sets the value using setValue:forKey:.

 DEBUG builds perform an additional type check to ensure that the property being assigned to is of the correct type. If there's a type mismatch then an exception is raised.

 */
@interface BCJKeyPathTarget : BCJTarget
/**
 Creates an instance of BCJTarget. BCJTarget constructor function should be used in favour of this method.

 @param object The object to set the value on.
 @param key    The key of the property to set.

 @return an instance of BCJTarget.
 */
-(instancetype)initWithObject:(id)object keyPath:(NSString *)keyPath;
/**
 The object that the value will be set on.
 */
@property(nonatomic, readonly) id object;
/**
 The key of the property to set.
 */
@property(nonatomic, readonly) NSString *keyPath;

@end



BCJTarget * BCJ_OVERLOADABLE BCJCreateTarget(id object, NSString *keyPath) BCJ_WARN_UNUSED BCJ_REQUIRED(1,2);



#pragma mark - Convienince marco
#define BCJ_T(...) BCJCreateTarget(__VA_ARGS__)



/**
 <#Description#>
 */
@interface BCJPointerTarget : BCJTarget

-(instancetype)initWithObjectPointer:(id __strong *)objectPointer;

@property(nonatomic, readonly) id __strong * objectPointer;

@end



BCJTarget * BCJ_OVERLOADABLE BCJCreateTarget(id __strong * pointer) BCJ_WARN_UNUSED BCJ_REQUIRED(1);


