//
//  BCJJSONSource+DeferredClassCheck.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 08/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJJSONSource.h"



@interface BCJJSONSource (DeferredClassCheck)

/**
 Calls getValue:error: and then performs an additional type check. This method is used by type-specific continuations so that sources can be created without an expectedClass.

 @param value    On success contains the fetched value, otherwise nil.
 @param class    The expected class.
 @param outError On failure contains an NSError describing the reason for failure, otherwise nil.

 @return The result status.
 */
-(BCJJSONSourceResult)getValue:(id *)value ofKind:(Class)class error:(NSError **)outError;

@end
