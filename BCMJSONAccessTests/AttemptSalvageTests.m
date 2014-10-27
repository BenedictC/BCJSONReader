//
//  AttemptSalvageTests.m
//  BCMJSONAccess
//
//  Created by Benedict Cohen on 26/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "AttemptSalvage.h"



@interface AttemptSalvageTests : XCTestCase

@end



@implementation AttemptSalvageTests

- (void)testNormalExecution {
    //Given
    BOOL didExecuteAttemptBlock = NO;
    BOOL didExecuteSalvageBlock = NO;

    //When
    ATTEMPT({
        didExecuteAttemptBlock = YES;
    })
    SALVAGE({
        didExecuteSalvageBlock = YES;
    })

    //Then
    BOOL shouldExecuteAttemptBlock = YES;
    BOOL shouldExecuteSalvageBlock = NO;
    XCTAssertEqual(shouldExecuteAttemptBlock, didExecuteAttemptBlock, @"Failed to follow expected control flow.");
    XCTAssertEqual(shouldExecuteSalvageBlock, didExecuteSalvageBlock, @"Failed to follow expected control flow.");
}



- (void)testAbandonedExecution {
    //Given
    BOOL didExecuteAttemptBlock = NO;
    BOOL didExecuteSalvageBlock = NO;

    //When
    ATTEMPT({
        didExecuteAttemptBlock = YES;
        ABANDON();
    })
    SALVAGE({
        didExecuteSalvageBlock = YES;
    })

    //Then
    BOOL shouldExecuteAttemptBlock = YES;
    BOOL shouldExecuteSalvageBlock = YES;
    XCTAssertEqual(shouldExecuteAttemptBlock, didExecuteAttemptBlock, @"Failed to follow expected control flow.");
    XCTAssertEqual(shouldExecuteSalvageBlock, didExecuteSalvageBlock, @"Failed to follow expected control flow.");
}



- (void)testFailuresExecution {
    //Given
    BOOL didExecuteAttemptBlock = NO;
    BOOL didExecuteSalvageBlock = NO;

    //When
    ATTEMPT({
        didExecuteAttemptBlock = YES;
        SET_FAILURE_INFO(@"key", @"value");
    })
    SALVAGE({
        didExecuteSalvageBlock = YES;
    })

    //Then
    BOOL shouldExecuteAttemptBlock = YES;
    BOOL shouldExecuteSalvageBlock = YES;
    XCTAssertEqual(shouldExecuteAttemptBlock, didExecuteAttemptBlock, @"Failed to follow expected control flow.");
    XCTAssertEqual(shouldExecuteSalvageBlock, didExecuteSalvageBlock, @"Failed to follow expected control flow.");
}



- (void)testTestRecantedFailureExecution {
    //Given
    BOOL didExecuteAttemptBlock = NO;
    BOOL didExecuteSalvageBlock = NO;

    //When
    ATTEMPT({
        didExecuteAttemptBlock = YES;
        SET_FAILURE_INFO(@"key", @"value");
        SET_FAILURE_INFO(@"key", nil);
    })
    SALVAGE({
        didExecuteSalvageBlock = YES;
    })

    //Then
    BOOL shouldExecuteAttemptBlock = YES;
    BOOL shouldExecuteSalvageBlock = NO;
    XCTAssertEqual(shouldExecuteAttemptBlock, didExecuteAttemptBlock, @"Failed to follow expected control flow.");
    XCTAssertEqual(shouldExecuteSalvageBlock, didExecuteSalvageBlock, @"Failed to follow expected control flow.");
}



- (void)testReturnExecution {
    //Given
    __block BOOL didExecuteAttemptBlock = NO;
    __block BOOL didExecuteSalvageBlock = NO;
    __block BOOL didFinishBlock = NO;

    //When
    ^{
        ATTEMPT({
            didExecuteAttemptBlock = YES;
            SET_FAILURE_INFO(@"key", @"value");
            return;
        })
        SALVAGE({
            didExecuteSalvageBlock = YES;
        })
        didFinishBlock = YES;
    }();

    //Then
    BOOL shouldExecuteAttemptBlock = YES;
    BOOL shouldExecuteSalvageBlock = NO;
    BOOL shouldFinishBlock = NO;
    XCTAssertEqual(shouldExecuteAttemptBlock, didExecuteAttemptBlock, @"Failed to follow expected control flow.");
    XCTAssertEqual(shouldExecuteSalvageBlock, didExecuteSalvageBlock, @"Failed to follow expected control flow.");
    XCTAssertEqual(shouldFinishBlock, didFinishBlock, @"Failed to follow expected control flow.");
}



- (void)testBreakExecution {
    //Given
    BOOL didExecuteAttemptBlock = NO;
    BOOL didExecuteSalvageBlock = NO;

    //When
    ATTEMPT({
        didExecuteAttemptBlock = YES;
        SET_FAILURE_INFO(@"key", @"value");
        break;
    })
    SALVAGE({
        didExecuteSalvageBlock = YES;
    })

    //Then
    BOOL shouldExecuteAttemptBlock = YES;
    BOOL shouldExecuteSalvageBlock = NO;
    XCTAssertEqual(shouldExecuteAttemptBlock, didExecuteAttemptBlock, @"Failed to follow expected control flow.");
    XCTAssertEqual(shouldExecuteSalvageBlock, didExecuteSalvageBlock, @"Failed to follow expected control flow.");
}



- (void)testAbandonInSalvageExecution {
    XCTAssert(YES, @"Pass");

    void (^testBlock)(void) = ^{
        ATTEMPT({
            ABANDON();
        })
        SALVAGE({
            ABANDON();
        })
    };

    XCTAssertThrows(testBlock(), @"ABANDON failed to throw exception when called from within SALVAGE.");
}

@end
