//
//  BCJTarget+ValueIntrospection.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 21/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJTarget+ValueIntrospection.h"
#import "BCJError.h"
#import <objc/runtime.h>



@implementation BCJTarget (ValueIntrospection)

-(BCJKeyPathTarget *)keyPathTarget
{
    id target = [self isKindOfClass:[BCJKeyPathTarget class]] ? self : nil;
    return target;
}



-(id)receiver
{
    BCJKeyPathTarget *target = self.keyPathTarget;
    if (target == nil)  return nil;

    NSString *fullKeyPath = target.keyPath;
    NSRange lastDotRange = [fullKeyPath rangeOfString:@"." options:NSBackwardsSearch];
    if (lastDotRange.location == NSNotFound) {
        return target.object;
    }

    NSString *croppedKeyPath = [fullKeyPath substringToIndex:lastDotRange.location];
    return [target.object valueForKeyPath:croppedKeyPath];
}



-(NSString *)key
{
    BCJKeyPathTarget *target = self.keyPathTarget;
    if (target == nil)  return nil;

    NSString *keyPath = target.keyPath;
    NSRange lastDotRange = [keyPath rangeOfString:@"." options:NSBackwardsSearch];

    return (lastDotRange.location == NSNotFound) ? keyPath : [keyPath substringFromIndex:1 + lastDotRange.location];
}



-(NSString *)expectedObjCType
{
    NSString *key = self.key;
    id class = [self.receiver class];

    if (class == nil) return nil;

    NSString *titleCaseKey = ({
        NSString *head = [[key substringToIndex:1] uppercaseString];
        NSString *tail = [key substringFromIndex:1];
        [head stringByAppendingString:tail];
    });

    //from "Accessor Search Implementation Details"
    //> 1. The receiver’s class is searched for an accessor method whose name matches the pattern set<Key>:.
    //The type information is not stored for the setter method so we have to look for a property which does store the information.
    objc_property_t property = class_getProperty(class, key.UTF8String);
    if (property != NULL) {
        NSString *attribs = @(property_getAttributes(property));
        NSRange commaRange = [attribs rangeOfString:@","];
        NSRange typeInfoRange = NSMakeRange(1, commaRange.location-1);
        NSString *typeInfo = [attribs substringWithRange:typeInfoRange];
        return typeInfo;
    }

    //from "Accessor Search Implementation Details"    
    //> 2. If no accessor is found, and the receiver’s class method accessInstanceVariablesDirectly returns YES,
    if (![class accessInstanceVariablesDirectly]) {
        return nil;
    }

    __block NSString *expectedType = nil;
    BOOL (^setExpectedTypeForIvar)(NSString *) = ^BOOL(NSString *ivarName){
        Ivar ivar = class_getInstanceVariable(class, [ivarName UTF8String]);
        if (ivar == NULL)  return NO;

        expectedType =  @(ivar_getTypeEncoding(ivar));
        return YES;
    };

    //> the receiver is searched for an instance variable whose name matches the pattern _<key>,
    if (setExpectedTypeForIvar([NSString stringWithFormat:@"_%@", key])) return expectedType;

    //> _is<Key>,
    if (setExpectedTypeForIvar([NSString stringWithFormat:@"_is%@", titleCaseKey])) return expectedType;

    //> <key>,
    if (setExpectedTypeForIvar(key)) return expectedType;

    //> or is<Key>, in that order.
    if (setExpectedTypeForIvar([NSString stringWithFormat:@"is%@", titleCaseKey])) return expectedType;

    return nil;
}



-(Class)expectedClass
{
    NSString *expectedObjCType = [self expectedObjCType];
    BOOL isObject = [expectedObjCType hasPrefix:@"@"];
    if (!isObject) return nil;
    NSRange openQuoteRange = [expectedObjCType rangeOfString:@"\""];

    if (openQuoteRange.location == NSNotFound) return Nil;

    NSRange closeQuoteRange = [expectedObjCType rangeOfString:@"\"" options:NSBackwardsSearch];
    if (closeQuoteRange.location == NSNotFound) return Nil;

    NSInteger length = (closeQuoteRange.location - openQuoteRange.location) - 1;
    if (length < 1) return Nil;

    NSRange classNameRange = NSMakeRange(openQuoteRange.location + 1, length);

    NSString *className = [expectedObjCType substringWithRange:classNameRange];

    return NSClassFromString(className);
}



-(BCJTargetValueEligabilityStatus)canReceiveValue:(id)value
{
    if (value == nil) return BCJTargetValueEligabilityStatusPermitted;

    //class checking
    Class expectedClass = self.expectedClass;
    if (expectedClass == Nil) return BCJTargetValueEligabilityStatusUnknown;
    if ([value isKindOfClass:expectedClass]) return BCJTargetValueEligabilityStatusPermitted;

    //Special case for NSValue
    BOOL shouldCompareScalarType = (expectedClass == Nil) && [value isKindOfClass:NSValue.class];
    if (shouldCompareScalarType && [self canReceiveScalarValue:value]) return BCJTargetValueEligabilityStatusPermitted;

    return BCJTargetValueEligabilityStatusForbidden;
}



-(BOOL)canReceiveScalarValue:(NSValue *)value
{
    BCJParameterExpectation(value != nil);

    NSString *expected = [self expectedObjCType];
    if (expected == nil) return YES;

    NSString *actual = @(value.objCType);

    //Check for exact matches
    if ([actual isEqualToString:expected]) return YES;

    static dispatch_once_t onceToken;
    static NSDictionary *perimissableTypesByType = nil;
    dispatch_once(&onceToken, ^{
        perimissableTypesByType = @{
#define T(type) @(@encode(type))
#define S(...) [NSSet setWithObjects:__VA_ARGS__, nil]

      //This type:          | can fully represent these types:
      T(_Bool)              : S(T(_Bool)),
      T(char)               : S(T(_Bool), T(char)),
      T(short)              : S(T(_Bool), T(char), T(short), T(unsigned char)),
      T(int)                : S(T(_Bool), T(char), T(short), T(int), T(unsigned char), T(unsigned short)),
      T(long)               : S(T(_Bool), T(char), T(short), T(int), T(long), T(unsigned char), T(unsigned short)),
      T(long long)          : S(T(_Bool), T(char), T(short), T(int), T(long), T(long long), T(unsigned char), T(unsigned short), T(unsigned int), T(unsigned long)),

      T(unsigned char)      : S(T(_Bool)),
      T(unsigned short)     : S(T(_Bool), T(char), T(unsigned char)),
      T(unsigned int)       : S(T(_Bool), T(char), T(short), T(unsigned char), T(unsigned short)),
      T(unsigned long)      : S(T(_Bool), T(char), T(short), T(unsigned char), T(unsigned short), T(unsigned int)),
      T(unsigned long long) : S(T(_Bool), T(char), T(short), T(int), T(long), T(unsigned char), T(unsigned short), T(unsigned int), T(unsigned long)),

      //
      T(float)              : S(T(_Bool), T(char), T(short), /*T(int), T(long), T(long long), */ T(unsigned char), T(unsigned short)/*, T(unsigned int), T(unsigned long), T(unsigned long long)*/),
      T(double)             : S(T(_Bool), T(char), T(short), /*T(int), T(long), T(long long), */ T(unsigned char), T(unsigned short), /*T(unsigned int), T(unsigned long), T(unsigned long long),*/ T(float)),
#undef T
#undef S
                                          };

    });
    NSSet *perimissableTypes = perimissableTypesByType[expected];
    //If we can't strictly say no then assume it is compatible
    if (perimissableTypes == nil) return YES;

    return [perimissableTypes containsObject:actual];
}

@end
