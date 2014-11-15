//
//  BCJJSONSource.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 04/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJJSONSource.h"
#import "BCJJSONSource+OptionsAdditons.h"
#import "BCJLogging.h"
#import "BCJError.h"
#import "BCJEnumerateJSONPathComponents.h"



#pragma mark - Asserts/Logging
static inline void BCJAssertValidGetterOptions(id object, NSString *JSONPath, BCJSourceOptions options, id defaultValue) {
#pragma message "TODO"
//    NSError *pathError = BCJEnumerateJSONPathComponents(JSONPath, ^(id component, NSUInteger idx, BOOL *stop) {});
//    NSCAssert(pathError == nil, @"Invalid JSONPath: %@", pathError);
//
//    //If nil is allowed then there's nothing more we can assert because we can't inspect type mismatches until we set.
//
//    if (BCJShouldAllowNilValue(options)) return;
//
//    BOOL shouldReplaceNullWithNil = BCJShouldReplaceNullWithNil(options);
//    BOOL shouldReplaceNilWithDefaultValue = BCJShouldReplaceNilWithDefaultValue(options);
//
//    if (shouldReplaceNullWithNil && !shouldReplaceNilWithDefaultValue) {
//        NSCAssert(NO, @"Invalid option combinations. A mandatory getters with Null->nil replacement must also include nil->defaultValue.");
//    }
//
//    //Because defaultValue is nil and nil is not allowed nil->defaultValue will always fail.
//    if (defaultValue == nil && shouldReplaceNilWithDefaultValue) {
//        NSCAssert(NO, @"Invalid option combinations. A mandatory-defaultable getter must have an non-nil defaultValue.");
//    }
}



static inline void BCJLogSuspiciousArguments(id object, NSString *JSONPath, BCJSourceOptions options, id defaultValue) {
#pragma message "TODO"
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

-(instancetype)initWithObject:(id)object JSONPath:(NSString *)JSONPath expectedClass:(Class)expectedClass options:(BCJSourceOptions)options defaultValue:(id)defaultValue
{
    BCJAssertValidGetterOptions(object, JSONPath, options, defaultValue);

    self = [super init];
    if (self == nil) return nil;

    _object = object;
    _JSONPath = [JSONPath copy];
    _expectedClass = expectedClass;
    _options = options;
    _defaultValue = defaultValue;

    BCJLogSuspiciousArguments(object, JSONPath, options, defaultValue);

    return self;
}



-(BCJSourceResult)getValue:(id *)outValue error:(NSError **)outError
{
    //Reset outValue
    *outValue = nil;

    //Fetch value
    __block NSUInteger lastComponentIdx = NSNotFound;
    __block id lastComponent = nil;
    id value = ({
        __block id lastValue = self.object;
        NSError *pathError = BCJEnumerateJSONPathComponents(self.JSONPath, ^(id component, NSUInteger componentIdx, BOOL *stop) {

            if ([component isKindOfClass:[NSNumber class]]) {
                //Index subscript
                if ([lastValue respondsToSelector:@selector(objectAtIndex:)] && [lastValue respondsToSelector:@selector(count)]) {
                    NSUInteger idx = [component integerValue];
                    lastValue = (idx < [lastValue count]) ? [lastValue objectAtIndex:idx] : nil;
                }
            } else /*if ([component isKindOfClass:[NSString class]])*/ { //This check is redundant
                //keyed subscript
                if ([lastValue respondsToSelector:@selector(objectForKey:)]) {
                    lastValue = [lastValue objectForKey:component];
                }
            }

            BOOL didFetchFail = (lastValue == nil);
            if (didFetchFail) {
                lastComponent = component;
                lastComponentIdx = componentIdx;
                *stop = YES;
            }
        });

        NSAssert(pathError == nil, @"Error in JSON path: %@", pathError);
        lastValue;
    });

    BOOL didPathEvaluationFail = (value == nil);
    if (didPathEvaluationFail) {
        if (BCJPathMustEvaluateToValue(self.options)) {
            if (outError != NULL )*outError = [BCJError missingValueErrorWithJSONSource:self component:lastComponent componentIndex:lastComponentIdx];
            return BCJSourceResultFailed;
        }

        if (!BCJMustReturnValue(self.options)) {
            return BCJSourceResultValueNotFound;
        }
    }

    //Fix up null
    if (BCJReplaceNullWithDefaultValue(self.options) && [value isKindOfClass:NSNull.class]) {
        value = nil;
    }
    //Replace nil with defaultValue
    if (value == nil) {
        value = self.defaultValue;
    }

    //Type check value
    BOOL shouldCheckClass = value != nil;
    Class expectedClass = self.expectedClass;
    BOOL isCorrectKind = expectedClass == nil || [value isKindOfClass:expectedClass];
    if (shouldCheckClass && !isCorrectKind) {
        if (outError == NULL) {
            NSString *criteria = [NSString stringWithFormat:@"value.class != %@", NSStringFromClass(expectedClass)];
            *outError = [BCJError invalidValueErrorWithJSONSource:self value:value criteria:criteria];
        }
        return BCJSourceResultFailed;
    }

    //We ran the gauntlet!
    *outValue = value;
    return BCJSourceResultSucceed;
}

@end



#pragma mark - Strict Constructors
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSString *JSONPath, Class expectClass, BCJSourceOptions options, id defaultValue) {
    return [[BCJJSONSource alloc] initWithObject:object JSONPath:JSONPath expectedClass:expectClass options:options defaultValue:defaultValue];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSUInteger idx, Class expectClass, BCJSourceOptions options, id defaultValue) {
    NSString *JSONPath = [NSString stringWithFormat:@"%lu", [@(idx) unsignedLongValue]];
    return [[BCJJSONSource alloc] initWithObject:object JSONPath:JSONPath expectedClass:expectClass options:options defaultValue:defaultValue];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSString *JSONPath, Class expectClass, BCJSourceOptions options) {
    return [[BCJJSONSource alloc] initWithObject:object JSONPath:JSONPath expectedClass:expectClass options:options defaultValue:nil];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSUInteger idx, Class expectClass, BCJSourceOptions options) {
    NSString *JSONPath = [NSString stringWithFormat:@"%lu", [@(idx) unsignedLongValue]];
    return [[BCJJSONSource alloc] initWithObject:object JSONPath:JSONPath expectedClass:expectClass options:options defaultValue:nil];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSString *JSONPath, Class expectClass) {
    return [[BCJJSONSource alloc] initWithObject:object JSONPath:JSONPath expectedClass:expectClass options:BCJSourceModeOptional defaultValue:nil];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSUInteger idx, Class expectClass) {
    NSString *JSONPath = [NSString stringWithFormat:@"%lu", [@(idx) unsignedLongValue]];
    return [[BCJJSONSource alloc] initWithObject:object JSONPath:JSONPath expectedClass:expectClass options:BCJSourceModeOptional defaultValue:nil];
}



#pragma mark - Constructors with de-emphasized expectClass
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSString *JSONPath, BCJSourceOptions options, id defaultValue, Class expectClass) {
    return [[BCJJSONSource alloc] initWithObject:object JSONPath:JSONPath expectedClass:expectClass options:options defaultValue:defaultValue];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSUInteger idx, BCJSourceOptions options, id defaultValue, Class expectClass) {
    NSString *JSONPath = [NSString stringWithFormat:@"%lu", [@(idx) unsignedLongValue]];
    return [[BCJJSONSource alloc] initWithObject:object JSONPath:JSONPath expectedClass:expectClass options:options defaultValue:defaultValue];
}


BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSString *JSONPath, BCJSourceOptions options, id defaultValue) {
    return [[BCJJSONSource alloc] initWithObject:object JSONPath:JSONPath expectedClass:nil options:options defaultValue:nil];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSUInteger idx, BCJSourceOptions options, id defaultValue) {
    NSString *JSONPath = [NSString stringWithFormat:@"%lu", [@(idx) unsignedLongValue]];
    return [[BCJJSONSource alloc] initWithObject:object JSONPath:JSONPath expectedClass:nil options:options defaultValue:defaultValue];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSString *JSONPath, BCJSourceOptions options) {
    return [[BCJJSONSource alloc] initWithObject:object JSONPath:JSONPath expectedClass:nil options:BCJSourceModeOptional defaultValue:nil];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSUInteger idx, BCJSourceOptions options) {
    NSString *JSONPath = [NSString stringWithFormat:@"%lu", [@(idx) unsignedLongValue]];
    return [[BCJJSONSource alloc] initWithObject:object JSONPath:JSONPath expectedClass:nil options:options defaultValue:nil];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSString *JSONPath) {
    return [[BCJJSONSource alloc] initWithObject:object JSONPath:JSONPath expectedClass:nil options:BCJSourceModeOptional defaultValue:nil];
}



BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSUInteger idx) {
    NSString *JSONPath = [NSString stringWithFormat:@"%lu", [@(idx) unsignedLongValue]];
    return [[BCJJSONSource alloc] initWithObject:object JSONPath:JSONPath expectedClass:nil options:BCJSourceModeOptional defaultValue:nil];
}
