//
//  BCJJSONSourceTests.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 07/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BCJJSONSource.h"



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



-(void)testGetValue
{
    //TODO: Test which class gets used for type checking
    //TODO: Test different options, both valid and invalid combinations
    //TODO: Test that outValue is correct on success and failure
    //TODO: Test error message is correct
}


@end
