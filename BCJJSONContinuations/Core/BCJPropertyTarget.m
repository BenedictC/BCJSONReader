//
//  BCJPropertyTarget.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 04/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJPropertyTarget.h"

#import "BCJDefines.h"
#import "BCJError.h"


#ifdef DEBUG
#import <objc/runtime.h>


/**
 //KVC will work regardless of type which means type mismatch bugs can occur. We add type checking for DEBUG builds
 //to catch these bugs early.

 @param object The object that will receive the value.
 @param key    The KVC key for the value to be set.
 @param value  The value to set.

 */
static inline void assertKVCTargetWillAcceptValue(id object, NSString *key, id value) {

    //0. ensure we have a value to check
    if (value == nil) return;

    //1. Look for a *property* matching targetKey
    objc_property_t property = class_getProperty([object class], key.UTF8String);
    if (property != NULL) {
        NSString *className = ({
            NSString *propertyString = [NSString stringWithUTF8String:property_getAttributes(property)];

            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^T@\"([^\"]*)\"" options:0 error:NULL];
            NSTextCheckingResult *match = [regex firstMatchInString:propertyString options:0 range:NSMakeRange(0, [propertyString length])];
            NSRange range = [match rangeAtIndex:1];
            (match == nil) ? nil : [propertyString substringWithRange:range];
        });

        if (className != nil) {
#warning TODO: I seems incorrect that this fails when, for example, attempting to set a string property to a dict
            Class class = NSClassFromString(className);
            NSCAssert([value isKindOfClass:class], ({
                [NSString stringWithFormat:@"Attempted to set an object of type <%@> to an ivar of type <%@> for key <%@> of object <%@>.", NSStringFromClass([value class]), NSStringFromClass(class), key, object];
            }));
            return;
        }
        //TODO: Check NSValue.objCType types
    }

    //2. Look for an *ivar* matching targetKey
    unsigned int outCount;
    Ivar *ivars = class_copyIvarList([object class], &outCount);
    //Wrap the buffer so that it's automatically freed when we return.
    NSData *ivarsData = [NSData dataWithBytesNoCopy:ivars length:sizeof(ivars) * outCount freeWhenDone:YES];
    for (unsigned int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        NSString *ivarName = [NSString stringWithFormat:@"%s", ivar_getName(ivar)];
        BOOL isMatch = ([ivarName isEqualToString:key]) || [ivarName isEqualToString:[@"_" stringByAppendingString:key]];
        if (!isMatch) continue;

        NSString *encoding = [NSString stringWithFormat:@"%s", ivar_getTypeEncoding(ivar)];
        BOOL isObject = [encoding hasPrefix:@"@"];
        if (isObject) {
            NSRange range = NSMakeRange(2, encoding.length-3);
            NSString *className = [encoding substringWithRange:range];
            Class class = NSClassFromString(className);
            NSCAssert([value isKindOfClass:class], ({
                [NSString stringWithFormat:@"Attempted to set an object of type <%@> to an ivar of type <%@> for key <%@> of object <%@>.", NSStringFromClass([value class]), NSStringFromClass(class), key, object];
            }));
            return;
        }
        //TODO: Check NSValue.objCType types
    }
    [ivarsData self]; //Force the buffer to be retained until the end of the function. We do this rather than free() so that if we return early we don't acciendently leak.

}

#else

static inline void assertKVCTargetWillAcceptValue(id object, NSString *key, id value) {
    //Do nothing in release builds.
}

#endif



@implementation BCJPropertyTarget

-(instancetype)init
{
    return [self initWithObject:nil key:nil];
}



-(instancetype)initWithObject:(id)object key:(NSString *)key;
{
    NSParameterAssert(object != nil);
    NSParameterAssert(key != nil && key.length > 0);

    self = [super init];
    if (self == nil) return nil;

    _object = object;
    _key = [key copy];

    return self;
}



-(BOOL)setValue:(id)value error:(NSError **)outError;
{
    assertKVCTargetWillAcceptValue(self.object, self.key, value);

    //Validate using KVC
    id validatedValue = value;
    if (![self.object validateValue:&validatedValue forKey:self.key error:outError]) {
        //We don't need to populate outError because validateValue:forKey:error: has already done so.
        return NO;
    }

    //Note that we're using the validatedValue
    [self.object setValue:validatedValue forKey:self.key];
    return YES;
}

@end



BCJPropertyTarget * BCJ_OVERLOADABLE BCJTarget(id object, NSString *key) {
    return [[BCJPropertyTarget alloc] initWithObject:object key:key];
}
