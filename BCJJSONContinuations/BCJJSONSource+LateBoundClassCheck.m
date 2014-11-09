//
//  BCJJSONSource+LateBoundClassCheck.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 08/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJJSONSource+LateBoundClassCheck.h"
#import "BCJError.h"



@implementation BCJJSONSource (LateBoundClassCheck)

-(BOOL)getValue:(id *)value ofKind:(Class)lateBoundClass error:(NSError **)outError
{
    if (![self getValue:value error:outError]) return NO;

    //Type check value
    BOOL shouldCheckClass = *value != nil;
    BOOL isCorrectKind = lateBoundClass == nil || [*value isKindOfClass:lateBoundClass];
    if (shouldCheckClass && !isCorrectKind) {
        if (outError == NULL) {
            NSString *criteria = [NSString stringWithFormat:@"value.class != %@", NSStringFromClass(lateBoundClass)];
            *outError = [BCJError invalidValueErrorWithJSONSource:self value:*value criteria:criteria];
        }

        //Reset the value and fail
        *value = nil;
        return NO;
    }

    return YES;
}

@end
