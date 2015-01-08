//
//  BCJEnumerateJSONPathComponentsTests.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 05/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BCJSONPathParsing.h"
#import "BCJConstants.h"



@interface BCJEnumerateJSONPathComponentsTests : XCTestCase
@end



@implementation BCJEnumerateJSONPathComponentsTests

- (void)testValidIdentifier
{
    //Given (setup environment)
    NSString *path = @"identifier";

    //When (perform the action)
    __block id actualComponent = nil;
    NSError *error = BCJEnumerateJSONPathComponents(path, ^(id component, NSUInteger componentIdx, BOOL *stop) {
        actualComponent = component;
    });

    //Then (verify the action had the expected result)
    XCTAssertNil(error, @"Error should be nil");
    id expectedComponent = @"identifier";
    XCTAssertEqualObjects(actualComponent, expectedComponent, @"Incorrect component");
}



- (void)testInvalidIdentifierHead
{
    //Given (setup environment)
    NSString *path = @"!identifier";

    //When (perform the action)
    __block id actualComponent = nil;
    NSError *error = BCJEnumerateJSONPathComponents(path, ^(id component, NSUInteger componentIdx, BOOL *stop) {
        actualComponent = component;
    });

    //Then (verify the action had the expected result)
    XCTAssertEqual(error.code, BCJInvalidJSONPathError, @"Incorrect error code");
    XCTAssertEqualObjects(@0, error.userInfo[BCJInvalidJSONPathFailurePositionErrorKey], @"Incorrect failure position");
    id expectedComponent = nil;
    XCTAssertEqualObjects(actualComponent, expectedComponent, @"");
}



- (void)testInvalidIdentifierBody
{
    //Given (setup environment)
    NSString *path = @"id!entifier";

    //When (perform the action)
    __block id actualComponent = nil;
    NSError *error = BCJEnumerateJSONPathComponents(path, ^(id component, NSUInteger componentIdx, BOOL *stop) {
        actualComponent = component;
    });

    //Then (verify the action had the expected result)
    XCTAssertEqual(error.code, BCJInvalidJSONPathError, @"Incorrect error code");
    XCTAssertEqualObjects(@2, error.userInfo[BCJInvalidJSONPathFailurePositionErrorKey], @"Incorrect failure position");
    id expectedComponent = @"id";
    XCTAssertEqualObjects(actualComponent, expectedComponent, @"");
}



- (void)testValidSelfSubscript
{
    //Given (setup environment)
    NSString *path = @"[self]";

    //When (perform the action)
    __block id actualComponent = nil;
    NSError *error = BCJEnumerateJSONPathComponents(path, ^(id component, NSUInteger componentIdx, BOOL *stop) {
        actualComponent = component;
    });

    //Then (verify the action had the expected result)
    XCTAssertNil(error);
    id expectedComponent = [NSNull null];
    XCTAssertEqualObjects(actualComponent, expectedComponent, @"");
}



- (void)testValidIntegerSubscript
{
    //Given (setup environment)
    NSString *path = @"[12]";

    //When (perform the action)
    __block id actualComponent = nil;
    NSError *error = BCJEnumerateJSONPathComponents(path, ^(id component, NSUInteger componentIdx, BOOL *stop) {
        actualComponent = component;
    });

    //Then (verify the action had the expected result)
    XCTAssertNil(error);
    id expectedComponent = @12;
    XCTAssertEqualObjects(actualComponent, expectedComponent, @"");
}



- (void)testInvalidIntegerSubscript
{
    //Given (setup environment)
    NSString *path = @"[a12]";

    //When (perform the action)
    __block id actualComponent = nil;
    NSError *error = BCJEnumerateJSONPathComponents(path, ^(id component, NSUInteger componentIdx, BOOL *stop) {
        actualComponent = component;
    });

    XCTAssertEqual(error.code, BCJInvalidJSONPathError, @"Incorrect error code");
    XCTAssertEqualObjects(@1, error.userInfo[BCJInvalidJSONPathFailurePositionErrorKey], @"Incorrect failure position");
    id expectedComponent = nil;
    XCTAssertEqualObjects(actualComponent, expectedComponent, @"");
}



- (void)testValidStringSubscript
{
    //Given (setup environment)
    NSString *path = @"['a`'1``2']";

    //When (perform the action)
    __block id actualComponent = nil;
    NSError *error = BCJEnumerateJSONPathComponents(path, ^(id component, NSUInteger componentIdx, BOOL *stop) {
        actualComponent = component;
    });

    XCTAssertNil(error);
    id expectedComponent = @"a'1`2";
    XCTAssertEqualObjects(actualComponent, expectedComponent, @"");
}



- (void)testInvalidStringSubscript
{
    //Given (setup environment)
    NSString *path = @"['a'1`2']";

    //When (perform the action)
    __block id actualComponent = nil;
    NSError *error = BCJEnumerateJSONPathComponents(path, ^(id component, NSUInteger componentIdx, BOOL *stop) {
        actualComponent = component;
    });

    XCTAssertEqual(error.code, BCJInvalidJSONPathError, @"Incorrect error code");
    XCTAssertEqualObjects(@4, error.userInfo[BCJInvalidJSONPathFailurePositionErrorKey], @"Incorrect failure position");
    id expectedComponent = nil;
    XCTAssertEqualObjects(actualComponent, expectedComponent, @"");
}



#pragma message "TODO: Add tests for escape characters in string subscripts"
#pragma message "TODO: Add tests for component chains"

@end
