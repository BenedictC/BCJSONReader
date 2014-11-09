//
//  BCJJSONTarget.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 04/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJJSONTarget.h"

#import "BCJDefines.h"
#ifdef DEBUG
#import <objc/runtime.h>
#endif



@implementation BCJJSONTarget

-(instancetype)initWithObject:(id)object key:(NSString *)key;
{
    NSParameterAssert(object);
    NSParameterAssert(key);

    self = [super init];
    if (self == nil) return nil;

    _object = object;
    _key = [key copy];

    return self;
}



-(BOOL)setWithValue:(id)value outError:(NSError **)outError;
{
#ifdef DEBUG
    //KVC will work regardless of type which means type mismatch bugs can occur. We add type checking for DEBUG builds
    //to catch these bugs early.

    ^{
        //0. ensure we have a value to check
        if (value == nil) return;

        //1. Look for a *property* matching targetKey
        objc_property_t property = class_getProperty([self.object class], self.key.UTF8String);
        if (property != NULL) {
            NSString *className = ({
                NSString *propertyString = [NSString stringWithUTF8String:property_getAttributes(property)];

                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^T@\"([^\"]*)\"" options:0 error:NULL];
                NSTextCheckingResult *match = [regex firstMatchInString:propertyString options:0 range:NSMakeRange(0, [propertyString length])];
                NSRange range = [match rangeAtIndex:1];
                (match == nil) ? nil : [propertyString substringWithRange:range];
            });

            if (className != nil) {
                Class class = NSClassFromString(className);
                NSCAssert([value isKindOfClass:class], ({
                    [NSString stringWithFormat:@"Attempted to set an object of type <%@> to an ivar of type <%@> for key <%@> of object <%@>.", NSStringFromClass([value class]), NSStringFromClass(class), self.key, self.object];
                }));
                return;
            }
            //TODO: Check non-object types
        }

        //2. Look for an *ivar* matching targetKey
        unsigned int outCount;
        Ivar *ivars = class_copyIvarList([self.object class], &outCount);
        //Wrap the buffer so that it's automatically freed when we return.
        NSData *ivarsData = [NSData dataWithBytesNoCopy:ivars length:sizeof(ivars) * outCount freeWhenDone:YES];
        for (unsigned int i = 0; i < outCount; i++) {
            Ivar ivar = ivars[i];
            NSString *ivarName = [NSString stringWithFormat:@"%s", ivar_getName(ivar)];
            BOOL isMatch = ([ivarName isEqualToString:self.key]) || [ivarName isEqualToString:[@"_" stringByAppendingString:self.key]];
            if (!isMatch) continue;

            NSString *encoding = [NSString stringWithFormat:@"%s", ivar_getTypeEncoding(ivar)];
            BOOL isObject = [encoding hasPrefix:@"@"];
            if (isObject) {
                NSRange range = NSMakeRange(2, encoding.length-3);
                NSString *className = [encoding substringWithRange:range];
                Class class = NSClassFromString(className);
                NSCAssert([value isKindOfClass:class], ({
                    [NSString stringWithFormat:@"Attempted to set an object of type <%@> to an ivar of type <%@> for key <%@> of object <%@>.", NSStringFromClass([value class]), NSStringFromClass(class), self.key, self.object];
                }));
                return;
            }
            //TODO: Check non-object types
        }
        //Force the buffer to be retained until the end of the function.
        [ivarsData self];
    }();
#endif

    //If the target is nil then there's no point in continuing.
    if (self.object == nil) return YES;

    //Validate using KVC
    id validatedValue = value;
    if (![self.object validateValue:&validatedValue forKey:self.key error:outError]) {
        return NO;
    }

    //Done!
    //Note that we're using the validatedValue
    [self.object setValue:validatedValue forKey:self.key];
    return YES;
}

@end



BCJJSONTarget * BCJ_OVERLOADABLE BCJTarget(id object, NSString *key) {
    return [[BCJJSONTarget alloc] initWithObject:object key:key];
}
