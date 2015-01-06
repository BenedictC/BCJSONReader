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

-(id)enumAt:(NSString *)jsonPath enumMapping:(NSDictionary *)enumMapping
{
    return [self enumAt:jsonPath enumMapping:enumMapping options:self.defaultOptions defaultKey:nil didSucceed:NULL];
}



-(id)enumAt:(NSString *)jsonPath enumMapping:(NSDictionary *)enumMapping options:(BCJSONReaderOptions)options defaultKey:(id)defaultKey  didSucceed:(BOOL *)didSucceed
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



-(NSArray *)arrayFromArrayAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options didSucceed:(BOOL *)didSucceed usingElementReaderBlock:(id(^)(BCJSONReader *elementReader, NSUInteger elementIndex))block
{
    NSArray *sourceArray = [self arrayAt:jsonPath options:options defaultValue:nil didSucceed:didSucceed];
    if (sourceArray == nil) return nil;

    NSInteger elementIdx = 0;
    NSMutableArray *mappedArray = [NSMutableArray new];

    for (id element in sourceArray) {
        __block id mappedElement = nil;
        NSError *elementError = [BCJSONReader readJSONObject:element defaultOptions:options usingBlock:^(BCJSONReader *elementReader) {
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



-(NSArray *)arrayFromDictionaryAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options didSucceed:(BOOL *)didSucceed usingElementReaderBlock:(id(^)(BCJSONReader *elementReader, id unsafeElementKey))block
{
    NSDictionary *sourceDict = [self dictionaryAt:jsonPath options:options defaultValue:nil didSucceed:didSucceed];
    if (sourceDict == nil) return nil;

    NSInteger idx = 0;
    NSMutableArray *mappedArray = [NSMutableArray new];

    for (id elementKey in sourceDict.allKeys) {
        id element = sourceDict[elementKey];
        __block id mappedElement = nil;
        NSError *elementError = [BCJSONReader readJSONObject:element defaultOptions:options usingBlock:^(BCJSONReader *elementReader) {
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

        //Prep for next interation
        idx++;
    }
    
    return mappedArray;
}



-(id)castObject:(id)object toClass:(Class)class didSucceed:(BOOL *)didSucceed
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
