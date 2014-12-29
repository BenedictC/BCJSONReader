//
//  main.m
//  TypeCheckedCollectionAccess
//
//  Created by Benedict Cohen on 20/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BCJSONMapper.h"
#import "BCJSONContinuations.h"



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
                                   @"array": @[@{@"name": @"John Lennon",
                                                 @"url": @"http://johnlennon.com"},
                                               @{@"name": @"Paul McCartney",
                                                 @"url": @"http://paulmccartney.com"},
                                               @{@"name": @"George Harrison",
                                                 @"url": @"http://georgeharrison.com"},
                                               @{@"name": @"Ringo Starr",
                                                 @"url": @"http://ringostarr.com"}],
                                   @"date" : @([[NSDate new] timeIntervalSince1970]), //Unix timestamp-style date
                                   };
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:sourceObject options:kNilOptions error:NULL];

    //Output objects
    TestObject *target = [TestObject new];
    __block NSString *stackString = nil;

    //Mapper-style
    NSString *string = nil;
    NSError *mappingError =
    [BCJMapper mapJSONData:jsonData intoObject:target options:BCJNoOptions usingContinuations:
     BCJSetString(BCJCreateSource(@"string"), BCJCreateTarget(&string)), //Fetches the value of the jsonPath, 'number' and sets the 'number' property of target. BCJ_SET is the simplestNote that the target is a NSInteger and the source is an NSNumber.
     BCJSetProperty(BCJCreateSource(@"date"), BCJCreateTarget(@"date")),  //The previous line uses the BCJ_SET macro which is just a wrapper arround BCJSetProperty. Note that the date is being implicitly converted from a number to a date. BCJSetProperty supports such conversions. number->date, string->date & string->url.
     BCJ_SET(@"array[0].url", url), //Fetches the value from a JSON path and implicitly converts it to the correct type.
     BCJSetString(BCJCreateSource(@"string", BCJSourceModeStrict), BCJCreateTarget(BCJ_KEY(string))), //Unlike BCJSetProperty, BCJSetString (and the other type-specific continuation constructors) does not perform 'magic'. It expects the source to be a string and the destination to be a string property. The source has its option set to BCJSourceModeStrict so that it will fail if the value is not found.

     //BCJSetMap. There's a lot going on here:
     //A map takes a collection (i.e. an array or a dictionary) and creates an array. In these case we're taking an array of dictionaries and creating an array of urls.
     //The last parameter of BCJSetMap is a block which creates the element to include in the resulting array. In this case we're using BCJGetURL to get the value of the 'url' key and return a URL.
     BCJSetMap(@"array", BCJ_KEY(array), NSDictionary.class, BCJNoOptions, ^id(NSUInteger elementIdx, NSDictionary *elementValue, NSError *__autoreleasing *outError) {
        NSURL *url;
        BCJSourceResult result = BCJGetURL(BCJCreateSource(elementValue, @"url"), &url, outError);
        return (result == BCJSourceResultSuccess) ? url : nil;
    }),
     BCJEnumerateDictionary(BCJCreateSource(@"dict"), NSString.class, NSNumber.class, ^BOOL(NSString *key, NSNumber *value, NSError *__autoreleasing *outError) {
        NSLog(@"%@ -> %@", key, value);
        return NO;
    }),
     nil];
    
//    //Continuations-style
//    BCJContainer *json = [BCJContainer new]; //Create a container to store the deserialized JSON in.
//    NSError *continuationsError =
//    [BCLContinuations untilError:
//         //Deserialization:
//         BCJDeserializeJSON(json, jsonData),
//
//         //StandardTypes:
//         BCJSetString(BCJCreateSource(json, @"string"), BCJ_TARGET(target, string)),
//         BCJSetNumber(BCJCreateSource(json, @"number"), BCJ_TARGET(target, number)),
//
//         //AdditionalTypes:
//         BCJSetURL(BCJCreateSource(json, @"array[3].url"), BCJ_TARGET(target, url)),
//         BCJSetDateFromTimeIntervalSince1970(BCJCreateSource(json, @"date", BCJSourceModeStrict), BCJ_TARGET(target, date)),
//
//         //Map:
//         BCJSetMap(BCJCreateSource(json, @"dict"), BCJ_TARGET(target, array), NSNumber.class, BCJMapOptionIgnoreFailedMappings, BCJ_SORT_DESCRIPTORS(@"self"), ^id(NSString *key, NSNumber *number, NSError **outError){
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
//         BCJGetValue(BCJCreateSource(json, @"missingString", NSString.class, BCJSourceModeDefaultable, @"default"), ^BOOL(NSString *string, NSError **outError){
//            //Validation
//            if (!BCJValidate(string, @"self MATCHES '.*'", outError)) return NO;
//            stackString = string;
//            return YES;
//        }),
//
//     nil];

    //Log results
    NSLog(@"string: <%@> %@", string.class, string);
    NSLog(@"target.string: <%@> %@", target.string.class, target.string);
    NSLog(@"target.number: <NSNumber> %@", @(target.number));
    NSLog(@"target.date: <%@> %@", target.date.class, target.date);
    NSLog(@"target.array: <%@> %@", target.array.class, target.array);
    NSLog(@"target.url: <%@> %@", target.url.class, target.url);

    NSLog(@"stackString: <%@> %@", stackString.class, stackString);

    NSLog(@"error: %@", mappingError);
//    NSLog(@"error: %@", continuationsError);
}



int main(int argc, const char * argv[]) {
    @autoreleasepool {
        demo();
    }

    return 0;
}
