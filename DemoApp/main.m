//
//  main.m
//  TypeCheckedCollectionAccess
//
//  Created by Benedict Cohen on 20/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BCJMapper.h"
#import "BCJJSONContinuations.h"



@interface TestObject : NSObject
@property NSArray *array;
@property NSInteger number;
@property NSString *string;

@property NSDate *date;
@property NSURL *url;
@end

@implementation TestObject
@end



void demo(void) {
    //Input data
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
                                   @"array": @[@{@"url": @"http://johnlennon.com"},
                                               @{@"url": @"http://paulmccartney.com"},
                                               @{@"url": @"http://georgeharrison.com"},
                                               @{@"url": @"http://ringostarr.com"}],
                                   @"date" : @([[NSDate new] timeIntervalSince1970]), //Unix timestamp-style date
                                   };
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:sourceObject options:kNilOptions error:NULL];

    //Output objects
    TestObject *target = [TestObject new];
    __block NSString *stackString = nil;

    //Mapper-style
    NSError *mappingError =
    [BCJMapper mapJSONData:jsonData intoObject:target options:BCJNoOptions usingContinuations:
     BCJ_SET(@"array", array),
     BCJ_SET(@"number", number),
     BCJ_SET(@"array[0]", string),

//     BCJSetString(BCJSource(@"jsonPath"), BCJTarget(@"property")),
     nil];

//    //Continuations-style
//    BCJContainer *json = [BCJContainer new]; //Create a container to store the deserialized JSON in.
//    NSError *continuationsError =
//    [BCLContinuations untilError:
//         //Deserialization:
//         BCJDeserializeJSON(json, jsonData),
//
//         //StandardTypes:
//         BCJSetString(BCJSource(json, @"string"), BCJ_TARGET(target, string)),
//         BCJSetNumber(BCJSource(json, @"number"), BCJ_TARGET(target, number)),
//
//         //AdditionalTypes:
//         BCJSetURL(BCJSource(json, @"array[3].url"), BCJ_TARGET(target, url)),
//         BCJSetDateFromTimeIntervalSince1970(BCJSource(json, @"date", BCJJSONSourceModeStrict), BCJ_TARGET(target, date)),
//
//         //Map:
//         BCJSetMap(BCJSource(json, @"dict"), BCJ_TARGET(target, array), NSNumber.class, BCJMapOptionIgnoreFailedMappings, BCJ_SORT_DESCRIPTORS(@"self"), ^id(NSString *key, NSNumber *number, NSError **outError){
//            //Map a number to a textural description of number * 1000
//            static NSNumberFormatter *formatter = nil;
//            static dispatch_once_t onceToken;
//            dispatch_once(&onceToken, ^{
//                formatter = [NSNumberFormatter new];
//                formatter.numberStyle = NSNumberFormatterSpellOutStyle;
//            });
//            return [formatter stringFromNumber:@(number.integerValue * 1000)];
//        }),
//
//         //Generic getter:
//         BCJGetValue(BCJSource(json, @"missingString", NSString.class, BCJJSONSourceModeDefaultable, @"default"), ^BOOL(NSString *string, NSError **outError){
//            //Validation
//            if (!BCJValidate(string, @"self MATCHES '.*'", outError)) return NO;
//            stackString = string;
//            return YES;
//        }),
//
//     nil];

    //Log results
    NSLog(@"target.string: %@", target.string);
    NSLog(@"target.number: %@", @(target.number));
    NSLog(@"target.date: %@", target.date);
    NSLog(@"target.array: %@", target.array);
    NSLog(@"target.url: %@", target.url);

    NSLog(@"stackString: %@", stackString);

    NSLog(@"error: %@", mappingError);
//    NSLog(@"error: %@", continuationsError);
}



int main(int argc, const char * argv[]) {
    @autoreleasepool {
        demo();
    }

    return 0;
}
