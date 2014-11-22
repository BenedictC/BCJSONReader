//
//  BCJJSONSource.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 04/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJJSONSource.h"
#import "BCJEnumerateJSONPathComponents.h"
#import "BCJLogging.h"
#import "BCJError.h"



#pragma mark - options
static inline BOOL BCJTreatValueNotFoundAsSuccess(BCJJSONSourceOptions options) {
    return (options & BCJJSONSourceOptionTreatValueNotFoundAsSuccess) != 0;
}



static inline BOOL BCJPathMustEvaluateToValue(BCJJSONSourceOptions options) {
    return (options & BCJJSONSourceOptionPathMustEvaluateToValue) != 0;
}



static inline BOOL BCJReplaceNullWithNil(BCJJSONSourceOptions options) {
    return (options & BCJJSONSourceOptionReplaceNullWithNil) != 0;
}



#pragma mark - Asserts/Logging
static inline void BCJAssertValidGetterOptions(id object, NSString *JSONPath, Class expectedClass, BCJJSONSourceOptions options, id defaultValue) {
    NSCParameterAssert(object != nil);

    NSCParameterAssert(JSONPath != nil);
    NSCParameterAssert(JSONPath.length > 0);
    NSError *pathError = BCJEnumerateJSONPathComponents(JSONPath, ^(id component, NSUInteger idx, BOOL *stop) {});
    NSCAssert(pathError == nil, @"Invalid JSONPath: %@", pathError);

    NSCAssert(expectedClass == Nil || defaultValue == nil || [defaultValue isKindOfClass:expectedClass], @"Conflicting arguments: defaultValue is invalid as it is not of type expectedClass.");

#pragma message "TODO: Check options are valid"
}



static inline void BCJLogSuspiciousArguments(id object, NSString *JSONPath, Class expectedClass, BCJJSONSourceOptions options, id defaultValue) {
#pragma message "TODO: Add logging"
//    BOOL shouldReplaceNilWithDefaultValue = BCJShouldReplaceNilWithDefaultValue(options);
//    BOOL isDefaultValuePointless = (!shouldReplaceNilWithDefaultValue && defaultValue != nil);
//    if (isDefaultValuePointless) {
//        //TODO: Include details about the object and JSONPath
//        BCJLog(@"%@: Default value has been given but BCJGetterOptionReplaceNilWithDefaultValue is not set.", nil);
//    }
//
//    if (shouldReplaceNilWithDefaultValue && defaultValue == nil) {
//        //TODO: Include details about the object and JSONPath
//        BCJLog(@"%@: Default value has replacement has been specified but default value == nil.", nil);
//    }
}



@implementation BCJJSONSource

-(instancetype)init
{
    return [self initWithObject:nil JSONPath:nil expectedClass:Nil options:0 defaultValue:nil];
}



-(instancetype)initWithObject:(id)object JSONPath:(NSString *)JSONPath expectedClass:(Class)expectedClass options:(BCJJSONSourceOptions)options defaultValue:(id)defaultValue
{
    BCJAssertValidGetterOptions(object, JSONPath, expectedClass, options, defaultValue);

    self = [super init];
    if (self == nil) return nil;

    _object = object;
    _JSONPath = [JSONPath copy];
    _expectedClass = expectedClass;
    _options = options;
    _defaultValue = defaultValue;

    BCJLogSuspiciousArguments(object, JSONPath, expectedClass, options, defaultValue);

    return self;
}



-(BCJJSONSourceResult)getValue:(id *)outValue error:(NSError **)outError
{
    //Reset outValue
    *outValue = nil;

    //Fetch value
    __block id failedComponent = nil;
    __block NSUInteger failedComponentIdx = NSNotFound;
    id value = ({
        //Get the containedObject if implemented, otherwise just use the object
        __block id lastValue = self.object;
        NSError *pathError = BCJEnumerateJSONPathComponents(self.JSONPath, ^(id component, NSUInteger componentIdx, BOOL *stop) {

            if ([component isKindOfClass:[NSNumber class]]) {
                //Index component
                if ([lastValue respondsToSelector:@selector(objectAtIndex:)] && [lastValue respondsToSelector:@selector(count)]) {
                    NSUInteger idx = [component integerValue];
                    lastValue = (idx < [lastValue count]) ? [lastValue objectAtIndex:idx] : nil;
                }
            } else if ([component isKindOfClass:[NSString class]]) {
                //keyed component
                if ([lastValue respondsToSelector:@selector(objectForKey:)]) {
                    lastValue = [lastValue objectForKey:component];
                }
            } else if ([component isKindOfClass:[NSNull class]]) {
                //'self' component
                lastValue = lastValue;
            }

            BOOL didFetchFail = (lastValue == nil);
            if (didFetchFail) {
                failedComponent = component;
                failedComponentIdx = componentIdx;
                *stop = YES;
            }
        });
        if (pathError != nil) {
            failedComponent = self.JSONPath;
            failedComponentIdx = 0;
            NSAssert(pathError == nil, @"Error in JSON path: %@", pathError);
        }

        lastValue;
    });

    //1. Check that path did evaluate
    BOOL didFailPathEvaluation = (failedComponentIdx != NSNotFound);
    if (didFailPathEvaluation && BCJPathMustEvaluateToValue(self.options)) {
        if (outError != NULL )*outError = [BCJError missingValueErrorWithJSONSource:self component:failedComponent componentIndex:failedComponentIdx];
        return BCJJSONSourceResultFailure;
    }

    //2. Fix up null
    if (BCJReplaceNullWithNil(self.options) && [value isKindOfClass:NSNull.class]) {
        value = nil;
    }

    //3. No-op on nil
    //Note that we could still return nil because the defaultValue may be nil.
    if (value == nil && !BCJTreatValueNotFoundAsSuccess(self.options)) {
        return BCJJSONSourceResultValueNotFound;
    }

    //4. Replace nil with defaultValue
    if (value == nil) {
        value = self.defaultValue;
    }

    //5. Type check value
    BOOL shouldCheckClass = value != nil;
    Class expectedClass = self.expectedClass;
    BOOL isCorrectKind = expectedClass == nil || [value isKindOfClass:expectedClass];
    if (shouldCheckClass && !isCorrectKind) {
        if (outError != NULL) {
            NSString *criteria = [NSString stringWithFormat:@"value.class != %@", NSStringFromClass(expectedClass)];
            *outError = [BCJError invalidValueErrorWithJSONSource:self value:value criteria:criteria];
        }
        return BCJJSONSourceResultFailure;
    }

    //6. We ran the gauntlet!
    *outValue = value;
    return BCJJSONSourceResultSuccess;
}

@end



#pragma mark - Strict Constructors
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSString *JSONPath, Class expectClass, BCJJSONSourceOptions options, id defaultValue) {
    return [[BCJJSONSource alloc] initWithObject:object JSONPath:JSONPath expectedClass:expectClass options:options defaultValue:defaultValue];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSUInteger idx, Class expectClass, BCJJSONSourceOptions options, id defaultValue) {
    NSString *JSONPath = [NSString stringWithFormat:@"%lu", [@(idx) unsignedLongValue]];
    return [[BCJJSONSource alloc] initWithObject:object JSONPath:JSONPath expectedClass:expectClass options:options defaultValue:defaultValue];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSString *JSONPath, Class expectClass, BCJJSONSourceOptions options) {
    return [[BCJJSONSource alloc] initWithObject:object JSONPath:JSONPath expectedClass:expectClass options:options defaultValue:nil];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSUInteger idx, Class expectClass, BCJJSONSourceOptions options) {
    NSString *JSONPath = [NSString stringWithFormat:@"%lu", [@(idx) unsignedLongValue]];
    return [[BCJJSONSource alloc] initWithObject:object JSONPath:JSONPath expectedClass:expectClass options:options defaultValue:nil];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSString *JSONPath, Class expectClass) {
    return [[BCJJSONSource alloc] initWithObject:object JSONPath:JSONPath expectedClass:expectClass options:BCJJSONSourceModeOptional defaultValue:nil];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSUInteger idx, Class expectClass) {
    NSString *JSONPath = [NSString stringWithFormat:@"%lu", [@(idx) unsignedLongValue]];
    return [[BCJJSONSource alloc] initWithObject:object JSONPath:JSONPath expectedClass:expectClass options:BCJJSONSourceModeOptional defaultValue:nil];
}



#pragma mark - Constructors with nil expectClass
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSString *JSONPath, BCJJSONSourceOptions options, id defaultValue) {
    return [[BCJJSONSource alloc] initWithObject:object JSONPath:JSONPath expectedClass:nil options:options defaultValue:nil];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSUInteger idx, BCJJSONSourceOptions options, id defaultValue) {
    NSString *JSONPath = [NSString stringWithFormat:@"%lu", [@(idx) unsignedLongValue]];
    return [[BCJJSONSource alloc] initWithObject:object JSONPath:JSONPath expectedClass:nil options:options defaultValue:defaultValue];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSString *JSONPath, BCJJSONSourceOptions options) {
    return [[BCJJSONSource alloc] initWithObject:object JSONPath:JSONPath expectedClass:nil options:BCJJSONSourceModeOptional defaultValue:nil];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSUInteger idx, BCJJSONSourceOptions options) {
    NSString *JSONPath = [NSString stringWithFormat:@"%lu", [@(idx) unsignedLongValue]];
    return [[BCJJSONSource alloc] initWithObject:object JSONPath:JSONPath expectedClass:nil options:options defaultValue:nil];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSString *JSONPath) {
    return [[BCJJSONSource alloc] initWithObject:object JSONPath:JSONPath expectedClass:nil options:BCJJSONSourceModeOptional defaultValue:nil];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSUInteger idx) {
    NSString *JSONPath = [NSString stringWithFormat:@"%lu", [@(idx) unsignedLongValue]];
    return [[BCJJSONSource alloc] initWithObject:object JSONPath:JSONPath expectedClass:nil options:BCJJSONSourceModeOptional defaultValue:nil];
}
