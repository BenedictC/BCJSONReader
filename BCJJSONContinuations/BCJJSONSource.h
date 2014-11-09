//
//  BCJSource.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 04/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCJDefines.h"



#pragma mark - Source options
typedef NS_OPTIONS(NSUInteger, BCJSourceOptions) {
    BCJSourceOptionReplaceNullWithNil  = (1UL  << 0),
    BCJSourceOptionReplaceNilWithDefaultValue = (1UL  << 1),
    BCJSourceOptionAllowsNilValue  = (1UL  << 2),
};



#pragma mark - Source modes (i.e. predefined source options)
typedef BCJSourceOptions BCJSourceMode;
const static BCJSourceMode BCJSourceModeMantatory           = 0;

const static BCJSourceMode BCJSourceModeOptional            = BCJSourceOptionAllowsNilValue;
const static BCJSourceMode BCJSourceModeDefaultable         = BCJSourceOptionAllowsNilValue     | BCJSourceOptionReplaceNilWithDefaultValue;

const static BCJSourceMode BCJSourceModeNullableOptional    = BCJSourceOptionReplaceNullWithNil | BCJSourceOptionAllowsNilValue;
const static BCJSourceMode BCJSourceModeNullableDefaultable = BCJSourceOptionReplaceNullWithNil | BCJSourceOptionAllowsNilValue | BCJSourceOptionReplaceNilWithDefaultValue;



#pragma mark - BCJJSONSource
@interface BCJJSONSource : NSObject

-(instancetype)initWithObject:(id)object JSONPath:(NSString *)JSONPath expectedClass:(Class)expectedClass options:(BCJSourceOptions)options defaultValue:(id)defaultValue;

@property(nonatomic, readonly) id object;
@property(nonatomic, readonly) NSString *JSONPath;
@property(nonatomic, readonly) Class expectedClass;
@property(nonatomic, readonly) BCJSourceOptions options;
@property(nonatomic, readonly) id defaultValue;

-(BOOL)getValue:(id *)value error:(NSError **)outError;

@end



#pragma mark - Strict Constructors
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSString *JSONPath, Class expectClass, BCJSourceOptions options, id defaultValue) BCJ_REQUIRED(1,2);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSUInteger idx,     Class expectClass, BCJSourceOptions options, id defaultValue) BCJ_REQUIRED(1);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSString *JSONPath, Class expectClass, BCJSourceOptions options) BCJ_REQUIRED(1,2);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSUInteger idx,     Class expectClass, BCJSourceOptions options) BCJ_REQUIRED(1);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSString *JSONPath, Class expectClass) BCJ_REQUIRED(1,2);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSUInteger idx,     Class expectClass) BCJ_REQUIRED(1);

#pragma mark - Constructors with de-emphasized expectClass
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSString *JSONPath, BCJSourceOptions options, id defaultValue, Class expectClass) BCJ_REQUIRED(1,2);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSUInteger idx,     BCJSourceOptions options, id defaultValue, Class expectClass) BCJ_REQUIRED(1);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSString *JSONPath, BCJSourceOptions options, id defaultValue) BCJ_REQUIRED(1,2);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSUInteger idx,     BCJSourceOptions options, id defaultValue) BCJ_REQUIRED(1);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSString *JSONPath, BCJSourceOptions options) BCJ_REQUIRED(1,2);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSUInteger idx,     BCJSourceOptions options) BCJ_REQUIRED(1);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSString *JSONPath) BCJ_REQUIRED(1,2);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id object, NSUInteger idx)     BCJ_REQUIRED(1);
