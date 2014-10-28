//
//  BCLContinuationProtocol.h
//  BCMJSONAccess
//
//  Created by Benedict Cohen on 27/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol BCLContinuation <NSObject>

-(BOOL)executeAndReturnError:(NSError **)error;

@end
