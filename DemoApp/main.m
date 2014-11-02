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
@property NSInteger number;
@property NSString *string;
@property NSArray *array;
@property NSDate *date;
@end

@implementation TestObject

-(NSString *)description
{
    return [NSString stringWithFormat:@"<%@> %@", super.description, @(self.number)];
}

@end



int main(int argc, const char * argv[]) {
    @autoreleasepool {

        //Input data
        NSData *jsonData = ({
            NSDictionary *sourceObject = @{
                                       @"status": @"failed",
                                       @"reason": @"arf",
                                       @"numbers" : @{
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
        __block NSString * targetString = @"adfsgd";

        //Go!
        BCJContainer *json = [BCJContainer new]; //Create a container to store the JSON in.
        NSError *error = [BCLContinuation untilError:
                    //Deserialization:
                    BCJDeserializeJSON(json, jsonData),

                    //StandardTypes:
                    BCJSetString(target, BCJ_KEY(string), json, @"reason"),
                    //Set a type mismatched value (this will fail in DEBUG due to an assert against type mismatches.)
                    //BCJSetNumber(target, BCJ_KEY(string), json, @"number"),

                    //AdditionalTypes:
                    BCJSetDateFromISO8601String(target, BCJ_KEY(date), json, @"date", BCJGetterModeOptional, nil),

                    //GettersAndSetters:
                    BCJGetValue(json, @"string", NSString.class, BCJGetterModeDefaultable, @"default", ^BOOL(NSString *string, NSError **outValue){
                                    targetString = string;
                                    return YES;
                                }),
//                    //Map:
                    BCJSetMap(target, BCJ_KEY(array), json, @"numbers", NSNumber.class, BCJMapModeMandatory, BCJ_SORT_DESCRIPTORS(@"self"), ^id(NSString *key, NSNumber *number, NSError **outError){
                                NSLog(@"%@", key);
                                return number;
                              }),
                    nil];

        NSLog(@"integer: %@", @(target.number));
        NSLog(@"string: %@", target.string);
        NSLog(@"array: %@", target.array);
        NSLog(@"date: %@", target.date);

        NSLog(@"error: %@", error);
    }
    return 0;
}
