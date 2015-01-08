//
//  BCJSONPathEvaluation.h
//  BCJSONReader
//
//  Created by Benedict Cohen on 08/01/2015.
//  Copyright (c) 2015 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCJDefines.h"


/**
 Evaluates a JSONPath against object.

 @param JSONPath              <#JSONPath description#>
 @param object                <#object description#>
 @param outFailedComponentIdx <#outFailedComponentIdx description#>
 @param outFailedComponent    <#outFailedComponent description#>

 @return <#return value description#>
 */
id BCJEvaluateJSONPath(NSString *JSONPath, id object, NSUInteger *outFailedComponentIdx, id *outFailedComponent) BCJ_REQUIRED(1,2);
