//
//  BCJDataFromBase64StringTests.m
//  BCJSONReader
//
//  Created by Benedict Cohen on 07/01/2015.
//  Copyright (c) 2015 Benedict Cohen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "BCJDataFromBase64String.h"



@interface BCJArfTest : XCTestCase

@end



@implementation BCJArfTest

-(void)testExample
{
    id expectObject = @[@"BOOM!"];
    NSData *input = [NSPropertyListSerialization dataWithPropertyList:expectObject format:NSPropertyListBinaryFormat_v1_0 options:0 error:NULL];
    NSString *base64 = [input base64EncodedStringWithOptions:0];
    NSData *data = BCJDataFromBase64String(base64);

    id actualObject = [NSPropertyListSerialization propertyListWithData:data options:0 format:NULL error:NULL];

    XCTAssertEqual(expectObject, actualObject);
}

@end
