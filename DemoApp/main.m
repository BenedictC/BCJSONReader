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
                                       @"status": @"failed",
                                       @"reason": @"arf",
//                                       @"dict" : @{
//                                               @"one": @(1),
//                                               @"two": @(2),
//                                               @"three": @(3),
//                                               @"four": @(4),
//                                               @"five": @(5)
//                                               },
                                       };
            [NSJSONSerialization dataWithJSONObject:sourceObject options:0 error:NULL];
        });

        //Output objects
        TestObject *target = [TestObject new];
        __block NSString * targetString = @"adfsgd";
        __block id resonseError = nil;

        //Go!
        BCJContainer *json = [BCJContainer new]; //Create a container to store the JSON in.
        NSError *error = [BCLContinuation untilError:

         //Deserialization:
         BCJDeserializeJSON(jsonData, json),

         //Get the value we need to switch on
         BCJGetValue(json, @"status", NSString.class, BCJGetterModeMantatory, nil, ^BOOL(NSString *status, NSError *__autoreleasing *outError) {

            //Does the JSON look like a failure?
            if (![status isEqualToString:@"success"]) {
                return [BCLContinuation withError:outError untilEnd:
                             BCJSetString(resonseError, BCJ_KEY(reason), json, @"reason"),
                        nil];
            }

            return [BCLContinuation withError:outError untilError:

                    //StandardTypes:
                    BCJSetString(target, BCJ_KEY(aNumber), json, @"string"),
                    //Set a type mismatched value (this will fail in DEBUG due to an assert against type mismatches.)
                    //BCJSetNumber(target, BCJ_KEY(string), json, @"number"),

                    //AdditionalTypes:
                    BCJSetDateFromISO8601String(target, BCJ_KEY(date), json, @"date"),

                    //GettersAndSetters:
                    BCJGetValue(json, @"string", NSString.class, BCJGetterModeDefaultable, @"default", ^BOOL(NSString *string, NSError **outValue){
                                    targetString = string;
                                    return YES;
                                }),
                    BCJGetValue(json, @"string", NSString.class, BCJGetterModeMantatory, nil, ^BOOL(id value, NSError **outError) {
                                    //Validation:
                                    BCJValidateAndSet(value, @"SELF == 'arf!!'", target, BCJ_KEY(string), outError);
                                    return YES;
                                }),

                    //Map:
                    BCJSetMap(target, BCJ_KEY(addresses), json, @"dict", NSNumber.class, BCJMapModeMandatory, @"aNumber", ^id(NSString *key, NSNumber *number, NSError **outError){
                                 TestObject *address = [TestObject new];
                                 address.aNumber = [number integerValue];
                                 return address;
                              }),
                    nil];
         }),
         nil];

        NSLog(@"%@", target.addresses);
        NSLog(@"error: %@", error);
    }
    return 0;
}
