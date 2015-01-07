//
//  main.m
//  BCJSONReader
//
//  Created by Benedict Cohen on 20/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BCJSONReader.h"



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
    NSError *mappingError = [BCJSONReader readJSONData:jsonData defaultOptions:BCJSONReaderModeOptional usingBlock:^void(BCJSONReader *reader){

        target.number = [reader integerAt:@"number"];
        target.string = [reader stringAt:@"data[0]" options:BCJSONReaderModeRequired defaultValue:@"BOOM! default" didSucceed:NULL];
        target.date = [reader dateFromTimeIntervalSince1970At:@"date"];
        target.url = [reader URLFromStringAt:@"array[0].url"];
        target.array = [reader arrayFromDictionaryAt:@"dict" options:BCJSONReaderModeRequired didSucceed:NULL usingElementReaderBlock:^id(BCJSONReader *elementReader, id elementKey){
            return [elementReader stringAt:@"name"];
        }];
    }];

    //Log results
    NSLog(@"target.number: <NSInteger> %@", @(target.number));
    NSLog(@"target.string: <%@> %@", target.string.class, target.string);
    NSLog(@"target.date: <%@> %@", target.date.class, target.date);
    NSLog(@"target.url: <%@> %@", target.url.class, target.url);
    NSLog(@"target.array: <%@> %@", target.array.class, target.array);


    NSLog(@"error: %@", mappingError);
//    NSLog(@"error: %@", continuationsError);
}



int main(int argc, const char * argv[]) {
    @autoreleasepool {
        demo();
    }

    return 0;
}
