//
//  BCJEnumerateJSONPathComponentsTests.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 05/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BCJEnumerateJSONPathComponents.h"



@interface BCJEnumerateJSONPathComponentsTests : XCTestCase
@end



@implementation BCJEnumerateJSONPathComponentsTests

//- (void)testEnumerateJSONPathComponents
//{
////    NSString *pathString = @"this[1234].is['!@£CHA``OS`'MONKEY'].a.valid.path[123][456]['arf']";
////    NSEnumerator *pathEnumerator = [@[@"this", @1234, @"!@£CHA`OS'MONKEY", @"valid", @"path", @123, @456, @"arf"] objectEnumerator];
//
//    NSString *pathString = @"[123].arf.foo.bar['``!@£CHA``OS`'MONKEY'][''][789]";
//    NSEnumerator *pathEnumerator = [@[@123, @"arf", @"foo", @"bar", @"`!@£CHA`OS'MONKEY", @"", @789] objectEnumerator];
//
//    NSError *pathParseError = BCJEnumerateJSONPathComponents(pathString, ^(id component, NSUInteger componentIdx, BOOL *stop){
//        NSLog(@"%@", component);
//        XCTAssertEqualObjects(component, pathEnumerator.nextObject, @"objects are not equal");
//    });
//
//    XCTAssertNil([pathEnumerator nextObject], @"Failed to parse all path components.");
//    XCTAssertNil(pathParseError, @"Error while parsing JSONpath.");
//}

@end
