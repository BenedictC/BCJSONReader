//
//  BCJStackJSONSource.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 21/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJJSONSourceConstants.h"
#import "BCJDefines.h"

@class BCJJSONSource;



#pragma mark - Source pushing/popping
void BCJPushSourceObject(id sourceObject) BCJ_REQUIRED(1);
id BCJTopSourceObject();
void BCJPopSourceObject(void);



#pragma mark - BCJJSONSource constructors for sources that use the top object on the source stack
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(NSString *JSONPath, Class expectClass, BCJJSONSourceOptions options, id defaultValue) BCJ_REQUIRED(1);

BCJJSONSource * BCJ_OVERLOADABLE BCJSource(NSString *JSONPath, BCJJSONSourceOptions options, id defaultValue) BCJ_REQUIRED(1);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(NSString *JSONPath, BCJJSONSourceOptions options) BCJ_REQUIRED(1);
BCJJSONSource * BCJ_OVERLOADABLE BCJSource(NSString *JSONPath) BCJ_REQUIRED(1);
