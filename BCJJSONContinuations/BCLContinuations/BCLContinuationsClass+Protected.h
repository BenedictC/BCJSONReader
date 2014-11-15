//
//  BCLContinuationsClass+Protected.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 30/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLContinuations.h"



@interface BCLContinuations (Protected)
/**
 <#Description#>

 @param continuations <#continuations description#>

 @return <#return value description#>
 */
+(NSError *)untilEndWithContinuations:(NSArray *)continuations;
+(NSError *)untilErrorWithContinuations:(NSArray *)continuations;

@end
