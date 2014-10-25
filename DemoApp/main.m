//
//  main.m
//  TypeCheckedCollectionAccess
//
//  Created by Benedict Cohen on 20/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCMJSONAccess.h"



int main(int argc, const char * argv[]) {
    @autoreleasepool {

        NSDictionary *json = @{@"number": @7};

        ATTEMPT({
            BCPSetAbandonOnError(YES);
            NSNumber *number  = BCPDictionaryGetMandatoryObject(json, @"number", [NSNumber class]);

            NSInteger integer = BCPDictionaryGetMandatoryInteger(json, @"number");
            id string = BCPDictionaryGetMandatoryString(json, @"number");
            [string self];

            NSLog(@"%@, %ld", number, integer);
        })
        SALVAGE({
            NSLog(@"Failed with errors: %@", FAILURE_INFO(BCPErrorsKey));
        });
    }

    NSLog(@"Bye!");

    return 0;
}
