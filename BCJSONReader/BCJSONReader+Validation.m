//
//  BCJReader+Validation.m
//  BCJSONReader
//
//  Created by Benedict Cohen on 05/01/2015.
//  Copyright (c) 2015 Benedict Cohen. All rights reserved.
//

#import "BCJSONReader.h"
#import "BCJError.h"



@implementation BCJSONReader (Validation)

-(NSError *)assertObject:(id)object isKindOfClass:(Class)class
{
    NSParameterAssert(class);

    if (object == nil) return nil;
    if ([object isKindOfClass:class]) return nil;

    NSError *error = [BCJError invalidValueErrorWithJSONPath:nil value:object criteria:[NSString stringWithFormat:@"is kind of class <%@>", NSStringFromClass(class)]];
    [self addError:error];

    return error;
}



-(NSError *)assertPredicate:(NSPredicate *)predicate
{
    BOOL didPass = [predicate evaluateWithObject:nil];
    if (didPass) return nil;

    NSError *error = [BCJError invalidValueErrorWithJSONPath:nil value:nil criteria:predicate.predicateFormat];
    [self addError:error];

    return error;
}



-(NSError *)assertPredicateWithFormat:(NSString *)predicateFormat, ...
{
    va_list list;
    va_start(list, predicateFormat);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat arguments:list];
    va_end(list);

    return [self assertPredicate:predicate];
}

@end
