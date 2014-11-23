//
//  BCJJSONSourceObjectProtocol.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 17/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>



/**
 The BCJContainer provides functionality for deferring access to an object. It is used by BJCContainerJSONSource.
 */
@protocol BCJContainer <NSObject>

/**
 The object that BCJJSONSource should use to evaluate a JSONPath.

 @return An object.
 */
-(id)containedObject;

@end
