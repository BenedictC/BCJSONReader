//
//  BCJStackSource.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 21/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJSourceConstants.h"
#import "BCJDefines.h"

@class BCJSource;



/**

 TODO: 

*/

#pragma mark - Source pushing/popping
void BCJPushSourceObject(id sourceObject) BCJ_REQUIRED(1);
id BCJTopSourceObject();
void BCJPopSourceObject(void);



#pragma mark - BCJSource constructors for sources that use the top object on the source stack
BCJSource * BCJ_OVERLOADABLE BCJCreateSource(NSString *JSONPath, Class expectClass, BCJSourceOptions options, id defaultValue) BCJ_REQUIRED(1);

BCJSource * BCJ_OVERLOADABLE BCJCreateSource(NSString *JSONPath, BCJSourceOptions options, id defaultValue) BCJ_REQUIRED(1);
BCJSource * BCJ_OVERLOADABLE BCJCreateSource(NSString *JSONPath, BCJSourceOptions options) BCJ_REQUIRED(1);
BCJSource * BCJ_OVERLOADABLE BCJCreateSource(NSString *JSONPath) BCJ_REQUIRED(1);
