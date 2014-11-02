//
//  main.m
//  TypeCheckedCollectionAccess
//
//  Created by Benedict Cohen on 20/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BCJJSONContinuations.h"



@interface TestObject : NSObject
@property NSInteger aNumber;
@property NSString *string;
@property NSArray *addresses;
@property NSString *postCode;
@end

@implementation TestObject

-(NSString *)description
{
    return [NSString stringWithFormat:@"<%@> %@", super.description, @(self.aNumber)];
}

@end



int main(int argc, const char * argv[]) {
    @autoreleasepool {

        //Input data
        NSData *jsonData = ({
            NSDictionary *sourceObject = @{
                                       @"number": @7,
                                       @"string": @"arf",
                                       @"dict" : @{
                                               @"one": @(1),
                                               @"two": @(2),
                                               @"three": @(3),
                                               @"four": @(4),
                                               @"five": @(5)
                                               },
                                       };
            [NSJSONSerialization dataWithJSONObject:sourceObject options:0 error:NULL];
        });

        //Output objects
        TestObject *target = [TestObject new];
        NSString *string = @"adfsgd";

        //Run the continuation
        NSError *error = ({
            //Create a container to store the JSON in.
            BCJContainer *json = [BCJContainer new];

            //Go!
            [BCLContinuation untilError:

             //Fill the json container
             BCJDeserializeJSON(jsonData, json),

//             //Set a type mismatched value (this will fail in DEBUG due to an assert against type mismatches.)
//             BCJSetNumber(json, @"number", target, BCJ_KEY(string)),

             BCJSetString(json, @"string", target, BCJ_KEY(aNumber)),
             //Get a value and validate & set it.
             BCJGetValue(json, @"string", NSString.class, BCJGetterModeMantatory, nil, ^BOOL(id value, NSError **outError) {
                BCJValidateAndSet(value, @"SELF == 'arf!!'", target, BCJ_KEY(string), outError);
                return YES;
            }),

             //Set an array property by mapping a collection
             BCJSetMap(json, @"dict", NSNumber.class, BCJMapModeMandatory, target, BCJ_KEY(addresses), @"aNumber", ^id(NSString *key, NSNumber *number, NSError **outError){
                TestObject *address = [TestObject new];
                address.aNumber = [number integerValue];

                return address;
             }),

             //Set a stack variable
             BCJSetValue(json, @"string", NSMutableString.class, BCJGetterModeDefaultable, @"default", &string),

             nil];
        });

        NSLog(@"%@", target.addresses);
        NSLog(@"error: %@", error);
    }
    return 0;
}
