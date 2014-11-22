//
//  BCJPropertyTarget+ExpectedClass.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 22/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "BCJPropertyTarget+ExpectedClass.h"



@interface BCJPropertyTarget_ExpectedClass : XCTestCase

@end


@interface TestObject : NSObject
{
//    NSArray *_array;
//    NSInteger integer;
//    double number;
}

@property (nonatomic, readonly) NSArray *array;
@property (nonatomic, readonly) NSInteger integer;
@property (nonatomic, readonly) double number;
@end



@implementation TestObject

@end



@implementation BCJPropertyTarget_ExpectedClass

- (void)testObjectProperty
{
    //Given (setup environment)
    id object = [TestObject new];
    BCJPropertyTarget *target = BCJ_TARGET(object, array);

    //When (perform the action)
    NSString *actual = [target expectedObjCType];

    //Then (verify the action had the expected result)
    NSString *expected = @"";
    XCTAssertEqualObjects(actual, expected, @"Result not as expected.");
}

@end
