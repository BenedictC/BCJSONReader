//
//  BCJSourceObject.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 17/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>



/**
 BCJSourceObject is used by BCJJSONSource to access the root object before parsing a JSON path. It exists to allow the indirection required by BCJContainer.
 */
@protocol BCJSourceObject <NSObject>

/**
 The object that BCJJSONSource should use as the start of the chain.

 @return An object.
 */
-(id)BCJ_sourceObject;

@end



@interface NSObject (BCJSourceObject)

@end

