//
//  BCJSourceObject.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 17/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#ifndef BCJSOURCEOBJECT_H_
#define BCJSOURCEOBJECT_H_

#import <Foundation/Foundation.h>



/**
 BCJSourceObject is used by BCJJSONSource to access the root object before parsing a JSON path. It exists to allow the indirection required by BCJContainer.
 */
@protocol BCJSourceObject <NSObject>

/**
 The object that BCJJSONSource should use to evaluate a JSONPath.

 @return An object.
 */
-(id)BCJ_sourceObject;

@end


/**
 Returns the object that should be used to evaluate a JSONPath.

 @param object The object to get the source object from.

 @return an object.
 */
static inline id BCJSourceObjectForObject(id object) {
    return ([object respondsToSelector:@selector(BCJ_sourceObject)]) ? [object BCJ_sourceObject] : object;
}

#endif