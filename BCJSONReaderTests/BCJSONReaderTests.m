//
//  BCJSONReaderTests.m
//  BCJSONReader
//
//  Created by Benedict Cohen on 29/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "BCJSONReader.h"



@interface BCJSONReaderTests : XCTestCase

@end



@implementation BCJSONReaderTests

- (void)testExample
{
    NSDictionary *sourceObject = @{
                                   @"number": @1234,
                                   @"string": @"arf",
                                   @"dict" : @{
                                           @"one": @1,
                                           @"two": @2,
                                           @"t h r e e": @[@3, @2],
                                           @"four": @4,
                                           @"five": @5,
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

   [BCJSONReader readObject:sourceObject defaultOptions:BCJNoOptions usingBlock:^(BCJSONReader *reader) {
       id actual = [reader stringAt:@"array[3].name"];
       id expected = @"Ringo Starr";
       XCTAssertEqualObjects(actual, expected);
   }];

}

@end
