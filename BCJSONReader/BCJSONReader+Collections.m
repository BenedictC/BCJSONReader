//
//  BCJReader+Collections.m
//  BCJSONReader
//
//  Created by Benedict Cohen on 05/01/2015.
//  Copyright (c) 2015 Benedict Cohen. All rights reserved.
//

#import "BCJSONReader.h"
#import "BCJError.h"



@implementation BCJSONReader (Collections)

#pragma mark - enumerations
-(id)enumerationAt:(NSString *)jsonPath enumMapping:(NSDictionary *)enumMapping
{
    return [self enumerationAt:jsonPath enumMapping:enumMapping options:self.defaultOptions defaultKey:nil didSucceed:NULL];
}



-(id)enumerationAt:(NSString *)jsonPath enumMapping:(NSDictionary *)enumMapping options:(BCJSONReaderOptions)options defaultKey:(id)defaultKey  didSucceed:(BOOL *)didSucceed
{
    id key = [self objectAt:jsonPath type:Nil options:options defaultValue:defaultKey didSucceed:didSucceed];
    if (key == nil) return nil;

    id value = enumMapping[key];
    if (value == nil) {
        NSError *error = [BCJError missingEnumMappingKeyErrorWithJSONPath:jsonPath enumMapping:enumMapping key:key];
        [self addError:error];
        if (didSucceed != NULL) *didSucceed = NO;
        return nil;
    }

    return value;
}



#pragma mark - arrays
-(void)enumerateArrayAt:(NSString *)jsonPath usingElementReaderBlock:(void(^)(BCJSONReader *elementReader, NSUInteger elementIndex))block
{
    [self enumerateArrayAt:jsonPath options:self.defaultOptions didSucceed:NULL usingElementReaderBlock:block];
}



-(void)enumerateArrayAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options didSucceed:(BOOL *)didSucceed usingElementReaderBlock:(void(^)(BCJSONReader *elementReader, NSUInteger elementIndex))block
{
    NSArray *sourceArray = [self arrayAt:jsonPath options:options defaultValue:nil didSucceed:didSucceed];
    if (sourceArray == nil) return;

    NSInteger elementIdx = 0;

    for (id element in sourceArray) {
        NSError *elementError = [BCJSONReader readObject:element defaultOptions:options usingBlock:^(BCJSONReader *elementReader) {
            block(elementReader, elementIdx);
        }];

        //Handle element error
        if (elementError != nil) {
            NSError *mappingError = [BCJError collectionMappingErrorWithJSONPath:jsonPath elementSubscript:@(elementIdx) elementError:elementError];
            [self addError:mappingError];
            if (didSucceed != NULL) *didSucceed = NO;
            return;
        }

        //Prep for next interation
        elementIdx++;
    }
}



-(NSArray *)arrayFromArrayAt:(NSString *)jsonPath usingElementReaderBlock:(id(^)(BCJSONReader *elementReader, NSUInteger elementIndex))block
{
    return [self arrayFromArrayAt:jsonPath options:self.defaultOptions didSucceed:NULL usingElementReaderBlock:block];
}



-(NSArray *)arrayFromArrayAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options didSucceed:(BOOL *)didSucceed usingElementReaderBlock:(id(^)(BCJSONReader *elementReader, NSUInteger elementIndex))block
{
    NSArray *sourceArray = [self arrayAt:jsonPath options:options defaultValue:nil didSucceed:didSucceed];
    if (sourceArray == nil) return nil;

    NSInteger elementIdx = 0;
    NSMutableArray *mappedArray = [NSMutableArray new];

    for (id element in sourceArray) {
        __block id mappedElement = nil;
        NSError *elementError = [BCJSONReader readObject:element defaultOptions:options usingBlock:^(BCJSONReader *elementReader) {
            mappedElement = block(elementReader, elementIdx);
        }];

        //Handle element error
        if (elementError != nil) {
            NSError *mappingError = [BCJError collectionMappingErrorWithJSONPath:jsonPath elementSubscript:@(elementIdx) elementError:elementError];
            [self addError:mappingError];
            if (didSucceed != NULL) *didSucceed = NO;
            return nil;
        }

        //Handle the object
        if (mappedElement != nil) {
            [mappedArray addObject:mappedElement];
        }

        //Prep for next interation
        elementIdx++;
    }

    return mappedArray;
}



#pragma mark - dictionaries
-(void)enumerateDictionaryAt:(NSString *)jsonPath usingElementReaderBlock:(void(^)(BCJSONReader *elementReader, id unsafeElementKey))block
{
    [self enumerateDictionaryAt:jsonPath options:self.defaultOptions didSucceed:NULL usingElementReaderBlock:block];
}



-(void)enumerateDictionaryAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options didSucceed:(BOOL *)didSucceed usingElementReaderBlock:(void(^)(BCJSONReader *elementReader, id unsafeElementKey))block
{
    NSDictionary *sourceDict = [self dictionaryAt:jsonPath options:options defaultValue:nil didSucceed:didSucceed];
    if (sourceDict == nil) return;

    for (id elementKey in sourceDict.allKeys) {
        id element = sourceDict[elementKey];
        NSError *elementError = [BCJSONReader readObject:element defaultOptions:options usingBlock:^(BCJSONReader *elementReader) {
            block(elementReader, elementKey);
        }];

        //Handle element error
        if (elementError != nil) {
            NSError *mappingError = [BCJError collectionMappingErrorWithJSONPath:jsonPath elementSubscript:elementKey elementError:elementError];
            [self addError:mappingError];
            if (didSucceed != NULL) *didSucceed = NO;
            return;
        }
    }
}



-(NSArray *)arrayFromDictionaryAt:(NSString *)jsonPath usingElementReaderBlock:(id(^)(BCJSONReader *elementReader, id unsafeElementKey))block
{
    return [self arrayFromDictionaryAt:jsonPath options:self.defaultOptions didSucceed:NULL usingElementReaderBlock:block];
}



-(NSArray *)arrayFromDictionaryAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options didSucceed:(BOOL *)didSucceed usingElementReaderBlock:(id(^)(BCJSONReader *elementReader, id unsafeElementKey))block
{
    NSDictionary *sourceDict = [self dictionaryAt:jsonPath options:options defaultValue:nil didSucceed:didSucceed];
    if (sourceDict == nil) return nil;

    NSMutableArray *mappedArray = [NSMutableArray new];

    for (id elementKey in sourceDict.allKeys) {
        id element = sourceDict[elementKey];
        __block id mappedElement = nil;
        NSError *elementError = [BCJSONReader readObject:element defaultOptions:options usingBlock:^(BCJSONReader *elementReader) {
            mappedElement = block(elementReader, elementKey);
        }];

        //Handle element error
        if (elementError != nil) {
            NSError *mappingError = [BCJError collectionMappingErrorWithJSONPath:jsonPath elementSubscript:elementKey elementError:elementError];
            [self addError:mappingError];
            if (didSucceed != NULL) *didSucceed = NO;
            return nil;
        }

        //Handle the object
        if (mappedElement != nil) {
            [mappedArray addObject:mappedElement];
        }
    }
    
    return mappedArray;
}



-(id)verifyObject:(id)object isKindOfClass:(Class)class didSucceed:(BOOL *)didSucceed
{
    BCJParameterExpectation(class);

    BOOL isValid = object == nil || [object isKindOfClass:class];

    if (didSucceed != NULL) *didSucceed = isValid;

    if (!isValid) {
        NSError *error = [BCJError unexpectedTypeErrorWithJSONPath:nil value:object expectedClass:class];
        [self addError:error];
        return nil;
    }

    return object;
}

@end
