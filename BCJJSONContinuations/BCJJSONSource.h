//
//  BCJSource.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 04/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCJDefines.h"
#import "BCJContainerProtocols.h"



#pragma mark - Results
typedef NS_ENUM(NSUInteger, BCJSourceResult) {
    BCJSourceResultFailed,
    BCJSourceResultSucceed,
    BCJSourceResultValueNotFound,
};



#pragma mark - Source options
typedef NS_OPTIONS(NSUInteger, BCJSourceOptions) {
    BCJSourceOptionMustReturnValue             = (1UL  << 1),
    BCJSourceOptionPathMustEvaluateToValue     = (1UL  << 2),
    BCJSourceOptionReplaceNullWithDefaultValue = (1UL  << 3),
};



#pragma mark - Source modes (i.e. predefined source options)
typedef BCJSourceOptions BCJSourceMode;
//Optional   //If there's no value then do nothing
const static BCJSourceMode BCJSourceModeOptional     = 0;
//Defaultable  //If there's no value then return defaultValue
const static BCJSourceMode BCJSourceModeDefaultable  = BCJSourceOptionMustReturnValue;

//Strict         //There must be a value
const static BCJSourceMode BCJSourceModeStrict  = BCJSourceOptionPathMustEvaluateToValue;
//StrictNullable //There must be a value and if the value is null it will be replaced with the default value
const static BCJSourceMode BCJSourceModeStrictNullable  = BCJSourceOptionPathMustEvaluateToValue | BCJSourceOptionReplaceNullWithDefaultValue;


#pragma mark - BCJJSONSource
@interface BCJJSONSource : NSObject

-(instancetype)initWithObject:(id<BCJContainer>)object JSONPath:(NSString *)JSONPath expectedClass:(Class)expectedClass options:(BCJSourceOptions)options defaultValue:(id)defaultValue;

@property (nonatomic, readonly) id<BCJContainer> object;
@property (nonatomic, readonly) NSString         *JSONPath;
@property (nonatomic, readonly) Class            expectedClass;
@property (nonatomic, readonly) BCJSourceOptions options;
@property (nonatomic, readonly) id               defaultValue;

-(BCJSourceResult)getValue:(id *)value error:(NSError **)outError;

@end



#pragma mark - Strict Constructors
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> object, NSString *JSONPath, Class expectClass, BCJSourceOptions options, id defaultValue) BCJ_REQUIRED(1,2);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> object, NSUInteger idx,     Class expectClass, BCJSourceOptions options, id defaultValue) BCJ_REQUIRED(1);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> object, NSString *JSONPath, Class expectClass, BCJSourceOptions options) BCJ_REQUIRED(1,2);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> object, NSUInteger idx,     Class expectClass, BCJSourceOptions options) BCJ_REQUIRED(1);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> object, NSString *JSONPath, Class expectClass) BCJ_REQUIRED(1,2);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> object, NSUInteger idx,     Class expectClass) BCJ_REQUIRED(1);

#pragma mark - Constructors with de-emphasized expectClass
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> object, NSString *JSONPath, BCJSourceOptions options, id defaultValue, Class expectClass) BCJ_REQUIRED(1,2);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> object, NSUInteger idx,     BCJSourceOptions options, id defaultValue, Class expectClass) BCJ_REQUIRED(1);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> object, NSString *JSONPath, BCJSourceOptions options, id defaultValue) BCJ_REQUIRED(1,2);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> object, NSUInteger idx,     BCJSourceOptions options, id defaultValue) BCJ_REQUIRED(1);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> object, NSString *JSONPath, BCJSourceOptions options) BCJ_REQUIRED(1,2);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> object, NSUInteger idx,     BCJSourceOptions options) BCJ_REQUIRED(1);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> object, NSString *JSONPath) BCJ_REQUIRED(1,2);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(id<BCJContainer> object, NSUInteger idx)     BCJ_REQUIRED(1);
