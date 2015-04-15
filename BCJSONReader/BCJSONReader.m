//
//  BCJSONReader.m
//  BCJSONReader
//
//  Created by Benedict Cohen on 20/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJSONReader.h"
#import "BCJSONPathEvaluation.h"
#import "BCJError.h"



#pragma mark - interface
@interface BCJSONReader ()
@property(nonatomic, readonly) NSMutableArray *mutableErrors;
@end



@implementation BCJSONReader

#pragma mark - instance life cycle
-(instancetype)init
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    return [self initWithObject:nil defaultOptions:BCJNoOptions];
#pragma clang diagnostic pop
}



-(instancetype)initWithObject:(id)object defaultOptions:(BCJSONReaderOptions)defaultOptions
{
    BCJParameterExpectation(object);

    self = [super init];
    if (self == nil) return nil;

    _object =  object;
    _defaultOptions = defaultOptions;

    _mutableErrors = [NSMutableArray new];

    return self;
}



#pragma mark - factory methods
+(NSError *)readJSONData:(NSData *)jsonData defaultOptions:(BCJSONReaderOptions)defaultOptions usingBlock:(void(^)(BCJSONReader *reader))block
{
    if (jsonData == nil) {
        return [BCJError invalidSourceDataErrorWithData:nil expectedDataFormatName:@"JSON" underlyingError:nil];
    }

    NSJSONReadingOptions jsonOptions = NSJSONReadingAllowFragments;
    NSError *error;
    id sourceObject = [NSJSONSerialization JSONObjectWithData:jsonData options:jsonOptions error:&error];

    BOOL didDeserialize = (sourceObject != nil);
    if (!didDeserialize) {
        return [BCJError invalidSourceDataErrorWithData:nil expectedDataFormatName:@"JSON" underlyingError:error];
    }

    return [self readObject:sourceObject defaultOptions:defaultOptions usingBlock:block];
}



+(NSError *)readObject:(id)jsonObject   defaultOptions:(BCJSONReaderOptions)defaultOptions usingBlock:(void(^)(BCJSONReader *reader))block
{
    BCJSONReader *reader = [[self alloc] initWithObject:jsonObject defaultOptions:defaultOptions];
    
    block(reader);

    NSArray *errors = reader.errors;
    if (errors.count == 0)  return nil;

    if (errors.count == 1)  return [errors lastObject];

    return [BCJError multipleErrorsErrorWithErrors:errors];
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
    NSUInteger failedComponentIdx;
    id failedComponent;
    id value = BCJEvaluateJSONPath(JSONPath, self.object, &failedComponentIdx, &failedComponent);

    //1. Check that path did evaluate
    BOOL isRequiredToEvaluate =  (BCJSONReaderOptionPathMustEvaluateToValue & options) != 0;
    BOOL didFailToEvaluate = (failedComponentIdx != NSNotFound);
    if (isRequiredToEvaluate && didFailToEvaluate) {
        NSError *error = [BCJError valueNotFoundErrorWithJSONPath:JSONPath JSONPathComponent:failedComponent componentIndex:failedComponentIdx];
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
-(NSArray *)errors
{
    return [self.mutableErrors copy];
}



-(void)addError:(NSError *)error
{
    if (error == nil) return;
    [self.mutableErrors addObject:error];
}



-(BOOL)hasErrors
{
    return self.mutableErrors.count > 0;
}

@end
