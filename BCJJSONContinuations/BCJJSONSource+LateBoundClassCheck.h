//
//  BCJJSONSource+LateBoundClassCheck.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 08/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJJSONSource.h"



@interface BCJJSONSource (LateBoundClassCheck)

-(BOOL)getValue:(id *)value ofKind:(Class)lateBoundClass error:(NSError **)outError;

@end
