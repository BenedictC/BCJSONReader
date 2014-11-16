//
//  BCJDeserializationTests.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 01/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BCJJSONContinuations.h"



@interface BCJDeserializationTests : XCTestCase

@end



@implementation BCJDeserializationTests

-(void)testDeserializationJSONFunctionWithValidImmutableObjects
{
    //Given (setup environment)
    NSData *data = [@"{\"string\": \"a string\", \"number\": 1234567890}" dataUsingEncoding:NSUTF8StringEncoding];
    Class class = [NSDictionary class];
    BCJJSONReadingOptions options = 0;

    //When (perform the action)
    NSDictionary *actualValue;
    NSError *error;
    BOOL actualResult = BCJDeserializeJSON(data, class, options, &actualValue, &error);

    //Then (verify the action had the expected result)
    BOOL expectedResult = YES;
    XCTAssertEqual(actualResult, expectedResult, @"Incorrect result");
    id expectedValue = [NSDictionary dictionaryWithObjectsAndKeys:@"a string", @"string", @1234567890, @"number", nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"Incorrect value");
}



-(void)testDeserializationJSONFunctionWithValidMutableObjects
{
    //Given (setup environment)
    NSData *data = [@"{\"string\": \"a string\", \"number\": 1234567890}" dataUsingEncoding:NSUTF8StringEncoding];
    Class class = [NSDictionary class];
    BCJJSONReadingOptions options = BCJJSONReadingMutableLeaves | BCJJSONReadingMutableContainers;

    //When (perform the action)
    NSDictionary *actualValue;
    NSError *error;
    BOOL actualResult = BCJDeserializeJSON(data, class, options, &actualValue, &error);

    //Then (verify the action had the expected result)
    BOOL expectedResult = YES;
    XCTAssertEqual(actualResult, expectedResult, @"Incorrect result");
    id expectedValue = [NSMutableDictionary dictionaryWithObjectsAndKeys:[@"a string" mutableCopy], @"string", @1234567890, @"number", nil];
    XCTAssertEqualObjects(actualValue, expectedValue, @"Incorrect value");
}



-(void)testDeserializationJSONFunctionWithValidMutableFragment
{
    //Given (setup environment)
    NSData *data = [@"\"a lonely string\"" dataUsingEncoding:NSUTF8StringEncoding];
    Class class = [NSMutableString class];
    BCJJSONReadingOptions options = BCJJSONReadingMutableLeaves;

    //When (perform the action)
    NSDictionary *actualValue;
    NSError *error;
    BOOL actualResult = BCJDeserializeJSON(data, class, options, &actualValue, &error);

    //Then (verify the action had the expected result)
    BOOL expectedResult = YES;
    XCTAssertEqual(actualResult, expectedResult, @"Incorrect result");
    id expectedValue = [@"a lonely string" mutableCopy];
    XCTAssertEqualObjects(actualValue, expectedValue, @"Incorrect value");
}



-(void)testInvalidData
{
    //Given (setup environment)
    NSData *data = [@"NONSENSE NONSENSE!" dataUsingEncoding:NSUTF8StringEncoding];
    Class class = [NSString class];
    BCJJSONReadingOptions options = 0;

    //When (perform the action)
    NSString *actualValue;
    NSError *error;
    BOOL actualResult = BCJDeserializeJSON(data, class, options, &actualValue, &error);

    //Then (verify the action had the expected result)
    BOOL expectedResult = NO;
    XCTAssertEqual(actualResult, expectedResult, @"Incorrect result");
    XCTAssertNil(actualValue, @"Incorrect value");
    XCTAssertNotNil(error, @"Incorrect errror");
    XCTAssertEqual(error.code, BCJInvalidJSONDataError, @"Incorrect error");
}



-(void)testTypeCheckingWithInvalidType
{
    //Given (setup environment)
    NSData *data = [@"{\"string\": \"a string\", \"number\": 1234567890}" dataUsingEncoding:NSUTF8StringEncoding];
    Class class = [NSArray class];
    BCJJSONReadingOptions options = 0;

    //When (perform the action)
    NSDictionary *actualValue;
    NSError *error;
    BOOL actualResult = BCJDeserializeJSON(data, class, options, &actualValue, &error);

    //Then (verify the action had the expected result)
    BOOL expectedResult = NO;
    XCTAssertEqual(actualResult, expectedResult, @"Incorrect result");
    XCTAssertNil(actualValue, @"Incorrect value");
    XCTAssertNotNil(error, @"Incorrect errror");
    XCTAssertEqual(error.code, BCJUnexpectedTypeError, @"Incorrect error");
}

@end
