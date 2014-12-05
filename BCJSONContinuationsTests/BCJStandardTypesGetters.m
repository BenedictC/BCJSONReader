//
//  BCJStandardTypesGettersTests.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 07/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BCJSource.h"
#import "BCJStandardTypesGetters.h"
#import "BCJError.h"



@interface BCJStandardTypesTests : XCTestCase

@end



@implementation BCJStandardTypesTests

#pragma mark - GetArray
-(void)testGetArrayWithSuccessSource
{
    //Given
    id value = @[];
    BCJSource *source = BCJCreateSource(@{@"value": value }, @"value");
    __block NSInteger actualGetterInvocationCount = 0;
    __block id actualValue = nil;
    id<BCLContinuation> continuation = BCJGetArray(source, ^BOOL(NSArray *array, NSError **outError){
        actualGetterInvocationCount++;
        actualValue = array;
        return YES;
    });

    //When
    __block NSNumber *actualResult = nil;
    __block NSError *actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    NSInteger expectGetterInvocationCount = 1;
    XCTAssertEqual(expectGetterInvocationCount, actualGetterInvocationCount, @"Failed to correctly handler getter");
    id expectValue = value;
    XCTAssertEqualObjects(expectValue, actualValue, @"Failed to get correct value");
    id expectedResult = @YES;
    XCTAssertEqualObjects(expectedResult, actualResult, @"Failed to return expected result");
    id expectedError = nil;
    XCTAssertEqualObjects(expectedError, actualError, @"Failed to return expected error");
}



-(void)testGetArrayWithFailingCompletionBlocking
{
    //Given
    id value = @[];
    BCJSource *source = BCJCreateSource(@{@"value": value }, @"value");
    __block NSInteger actualGetterInvocationCount = 0;
    __block id actualValue = nil;
    NSError *error = [NSError errorWithDomain:@"Placeholder error" code:0 userInfo:nil];
    id<BCLContinuation> continuation = BCJGetArray(source, ^BOOL(NSArray *array, NSError **outError){
        actualGetterInvocationCount++;
        actualValue = array;
        *outError = error;
        return NO;
    });

    //When
    __block NSNumber *actualResult = nil;
    __block NSError *actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    NSInteger expectGetterInvocationCount = 1;
    XCTAssertEqual(expectGetterInvocationCount, actualGetterInvocationCount, @"Failed to correctly handler getter");
    id expectValue = value;
    XCTAssertEqualObjects(expectValue, actualValue, @"Failed to get correct value");
    id expectedResult = @NO;
    XCTAssertEqualObjects(expectedResult, actualResult, @"Failed to return expected result");
    id expectedError = error;
    XCTAssertEqualObjects(expectedError, actualError, @"Failed to return expected error");
}



-(void)testGetArrayWithValueNotFoundSource
{
    //Given
    id value = @[];
    BCJSource *source = BCJCreateSource(@{@"notValue": value }, @"value");
    __block NSInteger actualGetterInvocationCount = 0;
    __block id actualValue = nil;
    id<BCLContinuation> continuation = BCJGetArray(source, ^BOOL(NSArray *array, NSError **outError){
        actualGetterInvocationCount++;
        actualValue = array;
        return YES;
    });

    //When
    __block NSNumber *actualResult = nil;
    __block NSError *actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    NSInteger expectGetterInvocationCount = 0;
    XCTAssertEqual(expectGetterInvocationCount, actualGetterInvocationCount, @"Failed to correctly handler getter");
    id expectValue = nil;
    XCTAssertEqualObjects(expectValue, actualValue, @"Failed to get correct value");
    id expectedResult = @YES;
    XCTAssertEqualObjects(expectedResult, actualResult, @"Failed to return expected result");
    id expectedError = nil;
    XCTAssertEqualObjects(expectedError, actualError, @"Failed to return expected error");
}



-(void)testGetArrayWithFailedSource
{
    //Given
    id value = @[];
    BCJSource *source = BCJCreateSource(@{@"notValue":value}, @"value", BCJSourceModeStrict, nil);
    __block NSInteger actualGetterInvocationCount = 0;
    __block id actualValue = nil;
    id<BCLContinuation> continuation = BCJGetArray(source, ^BOOL(NSArray *array, NSError **outError){
        actualGetterInvocationCount++;
        actualValue = array;
        return YES;
    });

    //When
    __block NSNumber *actualResult = nil;
    __block NSError *actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    NSInteger expectGetterInvocationCount = 0;
    XCTAssertEqual(expectGetterInvocationCount, actualGetterInvocationCount, @"Failed to correctly handler getter");
    id expectValue = nil;
    XCTAssertEqualObjects(expectValue, actualValue, @"Failed to get correct value");
    id expectedResult = @NO;
    XCTAssertEqualObjects(expectedResult, actualResult, @"Failed to return expected result");
    id expectedError = [BCJError missingSourceValueErrorWithSource:source JSONPathComponent:@"value" componentIndex:0];
    XCTAssertEqualObjects(expectedError, actualError, @"Failed to return expected error");
}



#pragma mark - GetMutableArray
-(void)testGetMutableArrayWithSuccessSource
{
    //Given
    id value = [NSMutableArray new];
    BCJSource *source = BCJCreateSource(@{@"value": value }, @"value");
    __block NSInteger actualGetterInvocationCount = 0;
    __block id actualValue = nil;
    id<BCLContinuation> continuation = BCJGetMutableArray(source, ^BOOL(NSMutableArray *array, NSError **outError){
        actualGetterInvocationCount++;
        actualValue = array;
        return YES;
    });

    //When
    __block NSNumber *actualResult = nil;
    __block NSError *actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    NSInteger expectGetterInvocationCount = 1;
    XCTAssertEqual(expectGetterInvocationCount, actualGetterInvocationCount, @"Failed to correctly handler getter");
    id expectValue = value;
    XCTAssertEqualObjects(expectValue, actualValue, @"Failed to get correct value");
    id expectedResult = @YES;
    XCTAssertEqualObjects(expectedResult, actualResult, @"Failed to return expected result");
    id expectedError = nil;
    XCTAssertEqualObjects(expectedError, actualError, @"Failed to return expected error");
}



-(void)testGetMutableArrayWithFailingCompletionBlocking
{
    //Given
    id value = [NSMutableArray new];
    BCJSource *source = BCJCreateSource(@{@"value": value }, @"value");
    __block NSInteger actualGetterInvocationCount = 0;
    __block id actualValue = nil;
    NSError *error = [NSError errorWithDomain:@"Placeholder error" code:0 userInfo:nil];
    id<BCLContinuation> continuation = BCJGetMutableArray(source, ^BOOL(NSMutableArray *array, NSError **outError){
        actualGetterInvocationCount++;
        actualValue = array;
        *outError = error;
        return NO;
    });

    //When
    __block NSNumber *actualResult = nil;
    __block NSError *actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    NSInteger expectGetterInvocationCount = 1;
    XCTAssertEqual(expectGetterInvocationCount, actualGetterInvocationCount, @"Failed to correctly handler getter");
    id expectValue = value;
    XCTAssertEqualObjects(expectValue, actualValue, @"Failed to get correct value");
    id expectedResult = @NO;
    XCTAssertEqualObjects(expectedResult, actualResult, @"Failed to return expected result");
    id expectedError = error;
    XCTAssertEqualObjects(expectedError, actualError, @"Failed to return expected error");
}



-(void)testGetMutableArrayWithValueNotFoundSource
{
    //Given
    id value = [NSMutableArray new];
    BCJSource *source = BCJCreateSource(@{@"notValue": value }, @"value");
    __block NSInteger actualGetterInvocationCount = 0;
    __block id actualValue = nil;
    id<BCLContinuation> continuation = BCJGetMutableArray(source, ^BOOL(NSMutableArray *array, NSError **outError){
        actualGetterInvocationCount++;
        actualValue = array;
        return YES;
    });

    //When
    __block NSNumber *actualResult = nil;
    __block NSError *actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    NSInteger expectGetterInvocationCount = 0;
    XCTAssertEqual(expectGetterInvocationCount, actualGetterInvocationCount, @"Failed to correctly handler getter");
    id expectValue = nil;
    XCTAssertEqualObjects(expectValue, actualValue, @"Failed to get correct value");
    id expectedResult = @YES;
    XCTAssertEqualObjects(expectedResult, actualResult, @"Failed to return expected result");
    id expectedError = nil;
    XCTAssertEqualObjects(expectedError, actualError, @"Failed to return expected error");
}



-(void)testGetMutableArrayWithFailedSource
{
    //Given
    id value = [NSMutableArray new];
    BCJSource *source = BCJCreateSource(@{@"notValue":value}, @"value", BCJSourceModeStrict, nil);
    __block NSInteger actualGetterInvocationCount = 0;
    __block id actualValue = nil;
    id<BCLContinuation> continuation = BCJGetMutableArray(source, ^BOOL(NSMutableArray *array, NSError **outError){
        actualGetterInvocationCount++;
        actualValue = array;
        return YES;
    });

    //When
    __block NSNumber *actualResult = nil;
    __block NSError *actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    NSInteger expectGetterInvocationCount = 0;
    XCTAssertEqual(expectGetterInvocationCount, actualGetterInvocationCount, @"Failed to correctly handler getter");
    id expectValue = nil;
    XCTAssertEqualObjects(expectValue, actualValue, @"Failed to get correct value");
    id expectedResult = @NO;
    XCTAssertEqualObjects(expectedResult, actualResult, @"Failed to return expected result");
    id expectedError = [BCJError missingSourceValueErrorWithSource:source JSONPathComponent:@"value" componentIndex:0];
    XCTAssertEqualObjects(expectedError, actualError, @"Failed to return expected error");
}



#pragma mark - GetDictionary
-(void)testGetDictionaryWithSuccessSource
{
    //Given
    id value = @{};
    BCJSource *source = BCJCreateSource(@{@"value": value }, @"value");
    __block NSInteger actualGetterInvocationCount = 0;
    __block id actualValue = nil;
    id<BCLContinuation> continuation = BCJGetDictionary(source, ^BOOL(NSDictionary *dict, NSError **outError){
        actualGetterInvocationCount++;
        actualValue = dict;
        return YES;
    });

    //When
    __block NSNumber *actualResult = nil;
    __block NSError *actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    NSInteger expectGetterInvocationCount = 1;
    XCTAssertEqual(expectGetterInvocationCount, actualGetterInvocationCount, @"Failed to correctly handler getter");
    id expectValue = value;
    XCTAssertEqualObjects(expectValue, actualValue, @"Failed to get correct value");
    id expectedResult = @YES;
    XCTAssertEqualObjects(expectedResult, actualResult, @"Failed to return expected result");
    id expectedError = nil;
    XCTAssertEqualObjects(expectedError, actualError, @"Failed to return expected error");
}



-(void)testGetDictionaryWithFailingCompletionBlocking
{
    //Given
    id value = @{};
    BCJSource *source = BCJCreateSource(@{@"value": value }, @"value");
    __block NSInteger actualGetterInvocationCount = 0;
    __block id actualValue = nil;
    NSError *error = [NSError errorWithDomain:@"Placeholder error" code:0 userInfo:nil];
    id<BCLContinuation> continuation = BCJGetDictionary(source, ^BOOL(NSDictionary *dict, NSError **outError){
        actualGetterInvocationCount++;
        actualValue = dict;
        *outError = error;
        return NO;
    });

    //When
    __block NSNumber *actualResult = nil;
    __block NSError *actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    NSInteger expectGetterInvocationCount = 1;
    XCTAssertEqual(expectGetterInvocationCount, actualGetterInvocationCount, @"Failed to correctly handler getter");
    id expectValue = value;
    XCTAssertEqualObjects(expectValue, actualValue, @"Failed to get correct value");
    id expectedResult = @NO;
    XCTAssertEqualObjects(expectedResult, actualResult, @"Failed to return expected result");
    id expectedError = error;
    XCTAssertEqualObjects(expectedError, actualError, @"Failed to return expected error");
}



-(void)testGetDictionaryWithValueNotFoundSource
{
    //Given
    id value = @{};
    BCJSource *source = BCJCreateSource(@{@"notValue": value }, @"value");
    __block NSInteger actualGetterInvocationCount = 0;
    __block id actualValue = nil;
    id<BCLContinuation> continuation = BCJGetDictionary(source, ^BOOL(NSDictionary *dict, NSError **outError){
        actualGetterInvocationCount++;
        actualValue = dict;
        return YES;
    });

    //When
    __block NSNumber *actualResult = nil;
    __block NSError *actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    NSInteger expectGetterInvocationCount = 0;
    XCTAssertEqual(expectGetterInvocationCount, actualGetterInvocationCount, @"Failed to correctly handler getter");
    id expectValue = nil;
    XCTAssertEqualObjects(expectValue, actualValue, @"Failed to get correct value");
    id expectedResult = @YES;
    XCTAssertEqualObjects(expectedResult, actualResult, @"Failed to return expected result");
    id expectedError = nil;
    XCTAssertEqualObjects(expectedError, actualError, @"Failed to return expected error");
}



-(void)testGetDictionaryWithFailedSource
{
    //Given
    id value = @{};
    BCJSource *source = BCJCreateSource(@{@"notValue":value}, @"value", BCJSourceModeStrict, nil);
    __block NSInteger actualGetterInvocationCount = 0;
    __block id actualValue = nil;
    id<BCLContinuation> continuation = BCJGetDictionary(source, ^BOOL(NSDictionary *dict, NSError **outError){
        actualGetterInvocationCount++;
        actualValue = dict;
        return YES;
    });

    //When
    __block NSNumber *actualResult = nil;
    __block NSError *actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    NSInteger expectGetterInvocationCount = 0;
    XCTAssertEqual(expectGetterInvocationCount, actualGetterInvocationCount, @"Failed to correctly handler getter");
    id expectValue = nil;
    XCTAssertEqualObjects(expectValue, actualValue, @"Failed to get correct value");
    id expectedResult = @NO;
    XCTAssertEqualObjects(expectedResult, actualResult, @"Failed to return expected result");
    id expectedError = [BCJError missingSourceValueErrorWithSource:source JSONPathComponent:@"value" componentIndex:0];
    XCTAssertEqualObjects(expectedError, actualError, @"Failed to return expected error");
}



#pragma mark - GetMutableDictionary
-(void)testGetMutableDictionaryWithSuccessSource
{
    //Given
    id value = [NSMutableDictionary new];
    BCJSource *source = BCJCreateSource(@{@"value": value }, @"value");
    __block NSInteger actualGetterInvocationCount = 0;
    __block id actualValue = nil;
    id<BCLContinuation> continuation = BCJGetMutableDictionary(source, ^BOOL(NSMutableDictionary *dict, NSError **outError){
        actualGetterInvocationCount++;
        actualValue = dict;
        return YES;
    });

    //When
    __block NSNumber *actualResult = nil;
    __block NSError *actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    NSInteger expectGetterInvocationCount = 1;
    XCTAssertEqual(expectGetterInvocationCount, actualGetterInvocationCount, @"Failed to correctly handler getter");
    id expectValue = value;
    XCTAssertEqualObjects(expectValue, actualValue, @"Failed to get correct value");
    id expectedResult = @YES;
    XCTAssertEqualObjects(expectedResult, actualResult, @"Failed to return expected result");
    id expectedError = nil;
    XCTAssertEqualObjects(expectedError, actualError, @"Failed to return expected error");
}



-(void)testGetMutableDictionaryWithFailingCompletionBlocking
{
    //Given
    id value = [NSMutableDictionary new];
    BCJSource *source = BCJCreateSource(@{@"value": value }, @"value");
    __block NSInteger actualGetterInvocationCount = 0;
    __block id actualValue = nil;
    NSError *error = [NSError errorWithDomain:@"Placeholder error" code:0 userInfo:nil];
    id<BCLContinuation> continuation = BCJGetMutableDictionary(source, ^BOOL(NSMutableDictionary *dict, NSError **outError){
        actualGetterInvocationCount++;
        actualValue = dict;
        *outError = error;
        return NO;
    });

    //When
    __block NSNumber *actualResult = nil;
    __block NSError *actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    NSInteger expectGetterInvocationCount = 1;
    XCTAssertEqual(expectGetterInvocationCount, actualGetterInvocationCount, @"Failed to correctly handler getter");
    id expectValue = value;
    XCTAssertEqualObjects(expectValue, actualValue, @"Failed to get correct value");
    id expectedResult = @NO;
    XCTAssertEqualObjects(expectedResult, actualResult, @"Failed to return expected result");
    id expectedError = error;
    XCTAssertEqualObjects(expectedError, actualError, @"Failed to return expected error");
}



-(void)testGetMutableDictionaryWithValueNotFoundSource
{
    //Given
    id value = [NSMutableDictionary new];
    BCJSource *source = BCJCreateSource(@{@"notValue": value }, @"value");
    __block NSInteger actualGetterInvocationCount = 0;
    __block id actualValue = nil;
    id<BCLContinuation> continuation = BCJGetMutableDictionary(source, ^BOOL(NSMutableDictionary *dict, NSError **outError){
        actualGetterInvocationCount++;
        actualValue = dict;
        return YES;
    });

    //When
    __block NSNumber *actualResult = nil;
    __block NSError *actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    NSInteger expectGetterInvocationCount = 0;
    XCTAssertEqual(expectGetterInvocationCount, actualGetterInvocationCount, @"Failed to correctly handler getter");
    id expectValue = nil;
    XCTAssertEqualObjects(expectValue, actualValue, @"Failed to get correct value");
    id expectedResult = @YES;
    XCTAssertEqualObjects(expectedResult, actualResult, @"Failed to return expected result");
    id expectedError = nil;
    XCTAssertEqualObjects(expectedError, actualError, @"Failed to return expected error");
}



-(void)testGetMutableDictionaryWithFailedSource
{
    //Given
    id value = [NSMutableDictionary new];
    BCJSource *source = BCJCreateSource(@{@"notValue":value}, @"value", BCJSourceModeStrict, nil);
    __block NSInteger actualGetterInvocationCount = 0;
    __block id actualValue = nil;
    id<BCLContinuation> continuation = BCJGetMutableDictionary(source, ^BOOL(NSMutableDictionary *dict, NSError **outError){
        actualGetterInvocationCount++;
        actualValue = dict;
        return YES;
    });

    //When
    __block NSNumber *actualResult = nil;
    __block NSError *actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    NSInteger expectGetterInvocationCount = 0;
    XCTAssertEqual(expectGetterInvocationCount, actualGetterInvocationCount, @"Failed to correctly handler getter");
    id expectValue = nil;
    XCTAssertEqualObjects(expectValue, actualValue, @"Failed to get correct value");
    id expectedResult = @NO;
    XCTAssertEqualObjects(expectedResult, actualResult, @"Failed to return expected result");
    id expectedError = [BCJError missingSourceValueErrorWithSource:source JSONPathComponent:@"value" componentIndex:0];
    XCTAssertEqualObjects(expectedError, actualError, @"Failed to return expected error");
}



#pragma mark - GetString
-(void)testGetStringWithSuccessSource
{
    //Given
    id value = @"";
    BCJSource *source = BCJCreateSource(@{@"value": value }, @"value");
    __block NSInteger actualGetterInvocationCount = 0;
    __block id actualValue = nil;
    id<BCLContinuation> continuation = BCJGetString(source, ^BOOL(NSString *string, NSError **outError){
        actualGetterInvocationCount++;
        actualValue = string;
        return YES;
    });

    //When
    __block NSNumber *actualResult = nil;
    __block NSError *actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    NSInteger expectGetterInvocationCount = 1;
    XCTAssertEqual(expectGetterInvocationCount, actualGetterInvocationCount, @"Failed to correctly handler getter");
    id expectValue = value;
    XCTAssertEqualObjects(expectValue, actualValue, @"Failed to get correct value");
    id expectedResult = @YES;
    XCTAssertEqualObjects(expectedResult, actualResult, @"Failed to return expected result");
    id expectedError = nil;
    XCTAssertEqualObjects(expectedError, actualError, @"Failed to return expected error");
}



-(void)testGetStringWithFailingCompletionBlocking
{
    //Given
    id value = @"";
    BCJSource *source = BCJCreateSource(@{@"value": value }, @"value");
    __block NSInteger actualGetterInvocationCount = 0;
    __block id actualValue = nil;
    NSError *error = [NSError errorWithDomain:@"Placeholder error" code:0 userInfo:nil];
    id<BCLContinuation> continuation = BCJGetString(source, ^BOOL(NSString *string, NSError **outError){
        actualGetterInvocationCount++;
        actualValue = string;
        *outError = error;
        return NO;
    });

    //When
    __block NSNumber *actualResult = nil;
    __block NSError *actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    NSInteger expectGetterInvocationCount = 1;
    XCTAssertEqual(expectGetterInvocationCount, actualGetterInvocationCount, @"Failed to correctly handler getter");
    id expectValue = value;
    XCTAssertEqualObjects(expectValue, actualValue, @"Failed to get correct value");
    id expectedResult = @NO;
    XCTAssertEqualObjects(expectedResult, actualResult, @"Failed to return expected result");
    id expectedError = error;
    XCTAssertEqualObjects(expectedError, actualError, @"Failed to return expected error");
}



-(void)testGetStringWithValueNotFoundSource
{
    //Given
    id value = @"";
    BCJSource *source = BCJCreateSource(@{@"notValue": value }, @"value");
    __block NSInteger actualGetterInvocationCount = 0;
    __block id actualValue = nil;
    id<BCLContinuation> continuation = BCJGetString(source, ^BOOL(NSString *string, NSError **outError){
        actualGetterInvocationCount++;
        actualValue = string;
        return YES;
    });

    //When
    __block NSNumber *actualResult = nil;
    __block NSError *actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    NSInteger expectGetterInvocationCount = 0;
    XCTAssertEqual(expectGetterInvocationCount, actualGetterInvocationCount, @"Failed to correctly handler getter");
    id expectValue = nil;
    XCTAssertEqualObjects(expectValue, actualValue, @"Failed to get correct value");
    id expectedResult = @YES;
    XCTAssertEqualObjects(expectedResult, actualResult, @"Failed to return expected result");
    id expectedError = nil;
    XCTAssertEqualObjects(expectedError, actualError, @"Failed to return expected error");
}



-(void)testGetStringWithFailedSource
{
    //Given
    id value = @"";
    BCJSource *source = BCJCreateSource(@{@"notValue":value}, @"value", BCJSourceModeStrict, nil);
    __block NSInteger actualGetterInvocationCount = 0;
    __block id actualValue = nil;
    id<BCLContinuation> continuation = BCJGetString(source, ^BOOL(NSString *string, NSError **outError){
        actualGetterInvocationCount++;
        actualValue = string;
        return YES;
    });

    //When
    __block NSNumber *actualResult = nil;
    __block NSError *actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    NSInteger expectGetterInvocationCount = 0;
    XCTAssertEqual(expectGetterInvocationCount, actualGetterInvocationCount, @"Failed to correctly handler getter");
    id expectValue = nil;
    XCTAssertEqualObjects(expectValue, actualValue, @"Failed to get correct value");
    id expectedResult = @NO;
    XCTAssertEqualObjects(expectedResult, actualResult, @"Failed to return expected result");
    id expectedError = [BCJError missingSourceValueErrorWithSource:source JSONPathComponent:@"value" componentIndex:0];
    XCTAssertEqualObjects(expectedError, actualError, @"Failed to return expected error");
}



#pragma mark - GetMutableString
-(void)testGetMutableStringWithSuccessSource
{
    //Given
    id value = [NSMutableString new];
    BCJSource *source = BCJCreateSource(@{@"value": value }, @"value");
    __block NSInteger actualGetterInvocationCount = 0;
    __block id actualValue = nil;
    id<BCLContinuation> continuation = BCJGetMutableString(source, ^BOOL(NSMutableString *string, NSError **outError){
        actualGetterInvocationCount++;
        actualValue = string;
        return YES;
    });

    //When
    __block NSNumber *actualResult = nil;
    __block NSError *actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    NSInteger expectGetterInvocationCount = 1;
    XCTAssertEqual(expectGetterInvocationCount, actualGetterInvocationCount, @"Failed to correctly handler getter");
    id expectValue = value;
    XCTAssertEqualObjects(expectValue, actualValue, @"Failed to get correct value");
    id expectedResult = @YES;
    XCTAssertEqualObjects(expectedResult, actualResult, @"Failed to return expected result");
    id expectedError = nil;
    XCTAssertEqualObjects(expectedError, actualError, @"Failed to return expected error");
}



-(void)testGetMutableStringWithFailingCompletionBlocking
{
    //Given
    id value = [NSMutableString new];
    BCJSource *source = BCJCreateSource(@{@"value": value }, @"value");
    __block NSInteger actualGetterInvocationCount = 0;
    __block id actualValue = nil;
    NSError *error = [NSError errorWithDomain:@"Placeholder error" code:0 userInfo:nil];
    id<BCLContinuation> continuation = BCJGetMutableString(source, ^BOOL(NSMutableString *string, NSError **outError){
        actualGetterInvocationCount++;
        actualValue = string;
        *outError = error;
        return NO;
    });

    //When
    __block NSNumber *actualResult = nil;
    __block NSError *actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    NSInteger expectGetterInvocationCount = 1;
    XCTAssertEqual(expectGetterInvocationCount, actualGetterInvocationCount, @"Failed to correctly handler getter");
    id expectValue = value;
    XCTAssertEqualObjects(expectValue, actualValue, @"Failed to get correct value");
    id expectedResult = @NO;
    XCTAssertEqualObjects(expectedResult, actualResult, @"Failed to return expected result");
    id expectedError = error;
    XCTAssertEqualObjects(expectedError, actualError, @"Failed to return expected error");
}



-(void)testGetMutableStringWithValueNotFoundSource
{
    //Given
    id value = [NSMutableString new];
    BCJSource *source = BCJCreateSource(@{@"notValue": value }, @"value");
    __block NSInteger actualGetterInvocationCount = 0;
    __block id actualValue = nil;
    id<BCLContinuation> continuation = BCJGetMutableString(source, ^BOOL(NSMutableString *string, NSError **outError){
        actualGetterInvocationCount++;
        actualValue = string;
        return YES;
    });

    //When
    __block NSNumber *actualResult = nil;
    __block NSError *actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    NSInteger expectGetterInvocationCount = 0;
    XCTAssertEqual(expectGetterInvocationCount, actualGetterInvocationCount, @"Failed to correctly handler getter");
    id expectValue = nil;
    XCTAssertEqualObjects(expectValue, actualValue, @"Failed to get correct value");
    id expectedResult = @YES;
    XCTAssertEqualObjects(expectedResult, actualResult, @"Failed to return expected result");
    id expectedError = nil;
    XCTAssertEqualObjects(expectedError, actualError, @"Failed to return expected error");
}



-(void)testGetMutableStringWithFailedSource
{
    //Given
    id value = [NSMutableString new];
    BCJSource *source = BCJCreateSource(@{@"notValue":value}, @"value", BCJSourceModeStrict, nil);
    __block NSInteger actualGetterInvocationCount = 0;
    __block id actualValue = nil;
    id<BCLContinuation> continuation = BCJGetMutableString(source, ^BOOL(NSMutableString *string, NSError **outError){
        actualGetterInvocationCount++;
        actualValue = string;
        return YES;
    });

    //When
    __block NSNumber *actualResult = nil;
    __block NSError *actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    NSInteger expectGetterInvocationCount = 0;
    XCTAssertEqual(expectGetterInvocationCount, actualGetterInvocationCount, @"Failed to correctly handler getter");
    id expectValue = nil;
    XCTAssertEqualObjects(expectValue, actualValue, @"Failed to get correct value");
    id expectedResult = @NO;
    XCTAssertEqualObjects(expectedResult, actualResult, @"Failed to return expected result");
    id expectedError = [BCJError missingSourceValueErrorWithSource:source JSONPathComponent:@"value" componentIndex:0];
    XCTAssertEqualObjects(expectedError, actualError, @"Failed to return expected error");
}



#pragma mark - GetNumber
-(void)testGetNumberWithSuccessSource
{
    //Given
    id value = @101;
    BCJSource *source = BCJCreateSource(@{@"value": value }, @"value");
    __block NSInteger actualGetterInvocationCount = 0;
    __block id actualValue = nil;
    id<BCLContinuation> continuation = BCJGetNumber(source, ^BOOL(NSNumber *number, NSError **outError){
        actualGetterInvocationCount++;
        actualValue = number;
        return YES;
    });

    //When
    __block NSNumber *actualResult = nil;
    __block NSError *actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    NSInteger expectGetterInvocationCount = 1;
    XCTAssertEqual(expectGetterInvocationCount, actualGetterInvocationCount, @"Failed to correctly handler getter");
    id expectValue = value;
    XCTAssertEqualObjects(expectValue, actualValue, @"Failed to get correct value");
    id expectedResult = @YES;
    XCTAssertEqualObjects(expectedResult, actualResult, @"Failed to return expected result");
    id expectedError = nil;
    XCTAssertEqualObjects(expectedError, actualError, @"Failed to return expected error");
}



-(void)testGetNumberWithFailingCompletionBlocking
{
    //Given
    id value = @101;
    BCJSource *source = BCJCreateSource(@{@"value": value }, @"value");
    __block NSInteger actualGetterInvocationCount = 0;
    __block id actualValue = nil;
    NSError *error = [NSError errorWithDomain:@"Placeholder error" code:0 userInfo:nil];
    id<BCLContinuation> continuation = BCJGetNumber(source, ^BOOL(NSNumber *number, NSError **outError){
        actualGetterInvocationCount++;
        actualValue = number;
        *outError = error;
        return NO;
    });

    //When
    __block NSNumber *actualResult = nil;
    __block NSError *actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    NSInteger expectGetterInvocationCount = 1;
    XCTAssertEqual(expectGetterInvocationCount, actualGetterInvocationCount, @"Failed to correctly handler getter");
    id expectValue = value;
    XCTAssertEqualObjects(expectValue, actualValue, @"Failed to get correct value");
    id expectedResult = @NO;
    XCTAssertEqualObjects(expectedResult, actualResult, @"Failed to return expected result");
    id expectedError = error;
    XCTAssertEqualObjects(expectedError, actualError, @"Failed to return expected error");
}



-(void)testGetNumberWithValueNotFoundSource
{
    //Given
    id value = @101;
    BCJSource *source = BCJCreateSource(@{@"notValue": value }, @"value");
    __block NSInteger actualGetterInvocationCount = 0;
    __block id actualValue = nil;
    id<BCLContinuation> continuation = BCJGetNumber(source, ^BOOL(NSNumber *number, NSError **outError){
        actualGetterInvocationCount++;
        actualValue = number;
        return YES;
    });

    //When
    __block NSNumber *actualResult = nil;
    __block NSError *actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    NSInteger expectGetterInvocationCount = 0;
    XCTAssertEqual(expectGetterInvocationCount, actualGetterInvocationCount, @"Failed to correctly handler getter");
    id expectValue = nil;
    XCTAssertEqualObjects(expectValue, actualValue, @"Failed to get correct value");
    id expectedResult = @YES;
    XCTAssertEqualObjects(expectedResult, actualResult, @"Failed to return expected result");
    id expectedError = nil;
    XCTAssertEqualObjects(expectedError, actualError, @"Failed to return expected error");
}



-(void)testGetNumberWithFailedSource
{
    //Given
     id value = @101;
    BCJSource *source = BCJCreateSource(@{@"notValue":value}, @"value", BCJSourceModeStrict, nil);
    __block NSInteger actualGetterInvocationCount = 0;
    __block id actualValue = nil;
    id<BCLContinuation> continuation = BCJGetNumber(source, ^BOOL(NSNumber *number, NSError **outError){
        actualGetterInvocationCount++;
        actualValue = number;
        return YES;
    });

    //When
    __block NSNumber *actualResult = nil;
    __block NSError *actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    NSInteger expectGetterInvocationCount = 0;
    XCTAssertEqual(expectGetterInvocationCount, actualGetterInvocationCount, @"Failed to correctly handler getter");
    id expectValue = nil;
    XCTAssertEqualObjects(expectValue, actualValue, @"Failed to get correct value");
    id expectedResult = @NO;
    XCTAssertEqualObjects(expectedResult, actualResult, @"Failed to return expected result");
    id expectedError = [BCJError missingSourceValueErrorWithSource:source JSONPathComponent:@"value" componentIndex:0];
    XCTAssertEqualObjects(expectedError, actualError, @"Failed to return expected error");
}



#pragma mark - GetNull
-(void)testGetNullWithSuccessSource
{
    //Given
    id value = [NSNull null];
    BCJSource *source = BCJCreateSource(@{@"value": value }, @"value");
    __block NSInteger actualGetterInvocationCount = 0;
    __block id actualValue = nil;
    id<BCLContinuation> continuation = BCJGetNull(source, ^BOOL(NSNull *null, NSError **outError){
        actualGetterInvocationCount++;
        actualValue = null;
        return YES;
    });

    //When
    __block NSNumber *actualResult = nil;
    __block NSError *actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    NSInteger expectGetterInvocationCount = 1;
    XCTAssertEqual(expectGetterInvocationCount, actualGetterInvocationCount, @"Failed to correctly handler getter");
    id expectValue = value;
    XCTAssertEqualObjects(expectValue, actualValue, @"Failed to get correct value");
    id expectedResult = @YES;
    XCTAssertEqualObjects(expectedResult, actualResult, @"Failed to return expected result");
    id expectedError = nil;
    XCTAssertEqualObjects(expectedError, actualError, @"Failed to return expected error");
}



-(void)testGetNullWithFailingCompletionBlocking
{
    //Given
    id value = [NSNull null];
    BCJSource *source = BCJCreateSource(@{@"value": value }, @"value");
    __block NSInteger actualGetterInvocationCount = 0;
    __block id actualValue = nil;
    NSError *error = [NSError errorWithDomain:@"Placeholder error" code:0 userInfo:nil];
    id<BCLContinuation> continuation = BCJGetNull(source, ^BOOL(NSNull *null, NSError **outError){
        actualGetterInvocationCount++;
        actualValue = null;
        *outError = error;
        return NO;
    });

    //When
    __block NSNumber *actualResult = nil;
    __block NSError *actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    NSInteger expectGetterInvocationCount = 1;
    XCTAssertEqual(expectGetterInvocationCount, actualGetterInvocationCount, @"Failed to correctly handler getter");
    id expectValue = value;
    XCTAssertEqualObjects(expectValue, actualValue, @"Failed to get correct value");
    id expectedResult = @NO;
    XCTAssertEqualObjects(expectedResult, actualResult, @"Failed to return expected result");
    id expectedError = error;
    XCTAssertEqualObjects(expectedError, actualError, @"Failed to return expected error");
}



-(void)testGetNullWithValueNotFoundSource
{
    //Given
    id value = [NSNull null];
    BCJSource *source = BCJCreateSource(@{@"notValue": value }, @"value");
    __block NSInteger actualGetterInvocationCount = 0;
    __block id actualValue = nil;
    id<BCLContinuation> continuation = BCJGetNull(source, ^BOOL(NSNull *null, NSError **outError){
        actualGetterInvocationCount++;
        actualValue = null;
        return YES;
    });

    //When
    __block NSNumber *actualResult = nil;
    __block NSError *actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    NSInteger expectGetterInvocationCount = 0;
    XCTAssertEqual(expectGetterInvocationCount, actualGetterInvocationCount, @"Failed to correctly handler getter");
    id expectValue = nil;
    XCTAssertEqualObjects(expectValue, actualValue, @"Failed to get correct value");
    id expectedResult = @YES;
    XCTAssertEqualObjects(expectedResult, actualResult, @"Failed to return expected result");
    id expectedError = nil;
    XCTAssertEqualObjects(expectedError, actualError, @"Failed to return expected error");
}



-(void)testGetNullWithFailedSource
{
    //Given
    id value = [NSNull null];
    BCJSource *source = BCJCreateSource(@{@"notValue":value}, @"value", BCJSourceModeStrict, nil);
    __block NSInteger actualGetterInvocationCount = 0;
    __block id actualValue = nil;
    id<BCLContinuation> continuation = BCJGetNull(source, ^BOOL(NSNull *null, NSError **outError){
        actualGetterInvocationCount++;
        actualValue = null;
        return YES;
    });

    //When
    __block NSNumber *actualResult = nil;
    __block NSError *actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    NSInteger expectGetterInvocationCount = 0;
    XCTAssertEqual(expectGetterInvocationCount, actualGetterInvocationCount, @"Failed to correctly handler getter");
    id expectValue = nil;
    XCTAssertEqualObjects(expectValue, actualValue, @"Failed to get correct value");
    id expectedResult = @NO;
    XCTAssertEqualObjects(expectedResult, actualResult, @"Failed to return expected result");
    id expectedError = [BCJError missingSourceValueErrorWithSource:source JSONPathComponent:@"value" componentIndex:0];
    XCTAssertEqualObjects(expectedError, actualError, @"Failed to return expected error");
}


@end
