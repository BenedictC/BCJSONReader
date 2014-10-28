//
//  BCJJSONContinuations.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 27/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJJSONContinuations.h"


#pragma mark - BCJGetterOptions helper functions
static inline BOOL isOptionSet(NSInteger option, NSInteger options) {
    return (options & option) != 0;
}

static inline BOOL shouldReplaceNullWithNil(BCJGetterOptions options) {
    return (options & BCJGetterOptionReplaceNullWithNil) != 0;
}

static inline BOOL shouldReplaceNilWithDefaultValue(BCJGetterOptions options) {
    return (options & BCJGetterOptionReplaceNilWithDefaultValue) != 0;
}

static inline BOOL shouldAllowNilValue(BCJGetterOptions options) {
    return (options & BCJGetterOptionAllowsNilValue) != 0;
}



#pragma mark - Getter functions
static inline BOOL BCJ_OVERLOADABLE getValue(NSArray *array, NSUInteger idx, Class class, BCJGetterOptions options, id defaultValue, id *outValue, NSError **outError) {
    //Reset outValue
    *outValue = nil;

    //Check bounds
    BOOL isInBounds = idx < array.count;
    if (!isInBounds) {
        *outError = [NSError errorWithDomain:@"TODO: Out of bounds" code:0 userInfo:nil];
        return NO;
    }

    //Fetch value
    id value = [array objectAtIndex:idx];

    //Fix up null
    if (shouldReplaceNullWithNil(options) && [value isKindOfClass:NSNull.class]) {
        value = defaultValue;
    }

    //Replace nil with default
    if (shouldReplaceNilWithDefaultValue(options) && value == nil) {
        value = defaultValue;
    }

    //Check for optionals
    if (!shouldAllowNilValue(options) && value == nil) {
        *outError = [NSError errorWithDomain:@"TODO: Missing value" code:0 userInfo:nil];
        return NO;
    }

    //Type check value
    if (![value isKindOfClass:class]) {
        *outError = [NSError errorWithDomain:@"TODO: Wrong type" code:0 userInfo:nil];
        return NO;
    }

    *outValue = value;
    return YES;
}



static inline BOOL BCJ_OVERLOADABLE getValue(NSDictionary *dict, id key, Class class, BCJGetterOptions options, id defaultValue, id *outValue, NSError **outError) {
    //Reset outValue
    *outValue = nil;

    //Fetch value
    id value = [dict objectForKey:key];

    //Fix up null value
    if (shouldReplaceNullWithNil(options) && [value isKindOfClass:NSNull.class]) {
        value = nil;
    }

    //Use default value?
    if (shouldReplaceNilWithDefaultValue(options) && value == nil) {
        value = defaultValue;
    }

    //Check for nil
    if (!shouldAllowNilValue(options) && value == nil) {
        *outError = [NSError errorWithDomain:@"TODO: Missing value" code:0 userInfo:nil];
        return NO;
    }

    //Check for type
    if (![value isKindOfClass:class]) {
        *outError = [NSError errorWithDomain:@"TODO: Wrong type" code:0 userInfo:nil];
        return NO;
    }

    *outValue = value;
    return YES;
}



#pragma mark - Type checking continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJIsOfKindClass(id object, Class class, void(^successBlock)(id object)) {
    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        BOOL success = [object isKindOfClass:class];

        if (!success) {
            *outError = [NSError errorWithDomain:@"TODO: wrong class type" code:0 userInfo:nil];
            return NO;
        }

        if (success) successBlock(object);
        return YES;
    });
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJIsOfKindClass(id object, Class class) {
    return BCJIsOfKindClass(object, class, ^(id object){});
}



#pragma mark - JSON Creation continuations
static inline BOOL deserializeJSON(NSData *data, Class class, BCJJSONReadingOptions options, id *outValue, NSError **outError) {
    //Reset outValue
    *outValue = nil;

    //Translate BCJJSONReadingOptions into NSJSONReadingOptions
    NSJSONReadingOptions jsonOptions = NSJSONReadingAllowFragments;
    if (isOptionSet(BCJJSONReadingMutableContainers, options)) jsonOptions |= NSJSONReadingMutableContainers;
    if (isOptionSet(BCJJSONReadingMutableLeaves, options))     jsonOptions |= NSJSONReadingMutableLeaves;

    //Create the JSON
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:jsonOptions error:outError];
    if (jsonObject == nil) {
        return NO;
    }

    //Check the type
    if (![jsonObject isKindOfClass:class]) {
        *outError = [NSError errorWithDomain:@"TODO: Wrong class type" code:0 userInfo:nil];
        return NO;
    }

    //Success!
    *outValue = jsonObject;
    return YES;
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(NSData *data, Class class, BCJJSONReadingOptions options, void(^successBlock)(id fragment)) {
    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        id value;
        if (!deserializeJSON(data, class, options, &value, outError)) return NO;

        successBlock(value);
        return YES;
    });
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(NSData *data, Class class, void(^successBlock)(id fragment)) {
    return BCJDeserializeJSON(data, NSArray.class, 0, successBlock);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(NSData *data, BCJJSONReadingOptions options, void(^successBlock)(NSArray *array)) {
    return BCJDeserializeJSON(data, NSArray.class, options, successBlock);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(NSData *data, void(^successBlock)(NSArray *array)) {
    return BCJDeserializeJSON(data, NSArray.class, 0, successBlock);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(NSData *data, BCJJSONReadingOptions options, void(^successBlock)(NSDictionary *dictionary)) {
    return BCJDeserializeJSON(data, NSDictionary.class, options, successBlock);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(NSData *data, void(^successBlock)(NSDictionary *dictionary)) {
    return BCJDeserializeJSON(data, NSDictionary.class, 0, successBlock);
}



//outValue result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(NSData *data, Class class, BCJJSONReadingOptions options, id *outValue) {
    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        return deserializeJSON(data, class, options, outValue, outError);
    });
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(NSData *data, NSArray **outArray) {
    return BCJDeserializeJSON(data, NSArray.class, 0, outArray);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJDeserializeJSON(NSData *data, NSDictionary **outDictionary) {
    return BCJDeserializeJSON(data, NSDictionary.class, 0, outDictionary);
}



#pragma mark - Get arbitary object continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJGetValue(NSArray *array, NSUInteger idx, Class class, BCJGetterOptions options, id defaultValue, void(^successBlock)(id value)) {
    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        id value;
        if (!getValue(array, idx, class, options, defaultValue, &value, outError)) return NO;

        successBlock(value);
        return YES;
    });
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJGetValue(NSDictionary *dict, id key, Class class, BCJGetterOptions options, id defaultValue, void(^successBlock)(id value)) {
    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        id value;
        if (!getValue(dict, key, class, options, defaultValue, &value, outError)) return NO;

        successBlock(value);
        return YES;
    });
}



#pragma mark - Set arbitary object continuations
//KVC result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetValue(NSArray *array, NSUInteger idx, Class class, BCJGetterOptions options, id defaultValue, id target, NSString *targetKey) {
    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        id value;
        if (!getValue(array, idx, class, options, defaultValue, &value, outError)) return NO;

        [target setValue:value forKey:targetKey];
        return YES;
    });
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetValue(NSDictionary *dict, id key, Class class, BCJGetterOptions options, id defaultValue, id target, NSString *targetKey) {
    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        id value;
        if (!getValue(dict, key, class, options, defaultValue, &value, outError)) return NO;

        [target setValue:value forKey:targetKey];
        return YES;
    });
}



//outValue result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetValue(NSArray *array, NSUInteger idx, Class class, BCJGetterOptions options, id defaultValue, id *outValue) {
    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        return getValue(array, idx, class, options, defaultValue, outValue, outError);
    });
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetValue(NSDictionary *dict, id key, Class class, BCJGetterOptions options, id defaultValue, id *outValue) {
    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        return getValue(dict, key, class, options, defaultValue, outValue, outError);
    });
}



#pragma mark - Set NSArray continuations
//KVC result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(NSArray *array, NSUInteger idx, BCJGetterOptions options, NSArray *defaultValue, id target, NSString *targetKey) {
    return BCJSetValue(array, idx, NSArray.class, options, defaultValue, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(NSArray *array, NSUInteger idx, id target, NSString *targetKey) {
    return BCJSetValue(array, idx, NSArray.class, 0, nil, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(NSDictionary *dict, id key, BCJGetterOptions options, NSArray *defaultValue, id target, NSString *targetKey) {
    return BCJSetValue(dict, key, NSArray.class, options, defaultValue, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetArray(NSDictionary *dict, id key, id target, NSString *targetKey) {
    return BCJSetValue(dict, key, NSArray.class, 0, nil, target, targetKey);
}



#pragma mark - Set NSMutableArray continuations
//KVC result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(NSArray *array, NSUInteger idx, BCJGetterOptions options, NSMutableArray *defaultValue, id target, NSString *targetKey) {
    return BCJSetValue(array, idx, NSMutableArray.class, options, defaultValue, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(NSArray *array, NSUInteger idx, id target, NSString *targetKey) {
    return BCJSetValue(array, idx, NSMutableArray.class, 0, nil, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(NSDictionary *dict, id key, BCJGetterOptions options, NSMutableArray *defaultValue, id target, NSString *targetKey) {
    return BCJSetValue(dict, key, NSMutableArray.class, options, defaultValue, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableArray(NSDictionary *dict, id key, id target, NSString *targetKey) {
    return BCJSetValue(dict, key, NSMutableArray.class, 0, nil, target, targetKey);
}



#pragma mark - Set NSDictionary continuations
//KVC result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(NSArray *array, NSUInteger idx, BCJGetterOptions options, NSDictionary *defaultValue, id target, NSString *targetKey) {
    return BCJSetValue(array, idx, NSDictionary.class, options, defaultValue, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(NSArray *array, NSUInteger idx, id target, NSString *targetKey) {
    return BCJSetValue(array, idx, NSDictionary.class, 0, nil, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(NSDictionary *dict, id key, BCJGetterOptions options, NSDictionary *defaultValue, id target, NSString *targetKey) {
    return BCJSetValue(dict, key, NSDictionary.class, options, defaultValue, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDictionary(NSDictionary *dict, id key, id target, NSString *targetKey) {
    return BCJSetValue(dict, key, NSDictionary.class, 0, nil, target, targetKey);
}



#pragma mark - Set NSMutableDictionary continuations
//KVC result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(NSArray *array, NSUInteger idx, BCJGetterOptions options, NSMutableDictionary *defaultValue, id target, NSString *targetKey) {
    return BCJSetValue(array, idx, NSMutableDictionary.class, options, defaultValue, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(NSArray *array, NSUInteger idx, id target, NSString *targetKey) {
    return BCJSetValue(array, idx, NSMutableDictionary.class, 0, nil, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(NSDictionary *dict, id key, BCJGetterOptions options, NSMutableDictionary *defaultValue, id target, NSString *targetKey) {
    return BCJSetValue(dict, key, NSMutableDictionary.class, options, defaultValue, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableDictionary(NSDictionary *dict, id key, id target, NSString *targetKey) {
    return BCJSetValue(dict, key, NSMutableDictionary.class, 0, nil, target, targetKey);
}



#pragma mark - Set NSString continuations
//KVC result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(NSArray *array, NSUInteger idx, BCJGetterOptions options, NSString *defaultValue, id target, NSString *targetKey) {
    return BCJSetValue(array, idx, NSString.class, options, defaultValue, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(NSArray *array, NSUInteger idx, id target, NSString *targetKey) {
    return BCJSetValue(array, idx, NSString.class, 0, nil, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(NSDictionary *dict, id key, BCJGetterOptions options, NSString *defaultValue, id target, NSString *targetKey) {
    return BCJSetValue(dict, key, NSString.class, options, defaultValue, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetString(NSDictionary *dict, id key, id target, NSString *targetKey) {
    return BCJSetValue(dict, key, NSString.class, 0, nil, target, targetKey);
}



#pragma mark - Set NSMutableString continuations
//KVC result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(NSArray *array, NSUInteger idx, BCJGetterOptions options, NSMutableString *defaultValue, id target, NSString *targetKey) {
    return BCJSetValue(array, idx, NSMutableString.class, options, defaultValue, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(NSArray *array, NSUInteger idx, id target, NSString *targetKey) {
    return BCJSetValue(array, idx, NSMutableString.class, 0, nil, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(NSDictionary *dict, id key, BCJGetterOptions options, NSMutableString *defaultValue, id target, NSString *targetKey) {
    return BCJSetValue(dict, key, NSMutableString.class, options, defaultValue, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMutableString(NSDictionary *dict, id key, id target, NSString *targetKey) {
    return BCJSetValue(dict, key, NSMutableString.class, 0, nil, target, targetKey);
}



#pragma mark - Set NSNumber continuations
//KVC result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(NSArray *array, NSUInteger idx, BCJGetterOptions options, NSNumber *defaultValue, id target, NSString *targetKey) {
    return BCJSetValue(array, idx, NSNumber.class, options, defaultValue, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(NSArray *array, NSUInteger idx, id target, NSString *targetKey) {
    return BCJSetValue(array, idx, NSNumber.class, 0, nil, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(NSDictionary *dict, id key, BCJGetterOptions options, NSNumber *defaultValue, id target, NSString *targetKey) {
    return BCJSetValue(dict, key, NSNumber.class, options, defaultValue, target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNumber(NSDictionary *dict, id key, id target, NSString *targetKey) {
    return BCJSetValue(dict, key, NSNumber.class, 0, nil, target, targetKey);
}



#pragma mark - Set NSNull continuations
//KVC result-style
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(NSArray *array, NSUInteger idx, BCJGetterOptions options, id target, NSString *targetKey) {
    NSCAssert(shouldReplaceNullWithNil(options), @"Invalid option <BCJGetterOptionReplaceNullWithNil> is not permitted when setting NSNull");
    return BCJSetValue(array, idx, NSNull.class, options, [NSNull null], target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(NSArray *array, NSUInteger idx, id target, NSString *targetKey) {
    return BCJSetValue(array, idx, NSNull.class, 0, [NSNull null], target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(NSDictionary *dict, id key, BCJGetterOptions options, id target, NSString *targetKey) {
    NSCAssert(shouldReplaceNullWithNil(options), @"Invalid option <BCJGetterOptionReplaceNullWithNil> is not permitted when setting NSNull");
    return BCJSetValue(dict, key, NSNull.class, options, [NSNull null], target, targetKey);
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetNull(NSDictionary *dict, id key, id target, NSString *targetKey) {
    return BCJSetValue(dict, key, NSNull.class, 0, [NSNull null], target, targetKey);
}



#pragma mark - Get Enum continuations
//KVC style
id<BCLContinuation> BCJ_OVERLOADABLE BCJGetEnum(NSArray *array, NSUInteger idx, BCJGetterOptions options, id defaultValue, NSDictionary *enumMapping, void(^successBlock)(id enumValue)) {
    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        //Get the value
        NSString *enumString;
        if (!getValue(array, idx, NSString.class, options, defaultValue, &enumString, outError)) return NO;

        //Look up the value in the mapping
        id value = [enumMapping objectForKey:enumString];
        if (value == nil) {
            *outError = [NSError errorWithDomain:@"TODO: value not found in mapping" code:0 userInfo:nil];
            return NO;
        }

        //Success
        successBlock(value);
        return YES;
    });
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJGetEnum(NSDictionary *dict, id key, BCJGetterOptions options, id defaultValue, NSDictionary *enumMapping, void(^successBlock)(id enumValue)) {
    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        //Get the value
        NSString *enumString;
        if (!getValue(dict, key, NSString.class, options, defaultValue, &enumString, outError)) return NO;

        //Look up the value in the mapping
        id value = [enumMapping objectForKey:enumString];
        if (value == nil) {
            *outError = [NSError errorWithDomain:@"TODO: value not found in mapping" code:0 userInfo:nil];
            return NO;
        }

        //Success
        successBlock(value);
        return YES;
    });
}



#pragma mark - Set Enum continuations
//KVC style
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetEnum(NSArray *array, NSUInteger idx, BCJGetterOptions options, id defaultValue, NSDictionary *enumMapping, id target, NSString *targetKey) {
    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        //Get the value
        NSString *enumString;
        if (!getValue(array, idx, NSString.class, options, defaultValue, &enumString, outError)) return NO;

        //Look up the value in the mapping
        id value = [enumMapping objectForKey:enumString];
        if (value == nil) {
            *outError = [NSError errorWithDomain:@"TODO: value not found in mapping" code:0 userInfo:nil];
            return NO;
        }

        //Success
        [targetKey setValue:value forKey:targetKey];
        return YES;
    });
}



id<BCLContinuation> BCJ_OVERLOADABLE BCJSetEnum(NSDictionary *dict, id key, BCJGetterOptions options, id defaultValue, NSDictionary *enumMapping, id target, NSString *targetKey) {
    return BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        //Get the value
        NSString *enumString;
        if (!getValue(dict, key, NSString.class, options, defaultValue, &enumString, outError)) return NO;

        //Look up the value in the mapping
        id value = [enumMapping objectForKey:enumString];
        if (value == nil) {
            *outError = [NSError errorWithDomain:@"TODO: value not found in mapping" code:0 userInfo:nil];
            return NO;
        }

        //Success
        [targetKey setValue:value forKey:targetKey];
        return YES;
    });
}
