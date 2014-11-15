//
//  BCJContainerProtocols.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 01/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>



/**
 The BCJContainer protocols declare methods for accessing data held in collection. The protocols formalize the methods
 used by BCJJSONSource for accessing elements used in JSONPath.
 */
@protocol BCJContainer <NSObject>
@optional
-(id)content;
@end



@protocol BCJIndexedContainer <BCJContainer>
-(id)objectAtIndex:(NSUInteger)idx;
-(NSUInteger)count;
@end



@protocol BCJKeyedContainer <BCJContainer>
-(id)objectForKey:(id)key;
@end



@interface NSArray (BCJIndexedContainer) <BCJIndexedContainer>
@end



@interface NSDictionary (BCJKeyedContainer) <BCJKeyedContainer>
@end
