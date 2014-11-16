//
//  BCJJSONSourceTests.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 07/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BCJJSONSource+DeferredClassCheck.h"



@interface BCJJSONSourceTests : XCTestCase

@end



@implementation BCJJSONSourceTests

-(void)testConstructors
{
    //Given
    NSMutableString *object = [NSMutableString stringWithString:@"arf"];
    NSString *JSONPath = @"self";
    Class defaultExpectedClass = NSString.class;
    BCJSourceOptions options = BCJSourceModeDefaultable;
    id defaultValue = @"default";

    //When
    BCJJSONSource *source = [[BCJJSONSource alloc] initWithObject:object JSONPath:JSONPath expectedClass:defaultExpectedClass options:options defaultValue:defaultValue];

    //Then
    XCTAssertEqualObjects(object, source.object, @"Constructor failed to set object.");
    XCTAssertEqualObjects(JSONPath, source.JSONPath, @"Constructor failed to set path.");
    XCTAssertEqualObjects(defaultExpectedClass, source.expectedClass, @"Constructor failed to set defaultExpectedClass.");
    XCTAssertEqual(options, source.options, @"Constructor failed to set options.");
    XCTAssertEqualObjects(defaultValue, source.defaultValue, @"Constructor failed to set defaultValue.");
}



- (void)testMandatoryGetValue
{
    //Given (setup environment)
    id expectedValue = @123456;
    NSDictionary *object = @{@"number": expectedValue};
    NSString *path = @"number";
    BCJJSONSource *source = [[BCJJSONSource alloc] initWithObject:object JSONPath:path expectedClass:nil options:0 defaultValue:nil];

    //When (perform the action)
    id actualValue;
    NSError *error;
    BOOL didSucceed = [source getValue:&actualValue error:&error];

    //Then (verify the action had the expected result)
    XCTAssert(didSucceed, @"");
    XCTAssertEqualObjects(expectedValue, actualValue, @"");
}



-(void)testGetValue
{
    XCTFail(@"TODO");
    //TODO: Test different options, both valid and invalid combinations
    //TODO: Test that outValue is correct on success and failure
    //TODO: Test error message is correct
}



-(void)testDeferredClassCheck
{
    XCTFail(@"TODO");    
    //TODO: Test which class gets used for type checking
}

@end
