//
//  BCJPropertyTarget.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 04/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJPropertyTarget+ValueIntrospection.h"

#import "BCJDefines.h"
#import "BCJError.h"



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
    //KVC will work regardless of type which means type mismatch bugs can occur. We add type checking for DEBUG builds to catch these bugs early.
    NSAssert([self canReceiveValue:value] != BCJPropertyTargetValueEligabilityStatusForbidden, @"Attempted to set an object of type <%@> to an ivar of type <%@> for key <%@> of object <%@>.", NSStringFromClass([value class]), NSStringFromClass([self expectedClass]), self.key, self.object);

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
