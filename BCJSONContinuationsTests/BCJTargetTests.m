//
//  BCJTargetTests.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 07/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BCJTarget.h"



@interface BCJTargetTests : XCTestCase

@end



@implementation BCJTargetTests

- (void)testConstructors
{
    //Given
    NSMutableString *object = [NSMutableString new];
    NSString *keyPath = @"string";

    //When
    BCJTarget *target = [[BCJTarget alloc] initWithObject:object keyPath:keyPath];

    //Then
    XCTAssertEqualObjects(target.object, object, @"Constructor failed to set object");
    XCTAssertEqualObjects(target.keyPath, keyPath, @"Constructor failed to set key");
}


-(void)testSetValue
{
    XCTFail(@"TODO");    
}

@end
