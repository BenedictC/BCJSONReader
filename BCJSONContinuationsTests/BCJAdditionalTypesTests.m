//
//  BCJAdditionalTypesTests.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 07/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BCJSONContinuations.h"
#import "BCJConstants.h"



@interface BCJAdditionalTypesTests : XCTestCase

@end



@implementation BCJAdditionalTypesTests

-(void)testGetDateFromTimeIntervalSince1970WithValidValue
{
    //Given (setup environment)
    id dict = @{@"date": @(60 * 60 * 24 * 2)};
    BCJSource *source = BCJCreateSource(dict, @"date");

    //When (perform the action)
    NSDate *actualValue;
    NSError *error;
    BCJSourceResult actualResult = BCJGetDateFromTimeIntervalSince1970(source, &actualValue, &error);

    //Then (verify the action had the expected result)
    BCJSourceResult expectedResult = BCJSourceResultSuccess;
    XCTAssertEqual(actualResult, expectedResult, @"Incorrect result");
    id expectedValue = [NSDate dateWithTimeIntervalSince1970:60 * 60 * 24 * 2];
    XCTAssertEqualObjects(actualValue, expectedValue, @"Incorrect value");
}



-(void)testGetDateFromTimeIntervalSince1970WithInvalidValue
{
    //This test is actually wrong. It's actually testing that BCJSource fetches a number but it should be testing that the number is a
    //valid date. But seeing as *all* numbers are valid timestamps the test is probably pointless.

    //Given (setup environment)
    id dict = @{@"date": @"Not a timestamp"};
    BCJSource *source = BCJCreateSource(dict, @"date");

    //When (perform the action)
    NSDate *actualValue = [NSDate dateWithTimeIntervalSince1970:1234567890];
    NSError *error;
    BCJSourceResult actualResult = BCJGetDateFromTimeIntervalSince1970(source, &actualValue, &error);

    //Then (verify the action had the expected result)
    BCJSourceResult expectedResult = BCJSourceResultFailure;
    XCTAssertEqual(actualResult, expectedResult, @"Incorrect result");
    XCTAssertNil(actualValue, @"Incorrect value");
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, BCJInvalidValueError, @"Incorrect error");
}



-(void)testGetDateFromTimeIntervalSince1970WithMissingValue
{
    //Given (setup environment)
    id dict = @{@"date": @1234567890};
    BCJSource *source = BCJCreateSource(dict, @"notAdate");

    //When (perform the action)
    NSDate *actualValue = [NSDate dateWithTimeIntervalSince1970:1234567890];
    NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:nil];
    BCJSourceResult actualResult = BCJGetDateFromTimeIntervalSince1970(source, &actualValue, &error);

    //Then (verify the action had the expected result)
    BCJSourceResult expectedResult = BCJSourceResultValueNotFound;
    XCTAssertEqual(actualResult, expectedResult, @"Incorrect result");
    XCTAssertNil(actualValue, @"Incorrect value");
    XCTAssertNil(error);
}



-(void)testGetDateFromISO8601StringWithValidValue
{
    //Given (setup environment)
    id dict = @{@"date": @"1970-01-01T00:00:00.000Z"};
    BCJSource *source = BCJCreateSource(dict, @"date");

    //When (perform the action)
    NSDate *actualValue;
    NSError *error;
    BCJSourceResult actualResult = BCJGetDateFromISO8601String(source, &actualValue, &error);

    //Then (verify the action had the expected result)
    BCJSourceResult expectedResult = BCJSourceResultSuccess;
    XCTAssertEqual(actualResult, expectedResult, @"Incorrect result");
    id expectedValue = [NSDate dateWithTimeIntervalSince1970:0];
    XCTAssertEqualObjects(actualValue, expectedValue, @"Incorrect value");
}



-(void)testGetDateFromISO8601StringWithInvalidValue
{
    //Given (setup environment)
    id dict = @{@"date": @"Not a timestamp"};
    BCJSource *source = BCJCreateSource(dict, @"date");

    //When (perform the action)
    NSDate *actualValue = [NSDate dateWithTimeIntervalSince1970:1234567890];
    NSError *error;
    BCJSourceResult actualResult = BCJGetDateFromISO8601String(source, &actualValue, &error);

    //Then (verify the action had the expected result)
    BCJSourceResult expectedResult = BCJSourceResultFailure;
    XCTAssertEqual(actualResult, expectedResult, @"Incorrect result");
    XCTAssertNil(actualValue, @"Incorrect value");
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, BCJInvalidValueError, @"Incorrect error");
}



-(void)testGetDateFromISO8601StringWithMissingValue
{
    //Given (setup environment)
    id dict = @{};
    BCJSource *source = BCJCreateSource(dict, @"notAdate");

    //When (perform the action)
    NSDate *actualValue = [NSDate dateWithTimeIntervalSince1970:1234567890];
    NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:nil];
    BCJSourceResult actualResult = BCJGetDateFromISO8601String(source, &actualValue, &error);

    //Then (verify the action had the expected result)
    BCJSourceResult expectedResult = BCJSourceResultValueNotFound;
    XCTAssertEqual(actualResult, expectedResult, @"Incorrect result");
    XCTAssertNil(actualValue, @"Incorrect value");
    XCTAssertNil(error);
}



-(void)testGetURLWithValidValue
{
    //Given
    id dict = @{@"url": @"http://ledzeppelin.com"};
    BCJSource *source = BCJCreateSource(dict, @"url");

    //When
    NSURL *actualValue;
    NSError *error;
    BCJSourceResult actualResult = BCJGetURL(source, &actualValue, &error);

    //Then
    BCJSourceResult expectedResult = BCJSourceResultSuccess;
    XCTAssertEqual(actualResult, expectedResult, @"Incorrect result");
    id expectedValue = [NSURL URLWithString:@"http://ledzeppelin.com"];
    XCTAssertEqualObjects(actualValue, expectedValue, @"Incorrect value");
}



-(void)testGetURLWithInvalidValue
{
    //Given
    id dict = @{@"url": @"http://the led zeppelin.com"}; //This makes absolutely no sense.
    BCJSource *source = BCJCreateSource(dict, @"url");

    //When
    NSURL *actualValue = [NSURL URLWithString:@"http://thisshouldbenil.com"];
    NSError *error;
    BCJSourceResult actualResult = BCJGetURL(source, &actualValue, &error);

    //Then (verify the action had the expected result)
    BCJSourceResult expectedResult = BCJSourceResultFailure;
    XCTAssertEqual(actualResult, expectedResult, @"Incorrect result");
    XCTAssertNil(actualValue, @"Incorrect value");
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, BCJInvalidValueError, @"Incorrect error");
}



-(void)testGetURLWithMissingValue
{
    //Given (setup environment)
    id dict = @{};
    BCJSource *source = BCJCreateSource(dict, @"notAdate");

    //When (perform the action)
    NSURL *actualValue = [NSURL URLWithString:@"http://thisshouldbenil.com"];
    NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:nil];
    BCJSourceResult actualResult = BCJGetURL(source, &actualValue, &error);

    //Then (verify the action had the expected result)
    BCJSourceResult expectedResult = BCJSourceResultValueNotFound;
    XCTAssertEqual(actualResult, expectedResult, @"Incorrect result");
    XCTAssertNil(actualValue, @"Incorrect value");
    XCTAssertNil(error);
}



-(void)testGetEnumWithValidValue
{
    //Given
    id dict = @{@"enum": @"one"};
    BCJSource *source = BCJCreateSource(dict, @"enum");
    NSDictionary *enumMapping = @{@"one": @1, @"two": @2, @"three": @3};

    //When
    NSURL *actualValue;
    NSError *error;
    BCJSourceResult actualResult = BCJGetEnum(source, enumMapping, &actualValue, &error);

    //Then
    BCJSourceResult expectedResult = BCJSourceResultSuccess;
    XCTAssertEqual(actualResult, expectedResult, @"Incorrect result");
    id expectedValue = @1;
    XCTAssertEqualObjects(actualValue, expectedValue, @"Incorrect value");
}



-(void)testGetEnumWithInvalidValue
{
    //Given
    id dict = @{@"enum": @"Mmmmmm, cheese. Sorry, I got distracted. I meant 'three'."};
    BCJSource *source = BCJCreateSource(dict, @"enum");
    NSDictionary *enumMapping = @{@"one": @1, @"two": @2, @"three": @3};

    //When
    NSURL *actualValue;
    NSError *error;
    BCJSourceResult actualResult = BCJGetEnum(source, enumMapping, &actualValue, &error);

    //Then
    BCJSourceResult expectedResult = BCJSourceResultFailure;
    XCTAssertEqual(actualResult, expectedResult, @"Incorrect result");
    XCTAssertNil(actualValue, @"Incorrect value");
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, BCJUnknownEnumMappingKeyError, @"Incorrect error");
}



-(void)testGetEnumWithMissingValue
{
    //Given
    id dict = @{};
    BCJSource *source = BCJCreateSource(dict, @"enum");
    NSDictionary *enumMapping = @{@"one": @1, @"two": @2, @"three": @3};

    //When
    NSURL *actualValue;
    NSError *error;
    BCJSourceResult actualResult = BCJGetEnum(source, enumMapping, &actualValue, &error);

    //Then
    BCJSourceResult expectedResult = BCJSourceResultValueNotFound;
    XCTAssertEqual(actualResult, expectedResult, @"Incorrect result");
    XCTAssertNil(actualValue, @"Incorrect value");
    XCTAssertNil(error);
}

@end
