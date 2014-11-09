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
                                       @"number": @1234,
                                       @"string": @"arf",
                                       @"dict" : @{
                                               @"one": @(1),
                                               @"two": @(2),
                                               @"three": @(3),
                                               @"four": @(4),
                                               @"five": @(5)
                                               },
                                       @"date" : @([[NSDate new] timeIntervalSince1970]),
                                       @"otherString": @"boom!",
                                       };
            [NSJSONSerialization dataWithJSONObject:sourceObject options:0 error:NULL];
        });

        //Output objects
        TestObject *target = [TestObject new];
        __block NSString *stackString = @"adfsgd";
        //Go!
        BCJContainer *json = [BCJContainer new]; //Create a container to store the JSON in.
        NSError *error = [BCLContinuation untilError:
                          //Deserialization:
                          BCJDeserializeJSON(json, jsonData),
                          //StandardTypes:
                          BCJSetString(BCJ_TARGET(target, string), BCJSource(json, @"string")),
                          BCJSetNumber(BCJ_TARGET(target, number), BCJSource(json, @"number")),
//
//                          BCJSetString(BCJSource(json, @"string"), BCJ_TARGET(target, string)),
//                          BCJSetNumber(BCJSource(json, @"number"), BCJ_TARGET(target, number)),

                          //AdditionalTypes:
                          BCJSetDateFromTimeIntervalSinceEpoch(BCJ_TARGET(target, date), BCJSource(json, @"date", BCJSourceModeOptional)),
                          //Map:
                          BCJSetMap(BCJ_TARGET(target, array), BCJSource(json, @"dict"), NSNumber.class, BCJMapOptionDiscardMappingErrors, BCJ_SORT_DESCRIPTORS(@"self"), ^id(NSString *key, NSNumber *number, NSError **outError){
                                        return @([number integerValue] * 1000);
                                    }),
                          //Getters:
                          BCJGetValue(BCJSource(json, @"otherString", BCJSourceModeDefaultable, @"default", NSString.class), ^BOOL(NSString *string, NSError **outValue){
                                        stackString = string;
                                        return YES;
                                     }),
                          nil];

        NSLog(@"target.string: %@", target.string);
        NSLog(@"target.number: %@", @(target.number));
        NSLog(@"target.date: %@", target.date);
        NSLog(@"target.array: %@", target.array);

        NSLog(@"stackString: %@", stackString);

        NSLog(@"error: %@", error);
    }
    return 0;
}
