//
//  BCLContinuationProtocol.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 27/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

@import Foundation;



@protocol BCLContinuation <NSObject>

-(void)executeWithCompletionHandler:(void(^)(BOOL didSucceed, NSError *error))completionHandler;

@end
