//
//  BCJSONReader.m
//  BCJSONReader
//
//  Created by Benedict Cohen on 20/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJSONReader.h"
#import "BCJEnumerateJSONPathComponents.h"
#import "BCJError.h"



#pragma mark - interface
@interface BCJSONReader ()
@property(nonatomic, readonly) NSMutableArray *mutableErrors;
@end



@implementation BCJSONReader

#pragma mark - instance life cycle
-(instancetype)init
{
    id object = nil;
    return [self initWithJSONObject:object defaultOptions:BCJNoOptions];
}



-(instancetype)initWithJSONObject:(id)jsonObject defaultOptions:(BCJSONReaderOptions)defaultOptions
{
    NSParameterAssert(jsonObject);

    self = [super init];
    if (self == nil) return nil;

    _jsonObject =  jsonObject;
    _defaultOptions = defaultOptions;

    _mutableErrors = [NSMutableArray new];

    return self;
}



#pragma mark - factory methods
+(NSError *)readJSONData:(NSData *)jsonData defaultOptions:(BCJSONReaderOptions)defaultOptions usingBlock:(void(^)(BCJSONReader *reader))block
{
    if (jsonData == nil) {
        return [BCJError invalidJSONDataErrorWithData:nil];
    }

    NSJSONReadingOptions jsonOptions = NSJSONReadingAllowFragments;
    NSError *error;
    id sourceObject = [NSJSONSerialization JSONObjectWithData:jsonData options:jsonOptions error:&error];

    BOOL didDeserialize = (sourceObject != nil);
    if (!didDeserialize) {
        return error;
    }

    return [self readJSONObject:sourceObject defaultOptions:defaultOptions usingBlock:block];
}



+(NSError *)readJSONObject:(id)jsonObject   defaultOptions:(BCJSONReaderOptions)defaultOptions usingBlock:(void(^)(BCJSONReader *reader))block
{
    BCJSONReader *reader = [[self alloc] initWithJSONObject:jsonObject defaultOptions:defaultOptions];
    
    block(reader);

    NSArray *errors = reader.errors;
    if (errors.count == 0)  return nil;

    if (errors.count == 1)  return [errors lastObject];

    NSError *masterError = [BCJError errorWithUnderlyingErrors:errors];

    return masterError;
}



#pragma mark - accessors
-(id)objectAt:(NSString *)jsonPath type:(Class)expectedClass
{
    return [self objectAt:jsonPath type:expectedClass options:self.defaultOptions defaultValue:nil didSucceed:NULL];
}



-(id)objectAt:(NSString *)JSONPath type:(Class)expectedClass options:(BCJSONReaderOptions)options defaultValue:(id)defaultValue didSucceed:(BOOL *)didSucceed
{
    //Reset didSucceed.
    //TODO: It would be safer to assume NO until proven otherwise.
    if (didSucceed != NULL) *didSucceed = YES;

    //Fetch value
    __block id failedComponent = nil;
    __block NSUInteger failedComponentIdx = NSNotFound;
    id value = ({
        //Get the containedObject if implemented, otherwise just use the object
        __block id lastValue = self.jsonObject;
        NSError *pathError = BCJEnumerateJSONPathComponents(JSONPath, ^(id component, NSUInteger componentIdx, BOOL *stop) {

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
                [lastValue self];
            }

            BOOL didFetchFail = (lastValue == nil);
            if (didFetchFail) {
                failedComponent = component;
                failedComponentIdx = componentIdx;
                *stop = YES;
            }
        });
        if (pathError != nil) {
            failedComponent = JSONPath;
            failedComponentIdx = 0;
            BCJExpectation(pathError == nil, @"Error in JSON path: %@", pathError);
        }

        lastValue;
    });

    //1. Check that path did evaluate
    BOOL isRequiredToEvaluate =  (BCJSONReaderOptionPathMustEvaluateToValue & options) != 0;
    BOOL didFailToEvaluate = (failedComponentIdx != NSNotFound);
    if (isRequiredToEvaluate && didFailToEvaluate) {
        NSError *error = [BCJError missingSourceValueErrorWithJSONPath:JSONPath JSONPathComponent:failedComponent componentIndex:failedComponentIdx];
        [self addError:error];
        if (didSucceed != NULL) *didSucceed = NO;
        return nil;
    }

    //2. Fix up null
    BOOL shouldReplaceNullWithNil = (options & BCJSONReaderOptionReplaceNullWithNil) != 0;
    BOOL isNull = [value isKindOfClass:NSNull.class];
    if (shouldReplaceNullWithNil && isNull) {
        value = nil;
    }

    //3. Replace nil with defaultValue
    BOOL shouldReplaceNilWithDefault = (value == nil);
    if (shouldReplaceNilWithDefault) {
        value = defaultValue;
    }

    //4. Type check value
    BOOL shouldCheckClass = value != nil;
    BOOL isCorrectKind = expectedClass == nil || [value isKindOfClass:expectedClass];
    if (shouldCheckClass && !isCorrectKind) {
        NSString *criteria = [NSString stringWithFormat:@"value.class == %@", NSStringFromClass(expectedClass)];
        NSError *error = [BCJError invalidValueErrorWithJSONPath:JSONPath value:value criteria:criteria];
        [self addError:error];
        if (didSucceed != NULL) *didSucceed = NO;
        return nil;
    }

    //We ran the gauntlet!
    return value;
}



#pragma mark - errors
-(void)addError:(NSError *)error
{
    if (error == nil) return;
    [self.mutableErrors addObject:error];
}



-(BOOL)hasErrors
{
    return self.mutableErrors.count > 0;
}



-(void)resetErrors
{
    [self.mutableErrors removeAllObjects];
}



-(NSArray *)errors
{
    return [self.mutableErrors copy];
}

@end
