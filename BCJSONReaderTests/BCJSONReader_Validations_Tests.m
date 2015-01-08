//
//  BCJSONReader_Validations_Tests.m
//  BCJSONReader
//
//  Created by Benedict Cohen on 07/01/2015.
//  Copyright (c) 2015 Benedict Cohen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "BCJSONReader.h"



@interface BCJSONReader_Validations_Tests : XCTestCase

@end

@implementation BCJSONReader_Validations_Tests

- (void)testExample {

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

    NSError *error = [BCJSONReader readJSONObject:sourceObject defaultOptions:BCJNoOptions usingBlock:^(BCJSONReader *reader) {
//        [reader assertPredicateWithFormat:@"%K == 'WAY-OH!' && boring == 'string' ", @"BOOM[0]"];
//        [reader assertPredicateWithFormat:@"%K == 3", @"dict['t h r e e']"];
//        [reader assertPredicateWithFormat:@"(self['dict']['t h r e e'][10] == 2)"];
//        [reader assertPredicateWithFormat:@"%K == 2", @"dict['t h r e e'][1]"];
//        [reader assertPredicateWithFormat:@"%K == 1234", @"number"];
        [reader assertPredicateWithFormat:@"%K == 2", @"dict[self]['t h r e e'][1]"];
    }];
    XCTAssertNil(error);
}

@end
