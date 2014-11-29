//
//  BCJSource.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 04/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCJDefines.h"
#import "BCJSourceConstants.h"



#pragma mark - BCJSource
/**
 BCJSource encapsulates the process of fetching a value. It does so by querying object with the components from JSONPath. 
 
 The behaviour of getValue:error: is modified be specifying options.
 
 A valid JSONPath path is comprised of one or more path components. A path component takes one of the following forms:
 - subscript component. A pair of square braces containing one of the following:
    - an integer
    - a single quote delimitted string. Single quotes are escaped with the '`' character. Literal '`' are represented with as '``'.
    - a period.
 - identifier component: a string that starts with the a character matching the regex a-z|A-Z|$|_ followed by zero of more characters matching a-z|A-Z|$|_|0-9 . Identifier components must be terminated with a '.' except if the component is the final component in the path.

 Note that the allowable characters for an identifier component is a subset of the allowable characters for a Javascript identifier which allows for many unicode codepoints. If a unicode character is required then a subscript component should be used.

 Examples of valid JSONPaths:
 accountId
 events[0].date
 ['events'][0]['date']
 ['']
 [.]
 $schema
 
 In general the BCJSource convience factory functions should be used in favour of this method.

 */
@interface BCJSource : NSObject
/**
 Initalizes an instances.

 @param object        The object to evaluate the JSONPath against. If object implements containedObject then its' return value is used instead of the object.
 @param JSONPath      A valid JSONPath string.
 @param expectedClass the class that the fetched object is expected to be.
 @param options       the options describing the behaviour of getValue:error:
 @param defaultValue  the default value to use if options dictate it is required.

 @return a BCJSource.
 */
-(instancetype)initWithObject:(id)object JSONPath:(NSString *)JSONPath expectedClass:(Class)expectedClass options:(BCJSourceOptions)options defaultValue:(id)defaultValue;

@property(nonatomic, readonly) id object;
@property(nonatomic, readonly) NSString *JSONPath;
@property(nonatomic, readonly) Class expectedClass;
@property(nonatomic, readonly) BCJSourceOptions options;
@property(nonatomic, readonly) id defaultValue;

/**
 Returns by reference the value found in object by evaluating the JSONPath. After evaluating JSONPath the following steps occur:
 1. Checks if the evaluation completed. If it did not and BCJSourceOptionPathMustEvaluateToValue is set then returns an error.
 2. If BCJSourceOptionReplaceNullWithNil is set and value is NSNull converts replaces value with nil.
 3. If BCJSourceOptionTreatValueNotFoundAsSuccess is NOT set and value is nil then returns BCJSourceResultValueNotFound
 4. If value is nil then replaces value with defaultValue
 5. Checks that value is of the expectClass and returns BCJSourceResultFailure if it is not
 6. Sets the the outValue

 @param value    On success contains the fetched value, otherwise nil.
 @param outError On failure contains an NSError describing the reason for failure, otherwise nil.

 @return The result status.
 */
-(BCJSourceResult)getValue:(id *)value error:(NSError **)outError;

@end



#pragma mark - Constructors
BCJSource * BCJ_OVERLOADABLE BCJCreateSource(id object, NSString *JSONPath, Class expectClass, BCJSourceOptions options, id defaultValue) BCJ_REQUIRED(1,2);
BCJSource * BCJ_OVERLOADABLE BCJCreateSource(id object, NSString *JSONPath, BCJSourceOptions options, id defaultValue) BCJ_REQUIRED(1,2);
BCJSource * BCJ_OVERLOADABLE BCJCreateSource(id object, NSString *JSONPath, BCJSourceOptions options) BCJ_REQUIRED(1,2);
BCJSource * BCJ_OVERLOADABLE BCJCreateSource(id object, NSString *JSONPath) BCJ_REQUIRED(1,2);
