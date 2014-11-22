//
//  BCJAdditionalTypesTests.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 07/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BCJJSONContinuations.h"



@interface BCJAdditionalTypesTests : XCTestCase

@end



@implementation BCJAdditionalTypesTests

-(void)testGetDateFromTimeIntervalSince1970WithValidValue
{
    //Given (setup environment)
    id dict = @{@"date": @(60 * 60 * 24 * 2)};
    BCJJSONSource *source = BCJSource(dict, @"date");

    //When (perform the action)
    NSDate *actualValue;
    NSError *error;
    BCJJSONSourceResult actualResult = BCJGetDateFromTimeIntervalSince1970(source, &actualValue, &error);

    //Then (verify the action had the expected result)
    BCJJSONSourceResult expectedResult = BCJJSONSourceResultSuccess;
    XCTAssertEqual(actualResult, expectedResult, @"Incorrect result");
    id expectedValue = [NSDate dateWithTimeIntervalSince1970:60 * 60 * 24 * 2];
    XCTAssertEqualObjects(actualValue, expectedValue, @"Incorrect value");
}



-(void)testGetDateFromTimeIntervalSince1970WithInvalidValue
{
    //This test is actually wrong. It's actually testing that BCJJSONSource fetches a number but it should be testing that the number is a
    //valid date. But seeing as *all* numbers are valid timestamps the test is probably pointless.

    //Given (setup environment)
    id dict = @{@"date": @"Not a timestamp"};
    BCJJSONSource *source = BCJSource(dict, @"date");

    //When (perform the action)
    NSDate *actualValue = [NSDate dateWithTimeIntervalSince1970:1234567890];
    NSError *error;
    BCJJSONSourceResult actualResult = BCJGetDateFromTimeIntervalSince1970(source, &actualValue, &error);

    //Then (verify the action had the expected result)
    BCJJSONSourceResult expectedResult = BCJJSONSourceResultFailure;
    XCTAssertEqual(actualResult, expectedResult, @"Incorrect result");
    XCTAssertNil(actualValue, @"Incorrect value");
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, BCJInvalidValueError, @"Incorrect error");
}



-(void)testGetDateFromTimeIntervalSince1970WithMissingValue
{
    //Given (setup environment)
    id dict = @{@"date": @1234567890};
    BCJJSONSource *source = BCJSource(dict, @"notAdate");

    //When (perform the action)
    NSDate *actualValue = [NSDate dateWithTimeIntervalSince1970:1234567890];
    NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:nil];
    BCJJSONSourceResult actualResult = BCJGetDateFromTimeIntervalSince1970(source, &actualValue, &error);

    //Then (verify the action had the expected result)
    BCJJSONSourceResult expectedResult = BCJJSONSourceResultValueNotFound;
    XCTAssertEqual(actualResult, expectedResult, @"Incorrect result");
    XCTAssertNil(actualValue, @"Incorrect value");
    XCTAssertNil(error);
}



-(void)testGetDateFromISO8601StringWithValidValue
{
    //Given (setup environment)
    id dict = @{@"date": @"1970-01-01T00:00:00.000Z"};
    BCJJSONSource *source = BCJSource(dict, @"date");

    //When (perform the action)
    NSDate *actualValue;
    NSError *error;
    BCJJSONSourceResult actualResult = BCJGetDateFromISO8601String(source, &actualValue, &error);

    //Then (verify the action had the expected result)
    BCJJSONSourceResult expectedResult = BCJJSONSourceResultSuccess;
    XCTAssertEqual(actualResult, expectedResult, @"Incorrect result");
    id expectedValue = [NSDate dateWithTimeIntervalSince1970:0];
    XCTAssertEqualObjects(actualValue, expectedValue, @"Incorrect value");
}



-(void)testGetDateFromISO8601StringWithInvalidValue
{
    //Given (setup environment)
    id dict = @{@"date": @"Not a timestamp"};
    BCJJSONSource *source = BCJSource(dict, @"date");

    //When (perform the action)
    NSDate *actualValue = [NSDate dateWithTimeIntervalSince1970:1234567890];
    NSError *error;
    BCJJSONSourceResult actualResult = BCJGetDateFromISO8601String(source, &actualValue, &error);

    //Then (verify the action had the expected result)
    BCJJSONSourceResult expectedResult = BCJJSONSourceResultFailure;
    XCTAssertEqual(actualResult, expectedResult, @"Incorrect result");
    XCTAssertNil(actualValue, @"Incorrect value");
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, BCJInvalidValueError, @"Incorrect error");
}



-(void)testGetDateFromISO8601StringWithMissingValue
{
    //Given (setup environment)
    id dict = @{};
    BCJJSONSource *source = BCJSource(dict, @"notAdate");

    //When (perform the action)
    NSDate *actualValue = [NSDate dateWithTimeIntervalSince1970:1234567890];
    NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:nil];
    BCJJSONSourceResult actualResult = BCJGetDateFromISO8601String(source, &actualValue, &error);

    //Then (verify the action had the expected result)
    BCJJSONSourceResult expectedResult = BCJJSONSourceResultValueNotFound;
    XCTAssertEqual(actualResult, expectedResult, @"Incorrect result");
    XCTAssertNil(actualValue, @"Incorrect value");
    XCTAssertNil(error);
}



-(void)testGetURLWithValidValue
{
    //Given
    id dict = @{@"url": @"http://ledzeppelin.com"};
    BCJJSONSource *source = BCJSource(dict, @"url");

    //When
    NSURL *actualValue;
    NSError *error;
    BCJJSONSourceResult actualResult = BCJGetURL(source, &actualValue, &error);

    //Then
    BCJJSONSourceResult expectedResult = BCJJSONSourceResultSuccess;
    XCTAssertEqual(actualResult, expectedResult, @"Incorrect result");
    id expectedValue = [NSURL URLWithString:@"http://ledzeppelin.com"];
    XCTAssertEqualObjects(actualValue, expectedValue, @"Incorrect value");
}



-(void)testGetURLWithInvalidValue
{
    //Given
    id dict = @{@"url": @"http://the led zeppelin.com"}; //This makes absolutely no sense.
    BCJJSONSource *source = BCJSource(dict, @"url");

    //When
    NSURL *actualValue = [NSURL URLWithString:@"http://thisshouldbenil.com"];
    NSError *error;
    BCJJSONSourceResult actualResult = BCJGetURL(source, &actualValue, &error);

    //Then (verify the action had the expected result)
    BCJJSONSourceResult expectedResult = BCJJSONSourceResultFailure;
    XCTAssertEqual(actualResult, expectedResult, @"Incorrect result");
    XCTAssertNil(actualValue, @"Incorrect value");
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, BCJInvalidValueError, @"Incorrect error");
}



-(void)testGetURLWithMissingValue
{
    //Given (setup environment)
    id dict = @{};
    BCJJSONSource *source = BCJSource(dict, @"notAdate");

    //When (perform the action)
    NSURL *actualValue = [NSURL URLWithString:@"http://thisshouldbenil.com"];
    NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:nil];
    BCJJSONSourceResult actualResult = BCJGetURL(source, &actualValue, &error);

    //Then (verify the action had the expected result)
    BCJJSONSourceResult expectedResult = BCJJSONSourceResultValueNotFound;
    XCTAssertEqual(actualResult, expectedResult, @"Incorrect result");
    XCTAssertNil(actualValue, @"Incorrect value");
    XCTAssertNil(error);
}



-(void)testGetEnumWithValidValue
{
    //Given
    id dict = @{@"enum": @"one"};
    BCJJSONSource *source = BCJSource(dict, @"enum");
    NSDictionary *enumMapping = @{@"one": @1, @"two": @2, @"three": @3};

    //When
    NSURL *actualValue;
    NSError *error;
    BCJJSONSourceResult actualResult = BCJGetEnum(source, enumMapping, &actualValue, &error);

    //Then
    BCJJSONSourceResult expectedResult = BCJJSONSourceResultSuccess;
    XCTAssertEqual(actualResult, expectedResult, @"Incorrect result");
    id expectedValue = @1;
    XCTAssertEqualObjects(actualValue, expectedValue, @"Incorrect value");
}



-(void)testGetEnumWithInvalidValue
{
    //Given
    id dict = @{@"enum": @"Mmmmmm, cheese. Sorry, I got distracted. I meant 'three'."};
    BCJJSONSource *source = BCJSource(dict, @"enum");
    NSDictionary *enumMapping = @{@"one": @1, @"two": @2, @"three": @3};

    //When
    NSURL *actualValue;
    NSError *error;
    BCJJSONSourceResult actualResult = BCJGetEnum(source, enumMapping, &actualValue, &error);

    //Then
    BCJJSONSourceResult expectedResult = BCJJSONSourceResultFailure;
    XCTAssertEqual(actualResult, expectedResult, @"Incorrect result");
    XCTAssertNil(actualValue, @"Incorrect value");
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, BCJUnknownEnumMappingKeyError, @"Incorrect error");
}



-(void)testGetEnumWithMissingValue
{
    //Given
    id dict = @{};
    BCJJSONSource *source = BCJSource(dict, @"enum");
    NSDictionary *enumMapping = @{@"one": @1, @"two": @2, @"three": @3};

    //When
    NSURL *actualValue;
    NSError *error;
    BCJJSONSourceResult actualResult = BCJGetEnum(source, enumMapping, &actualValue, &error);

    //Then
    BCJJSONSourceResult expectedResult = BCJJSONSourceResultValueNotFound;
    XCTAssertEqual(actualResult, expectedResult, @"Incorrect result");
    XCTAssertNil(actualValue, @"Incorrect value");
    XCTAssertNil(error);
}

@end
