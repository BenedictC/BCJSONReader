//
//  BCJPropertyTarget+ValueIntrospectionTests.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 22/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "BCJPropertyTarget+ValueIntrospection.h"



@interface BCJPropertyTarget_ValueIntrospectionTests : XCTestCase

@end


@interface TestObject : NSObject
{
    NSArray *_arrayIVar;
    NSInteger _integerIVar;
    float _numberIVar;
}

@property (nonatomic, readonly) NSArray *array;
@property (nonatomic, readonly) NSInteger integer;
@property (nonatomic, readonly) float number;
@end



@implementation TestObject

@end



@implementation BCJPropertyTarget_ValueIntrospectionTests

- (void)testValidObjectProperty
{
    //Given (setup environment)
    id object = [TestObject new];
    BCJPropertyTarget *target = BCJTarget(object, BCJ_KEY(array));
    id value = @[];

    //When (perform the action)
    BOOL actual = [target canReceiveValue:value];

    //Then (verify the action had the expected result)
    BOOL expected = YES;
    XCTAssertEqual(actual, expected, @"Result not as expected.");
}



- (void)testInvalidObjectProperty
{
    //Given (setup environment)
    id object = [TestObject new];
    BCJPropertyTarget *target = BCJTarget(object, BCJ_KEY(array));
    id value = @"";

    //When (perform the action)
    BOOL actual = [target canReceiveValue:value];

    //Then (verify the action had the expected result)
    BOOL expected = NO;
    XCTAssertEqual(actual, expected, @"Result not as expected.");
}



- (void)testValidScalarProperty
{
    //Given (setup environment)
    id object = [TestObject new];
    BCJPropertyTarget *target = BCJTarget(object, BCJ_KEY(integer));
    id value = @123456789;

    //When (perform the action)
    BOOL actual = [target canReceiveValue:value];

    //Then (verify the action had the expected result)
    BOOL expected = YES;
    XCTAssertEqual(actual, expected, @"Result not as expected.");
}



- (void)testInvalidScalarPropertyFloatIntoInt
{
    //Given (setup environment)
    id object = [TestObject new];
    BCJPropertyTarget *target = BCJTarget(object, BCJ_KEY(integer));
    id value = @(123456789.234567);

    //When (perform the action)
    BOOL actual = [target canReceiveValue:value];

    //Then (verify the action had the expected result)
    BOOL expected = NO;
    XCTAssertEqual(actual, expected, @"Result not as expected.");
}



- (void)testInvalidScalarPropertyDoubleIntoFloat
{
    //Given (setup environment)
    id object = [TestObject new];
    BCJPropertyTarget *target = BCJTarget(object, BCJ_KEY(number));
    float dbl = 12345.98765432;
    id value = @(dbl);

    //When (perform the action)
    BOOL actual = [target canReceiveValue:value];

    //Then (verify the action had the expected result)
    BOOL expected = NO;
    XCTAssertEqual(actual, expected, @"Result not as expected.");
}

@end
