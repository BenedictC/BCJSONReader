//
//  BCLContinuationProtocol.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 27/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 The BCLContinuation protocol represents a continuation. A continuation is a discreet unit of work that can either succeed or fail.
 */
@protocol BCLContinuation <NSObject>
/**
 Invocation of this method should result in the work of the continuation being performed. When the continuation completes it must call the completion handler.

 @param completionHandler A block that must the continuation must execute once it has completed its' work. If the continuation was successful it should pass nil for error, otherwise it should pass an NSError describing the reason for failure.
 */
-(void)executeWithCompletionHandler:(void(^)(BOOL didSucceed, NSError *error))completionHandler;

@end
