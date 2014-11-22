//
//  BCJPropertyTarget+ExpectedClass.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 21/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJPropertyTarget+ExpectedClass.h"
#import <objc/runtime.h>



@implementation BCJPropertyTarget (ExpectedClass)

-(NSString *)expectedObjCType
{
    NSString *key = self.key;
    id object = self.object;

    if (object == nil) return nil;

    //1. Look for a *property* matching targetKey
    objc_property_t property = class_getProperty([object class], key.UTF8String);
    if (property != NULL) {
        NSString *propertyAttribs = @(property_getAttributes(property));
        NSRange typeRange = ({
            NSRange commaRange = [propertyAttribs rangeOfString:@","];
            (commaRange.length == NSNotFound) ? NSMakeRange(1, propertyAttribs.length-1) : NSMakeRange(1, commaRange.location-1);
        });

        return [propertyAttribs substringWithRange:typeRange];
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
        if (isMatch) {
            return @(ivar_getTypeEncoding(ivar));
        }
    }

    //Force the buffer to be retained until the end of the function. We do this rather than free() so that if we return early we don't acciendently leak.
    [ivarsData self];
    return nil;
}



-(Class)expectedClass
{
#warning TODO:
    return [NSValue class];
}



-(BOOL)canReceiveValue:(id)value
{
#warning TODO:
    //    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^T@\"([^\"]*)\"" options:0 error:NULL];
    //    NSTextCheckingResult *match = [regex firstMatchInString:propertyString options:0 range:NSMakeRange(0, [propertyString length])];
    //    NSRange range = [match rangeAtIndex:1];
    //    (match == nil) ? nil : [propertyString substringWithRange:range];

    return YES;
}

@end
