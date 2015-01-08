//
//  BCJValidationProxy.m
//  BCJSONReader
//
//  Created by Benedict Cohen on 08/01/2015.
//  Copyright (c) 2015 Benedict Cohen. All rights reserved.
//

#import "BCJValidationProxy.h"
#import "BCJSONPathEvaluation.h"



@interface BCJValidationProxy ()
{
    id _object;
}
@end



@implementation BCJValidationProxy

+(instancetype)proxyWithObject:(id)object
{
    BCJValidationProxy *proxy = [self alloc];
    proxy->_object = object;
    return proxy;
}



-(id)valueForKey:(NSString *)JSONPath
{
    return BCJEvaluateJSONPath(JSONPath, self->_object, NULL, NULL);
}



-(void)forwardInvocation:(NSInvocation *)anInvocation
{
    [anInvocation setTarget:self->_object];
    [anInvocation invoke];
    return;
}



-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    return [self->_object methodSignatureForSelector:aSelector];
}

@end

