//
//  BCMJSONAccess.h
//  BCMJSONAccess
//
//  Created by Benedict Cohen on 27/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLContinuation.h"


NSArray * BCJNullAnd(Class firstClass, ...);



typedef NS_OPTIONS(NSInteger, BCJOption) {
    BCJShouldSubstituteNullForDefaultValue,
};



//NSArray
id<BCLContinuation> __attribute__((overrideable)) BCJObject(NSArray *array, NSUInteger idx, Class class, void(^successBlock)(id object));
id<BCLContinuation> __attribute__((overrideable)) BCJObject(NSArray *array, NSUInteger idx, NSArray *validClasses, id defaultValue, void(^successBlock)(id object));

//NSDictionary
id<BCLContinuation> __attribute__((overrideable)) BCJObject(NSDictionary *dict, id key, Class class, void(^successBlock)(id object));
id<BCLContinuation> __attribute__((overrideable)) BCJObject(NSDictionary *dict, id key, NSArray *validClasses, id defaultValue, void(^successBlock)(id object));


//Type specific fetches
id<BCLContinuation> __attribute__((overrideable)) BCJArray(NSArray *array, NSUInteger idx, void(^successBlock)(NSArray *array));
id<BCLContinuation> __attribute__((overrideable)) BCJArray(NSArray *array, NSUInteger idx, id defaultValue, void(^successBlock)(NSArray *array));

id<BCLContinuation> __attribute__((overrideable)) BCJArray(NSDictionary *dict, id key, void(^successBlock)(NSArray *array));
//TODO: How do we permit nil or NSNull?
id<BCLContinuation> __attribute__((overrideable)) BCJArray(NSDictionary *dict, id key, id defaultValue, BCJOption options, void(^successBlock)(NSArray *array));

