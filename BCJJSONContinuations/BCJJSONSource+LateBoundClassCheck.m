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

-(BCJSourceResult)getValue:(id *)value ofKind:(Class)lateBoundClass error:(NSError **)outError
{
    //We only need to do the check if a value has be fetched
    BCJSourceResult result = [self getValue:value error:outError];
    if (result != BCJSourceResultSuccess) return result;

    //Perform the check
    BOOL shouldCheckClass = *value != nil;
    BOOL isCorrectKind = lateBoundClass == nil || [*value isKindOfClass:lateBoundClass];
    if (shouldCheckClass && !isCorrectKind) {
        if (outError == NULL) {
            NSString *criteria = [NSString stringWithFormat:@"value.class != %@", NSStringFromClass(lateBoundClass)];
            *outError = [BCJError invalidValueErrorWithJSONSource:self value:*value criteria:criteria];
        }
        //Reset the value and fail
        *value = nil;
        return BCJSourceResultFailure;
    }

    return BCJSourceResultSuccess;
}

@end
