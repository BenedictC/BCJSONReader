//
//  main.m
//  TypeCheckedCollectionAccess
//
//  Created by Benedict Cohen on 20/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AttemptSalvage.h"
#import "BCLContinuation.h"

#import "BCJJSONContinuations.h"



@interface TestObject : NSObject
@property NSInteger number;
@property NSString *string;
@end

@implementation TestObject

@end



int main(int argc, const char * argv[]) {
    @autoreleasepool {

//        NSDictionary *json = @{@"number": @7,
//                               @"string": @"arf"};
//
//      //Plain function access
//        void (^handleError)(NSError *) = ^(NSError *error){
//            [error self];
//        };
//        id value;
//        NSError *error;
//        //Function with error returned
//        if ((error = BCLArrayGetMandatoryObject(@[], 0, [NSArray class], &value))) handleError(error);
//        //Function with status returned
//        if (BCLArrayGetMandatoryObject(@[], 0, [NSArray class], &value, &error)) handleError(error);
//        //Function with completion block
//        BCLArrayGetMandatoryObject(@[], 0, [NSArray class], ^(BOOL didSucceed, id value, NSError *error){
//
//        });



//        //Macro control-flow
//        ATTEMPT({
//            BCMSetAbandonOnError(YES);
//            NSNumber *number  = BCMDictionaryGetMandatoryObject(json, @"number", [NSNumber class]);
//
//            NSInteger integer = BCMDictionaryGetMandatoryInteger(json, @"number");
//            id string = BCMDictionaryGetMandatoryString(json, @"number");
//            [string self];
//
//            NSLog(@"%@, %ld", number, integer);
//        })
//        SALVAGE({
//            NSLog(@"Failed with errors: %@", BCMGetErrors());
//        });



//Continuation
        NSDictionary *sourceObject = @{
                                       @"number": @7,
                                       @"string": @"arf"
                                       };
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:sourceObject options:0 error:NULL];
        TestObject *target = [TestObject new];
        NSArray *errors = ({
            NSDictionary *json;

            [BCLContinuation untilEnd:
             BCJDeserializeJSON(jsonData, &json),
             BCJSetNumber(json, @"number", target, BCJ_KEY(number)),
             BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
                id localJson = json;
                NSLog(@"%@", localJson);
                return YES;
            }),
             BCJSetNumber(json, @"notANumber", BCJGetterModeOptional, 0, target, BCJ_KEY(number)),
             BCJSetString(json, @"string", BCJGetterModeNullableDefaultable, @"default", target, BCJ_KEY(string)),
             BCJSetString(json, @"string", target, BCJ_KEY(string)),
             BCJGetValue(json, @"number", NSNumber.class, 0, nil, ^(NSNumber *number){
                return;
            }),
             nil];
        });

        [errors self];
    }
    return 0;
}
