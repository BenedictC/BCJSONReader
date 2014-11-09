//
//  BCJEnumerateJSONPathComponents.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 05/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 
 TODO: How do we describe the path in BNF?
 
 path = component | ???

 identifier
 subscript

 */

NSError *BCJEnumerateJSONPathComponents(NSString *JSONPath, void(^enumerator)(id component, NSUInteger componentIdx, BOOL *stop));
