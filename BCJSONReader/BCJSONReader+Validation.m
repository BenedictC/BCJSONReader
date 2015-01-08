//
//  BCJReader+Validation.m
//  BCJSONReader
//
//  Created by Benedict Cohen on 05/01/2015.
//  Copyright (c) 2015 Benedict Cohen. All rights reserved.
//

#import "BCJSONReader.h"
#import "BCJError.h"
#import "BCJValidationProxy.h"



@implementation BCJSONReader (Validation)

-(BOOL)assertObject:(id)object isKindOfClass:(Class)class
{
    BCJParameterExpectation(class);

    if (object == nil) return YES;
    if ([object isKindOfClass:class]) return YES;

    NSError *error = [BCJError invalidValueErrorWithJSONPath:nil value:object criteria:[NSString stringWithFormat:@"is kind of class <%@>", NSStringFromClass(class)]];
    [self addError:error];

    return NO;
}



-(BOOL)assertPredicate:(NSPredicate *)predicate
{
    BCJValidationProxy *proxy = [BCJValidationProxy proxyWithObject:self.object];
    BOOL didPass = [predicate evaluateWithObject:proxy];
    if (didPass) return YES;

    NSError *error = [BCJError invalidValueErrorWithJSONPath:nil value:nil criteria:predicate.predicateFormat];
    [self addError:error];

    return NO;
}



-(BOOL)assertPredicateWithFormat:(NSString *)predicateFormat, ...
{
    va_list list;
    va_start(list, predicateFormat);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat arguments:list];
    va_end(list);

    return [self assertPredicate:predicate];
}

@end
