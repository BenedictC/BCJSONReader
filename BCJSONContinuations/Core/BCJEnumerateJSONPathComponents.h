//
//  BCJEnumerateJSONPathComponents.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 05/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Parses a JSONPath for its components. A valid JSONPath path is comprised of one or more path components. A path component takes one of the following forms:
 - subscript component: square braces containing one of the following:
                        - an integer 
                        - a single quote delimitted string enclosed by square braces. Single quotes are escaped with the '`' character. Literal '`' are represented with as '``'.
                        - a ., eg "[.]"
 - identifier component: a string that starts with the a character matching the regex a-z|A-Z|$|_ followed by zero of more characters matching a-z|A-Z|$|_|0-9 . Identifier components must be terminated with a '.' except if the component is the final component in the path.
 
 Note that the allowable characters for an identifier component is a subset of the allowable characters for a Javascript identifier which allows for many unicode codepoints. If a unicode character is required then a subscript component should be used.
 
 Examples of valid JSONPaths:
 accountId
 events[0].date
 ['events'][0]['date']
 ['']
 $schema
 
 @param JSONPath    A string that represents a valid JSON path
 @param ^enumerator A block that will be invoked with each component of the JSONPath. Integer components are represented as an NSNumber object, string components as an NSString object and the 'this' component as NSNull.

 @return nil if the JSONPath was valid or if the parsing was stopped before an invalid compoent, other wise an NSError describing the location of the invalid component.
 */
NSError *BCJEnumerateJSONPathComponents(NSString *JSONPath, void(^enumerator)(id component, NSUInteger componentIdx, BOOL *stop));
