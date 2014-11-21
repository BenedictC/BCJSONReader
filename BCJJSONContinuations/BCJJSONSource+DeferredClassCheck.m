//
//  BCJJSONSource+DeferredClassCheck.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 08/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJJSONSource+DeferredClassCheck.h"
#import "BCJError.h"



@implementation BCJJSONSource (DeferredClassCheck)

-(BCJJSONSourceResult)getValue:(id *)value ofKind:(Class)class error:(NSError **)outError
{
    //We only need to do the check if a value has be fetched
    BCJJSONSourceResult result = [self getValue:value error:outError];
    if (result != BCJJSONSourceResultSuccess) return result;

    //Perform the check
    BOOL shouldCheckClass = *value != nil;
    BOOL isCorrectKind = class == nil || [*value isKindOfClass:class];
    if (shouldCheckClass && !isCorrectKind) {
        if (outError != NULL) {
            NSString *criteria = [NSString stringWithFormat:@"value.class != %@", NSStringFromClass(class)];
            *outError = [BCJError invalidValueErrorWithJSONSource:self value:*value criteria:criteria];
        }
        //Reset the value and fail
        *value = nil;
        return BCJJSONSourceResultFailure;
    }

    return BCJJSONSourceResultSuccess;
}

@end
