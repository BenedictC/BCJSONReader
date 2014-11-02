//
//  BCJJSONCore.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 30/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#ifndef BCJJSONContinuations_BCJJSONCore_h
#define BCJJSONContinuations_BCJJSONCore_h

#import "BCJDefines.h"
#import "BCJConstants.h"
#import "BCJContainerProtocols.h"



#pragma mark - BCJGetterOptions helper functions
static inline BOOL BCJIsOptionSet(NSInteger option, NSInteger options) {
    return (options & option) != 0;
}

static inline BOOL BCJShouldReplaceNullWithNil(BCJGetterOptions options) {
    return (options & BCJGetterOptionReplaceNullWithNil) != 0;
}

static inline BOOL BCJShouldReplaceNilWithDefaultValue(BCJGetterOptions options) {
    return (options & BCJGetterOptionReplaceNilWithDefaultValue) != 0;
}

static inline BOOL BCJShouldAllowNilValue(BCJGetterOptions options) {
    return (options & BCJGetterOptionAllowsNilValue) != 0;
}



#pragma mark - Getter functions
static inline BOOL BCJ_OVERLOADABLE BCJGetValue(id<BCJIndexedContainer> array, NSUInteger idx, Class class, BCJGetterOptions options, id defaultValue, id *outValue, NSError **outError) {
    //Reset outValue
    *outValue = nil;

    //Check bounds
    BOOL isInBounds = idx < array.count;
    if (!isInBounds) {
        if (outError == NULL) {
            NSString *format = NSLocalizedString(@"Index <%@> is out of bounds for collection <%@>. Expected instance of <%@>.", nil);
            NSString *description = [NSString stringWithFormat:format, @(idx), array, NSStringFromClass(class)];
            *outError = [NSError errorWithDomain:BCJErrorDomain code:BCJIndexOutOfBoundsError userInfo:@{NSLocalizedDescriptionKey:description}];
        }
        return NO;
    }

    //Fetch value
    id value = [array objectAtIndex:idx];

    //Fix up null
    if (BCJShouldReplaceNullWithNil(options) && [value isKindOfClass:NSNull.class]) {
        value = defaultValue;
    }

    //Replace nil with default
    if (BCJShouldReplaceNilWithDefaultValue(options) && value == nil) {
        value = defaultValue;
    }

    //Check for optionals
    if (!BCJShouldAllowNilValue(options) && value == nil) {
        if (outError == NULL) {
            NSString *format = NSLocalizedString(@"Object at index <%@> of collection <%@> is nil. Expected instance of <%@>.", nil);
            NSString *description = [NSString stringWithFormat:format, @(idx), array, NSStringFromClass(class)];
            *outError = [NSError errorWithDomain:BCJErrorDomain code:BCJMissingValueError userInfo:@{NSLocalizedDescriptionKey:description}];
        }
        return NO;
    }

    //Type check value
    BOOL shouldCheckClass = value != nil;
    BOOL isIncorrectKind = ![value isKindOfClass:class];
    if (shouldCheckClass && isIncorrectKind) {
        if (outError == NULL) {
            NSString *format = NSLocalizedString(@"Object at index <%@> of collection <%@> is of unexpected type. Expected instance of <%@> but found instance of <%@>.", nil);
            NSString *description = [NSString stringWithFormat:format, @(idx), array, NSStringFromClass(class), NSStringFromClass([value class])];
            *outError = [NSError errorWithDomain:BCJErrorDomain code:BCJUnexpectedTypeError userInfo:@{NSLocalizedDescriptionKey:description}];
        }
        return NO;
    }

    *outValue = value;
    return YES;
}



static inline BOOL BCJ_OVERLOADABLE BCJGetValue(id<BCJKeyedContainer> dict, id key, Class class, BCJGetterOptions options, id defaultValue, id __strong* outValue, NSError **outError) {
    //Reset outValue
    //    id<BCJKeyedContainer> dict = *dictRef;
    *outValue = nil;

    //Fetch value
    id value = [dict objectForKey:key];

    //Fix up null value
    if (BCJShouldReplaceNullWithNil(options) && [value isKindOfClass:NSNull.class]) {
        value = nil;
    }

    //Use default value?
    if (BCJShouldReplaceNilWithDefaultValue(options) && value == nil) {
        value = defaultValue;
    }

    //Check for nil
    if (!BCJShouldAllowNilValue(options) && value == nil) {
        if (outError == NULL) {
            NSString *format = NSLocalizedString(@"Object for key <%@> of collection <%@> is nil. Expected instance of <%@>.", nil);
            NSString *description = [NSString stringWithFormat:format, key, dict, NSStringFromClass(class)];
            *outError = [NSError errorWithDomain:BCJErrorDomain code:BCJMissingValueError userInfo:@{NSLocalizedDescriptionKey:description}];
        }
        return NO;
    }

    //Check for type
    BOOL shouldCheckClass = value != nil;
    BOOL isIncorrectKind = ![value isKindOfClass:class];
    if (shouldCheckClass && isIncorrectKind) {
        if (outError == NULL) {
            NSString *format = NSLocalizedString(@"Object for key <%@> of collection <%@> is of unexpected type. Expected instance of <%@> but found instance of <%@>.", nil);
            NSString *description = [NSString stringWithFormat:format, key, dict, NSStringFromClass(class), NSStringFromClass([value class])];
            *outError = [NSError errorWithDomain:BCJErrorDomain code:BCJUnexpectedTypeError userInfo:@{NSLocalizedDescriptionKey:description}];
        }
        return NO;
    }
    
    *outValue = value;
    return YES;
}



#pragma mark - Setter function
#ifdef DEBUG
@import ObjectiveC.runtime;
#endif
static inline BOOL BCJ_OVERLOADABLE BCJSetValue(id target, NSString *targetKey, id value, NSError **outError)
{
#ifdef DEBUG
    //KVC will work regardless of type which means type mismatch bugs can occur. We add type checking for DEBUG builds
    //to catch these bugs early.

    ^{
        //0. ensure we have a value to check
        if (value == nil) return;

        //1. Look for a *property* matching targetKey
        objc_property_t property = class_getProperty([target class], targetKey.UTF8String);
        if (property != NULL) {
            NSString *className = ({
                NSString *propertyString = [NSString stringWithUTF8String:property_getAttributes(property)];

                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^T@\"([^\"]*)\"" options:0 error:NULL];
                NSTextCheckingResult *match = [regex firstMatchInString:propertyString options:0 range:NSMakeRange(0, [propertyString length])];
                NSRange range = [match rangeAtIndex:1];
                (match == nil) ? nil : [propertyString substringWithRange:range];
            });

            if (className != nil) {
                Class class = NSClassFromString(className);
                NSCAssert([value isKindOfClass:class], ({
                        [NSString stringWithFormat:@"Attempted to set an object of type <%@> to an ivar of type <%@> for key <%@> of object <%@>.", NSStringFromClass([value class]), NSStringFromClass(class), targetKey, target];
                         }));
                return;
            }
            //TODO: Check non-object types
        }

        //2. Look for an *ivar* matching targetKey
        unsigned int outCount;
        Ivar *ivars = class_copyIvarList([target class], &outCount);
        //Wrap the buffer so that it's automatically freed when we return.
        NSData *ivarsData = [NSData dataWithBytesNoCopy:ivars length:sizeof(ivars) * outCount freeWhenDone:YES];
        for (unsigned int i = 0; i < outCount; i++) {
            Ivar ivar = ivars[i];
            NSString *ivarName = [NSString stringWithFormat:@"%s", ivar_getName(ivar)];
            BOOL isMatch = ([ivarName isEqualToString:targetKey]) || [ivarName isEqualToString:[@"_" stringByAppendingString:targetKey]];
            if (!isMatch) continue;

            NSString *encoding = [NSString stringWithFormat:@"%s", ivar_getTypeEncoding(ivar)];
            BOOL isObject = [encoding hasPrefix:@"@"];
            if (isObject) {
                NSRange range = NSMakeRange(2, encoding.length-3);
                NSString *className = [encoding substringWithRange:range];
                Class class = NSClassFromString(className);
                NSCAssert([value isKindOfClass:class], ({
                    [NSString stringWithFormat:@"Attempted to set an object of type <%@> to an ivar of type <%@> for key <%@> of object <%@>.", NSStringFromClass([value class]), NSStringFromClass(class), targetKey, target];
                }));
                return;
            }
            //TODO: Check non-object types
        }
        //Force the buffer to be retained until the end of the function.
        [ivarsData self];
    }();
#endif

    //If the target is nil then there's no point in continuing.
    if (target == nil) return YES;

    //Validate using KVC
    id validatedValue = value;
    if (![target validateValue:&validatedValue forKey:targetKey error:outError]) {
        return NO;
    }

    //Done!
    //Note that we're using the validatedValue
    [target setValue:validatedValue forKey:targetKey];
    return YES;
}



#endif
