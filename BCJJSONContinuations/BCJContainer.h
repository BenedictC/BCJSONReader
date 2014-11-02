//
//  BCJContainer.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 30/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJContainerProtocols.h"



@interface BCJContainer : NSObject <BCJIndexedContainer, BCJKeyedContainer>

-(instancetype)initWithContent:(id)content;

@property(nonatomic,readonly) id content;
@property(nonatomic, readonly) BOOL isSealed;

-(void)setContentAndSeal:(id)object;

@end

