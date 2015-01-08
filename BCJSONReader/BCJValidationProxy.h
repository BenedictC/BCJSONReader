//
//  BCJValidationProxy.h
//  BCJSONReader
//
//  Created by Benedict Cohen on 08/01/2015.
//  Copyright (c) 2015 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BCJSONReader;



@interface BCJValidationProxy : NSProxy

+(instancetype)proxyWithObject:(id)object;

@end

