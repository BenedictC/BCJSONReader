//
//  BCJTarget.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 04/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJTarget+ValueIntrospection.h"

#import "BCJDefines.h"
#import "BCJError.h"



@implementation BCJTarget

-(instancetype)init
{
    return [self initWithObject:nil keyPath:nil];
}



-(instancetype)initWithObject:(id)object keyPath:(NSString *)keyPath;
{
    BCJParameterExpectation(object != nil);
    BCJParameterExpectation(keyPath != nil && keyPath.length > 0);

    self = [super init];
    if (self == nil) return nil;

    _object = object;
    _keyPath = [keyPath copy];

    return self;
}



-(NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> keyPath = '%@', object = %@", NSStringFromClass(self.class), self, self.keyPath, self.object];
}



-(BOOL)setValue:(id)value error:(NSError **)outError;
{
    //KVC will work regardless of type which means type mismatch bugs can occur.
    //Note that this is an NSAssert and not an BCJExpectation, therefore this will not crash non-DEBUG builds.
    NSAssert([self canReceiveValue:value] != BCJTargetValueEligabilityStatusForbidden, @"Attempted to set an object of type <%@> to an ivar of type <%@> for key <%@> of object <%@>.", NSStringFromClass([value class]), NSStringFromClass([self expectedClass]), self.key, self.object);

    //Validate using KVC
    id validatedValue = value;
    if (![self.object validateValue:&validatedValue forKeyPath:self.keyPath error:outError]) {
        //We don't need to populate outError because validateValue:forKey:error: has already done so.
        return NO;
    }

    //Note that we're using the validatedValue
    [self.object setValue:validatedValue forKeyPath:self.keyPath];
    return YES;
}

@end



BCJTarget * BCJ_OVERLOADABLE BCJCreateTarget(id object, NSString *keyPath) {
    return [[BCJTarget alloc] initWithObject:object keyPath:keyPath];
}
