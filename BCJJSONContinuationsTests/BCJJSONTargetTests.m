//
//  BCJPropertyTargetTests.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 07/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BCJPropertyTarget.h"



@interface BCJPropertyTargetTests : XCTestCase

@end



@implementation BCJPropertyTargetTests

- (void)testConstructors
{
    //Given
    NSMutableString *object = [NSMutableString new];
    NSString *key = @"string";

    //When
    BCJPropertyTarget *target = [[BCJPropertyTarget alloc] initWithObject:object key:key];

    //Then
    XCTAssertEqualObjects(target.object, object, @"Constructor failed to set object");
    XCTAssertEqualObjects(target.key, key, @"Constructor failed to set key");
}


-(void)testSetValue
{
    XCTFail(@"TODO");    
}

@end
