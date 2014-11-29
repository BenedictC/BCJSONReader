//
//  BCJContainer.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 30/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>



/**
 BCJContainer acts as a wrapper for defering JSON deserialization.
 
 The contents of the container can be set only once. Once the content is set the container becomes sealed. Attempting to set the content on sealed container will result in an exception being raised.

 */
@interface BCJContainer : NSObject

/**
 Initializes the container with the supplied content.

 @param content The content. Raises an exception if content is nil.

 @return A container
 */
-(instancetype)initWithContent:(id)content;

/**
 The containers content.
 */
@property(nonatomic, readonly) id content;

/**
 The sealed status of the container.
 */
@property(nonatomic, readonly, getter = isSealed) BOOL sealed;

/**
 Sets the content and seals the container. Raises an exception if the container is already sealed.

 @param object the object to use as the content. Raises an exception if nil.
 */
-(void)setContentAndSeal:(id)object;

@end
