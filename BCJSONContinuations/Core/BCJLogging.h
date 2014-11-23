//
//  BCJLogging.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 03/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>



/**
 The type definition for BCJ logging function.
 */
typedef void (*BCJLogFunctionRef)(NSString *, va_list args);



/**
 The function used by BCJJSONContinuations to write log messages.

 @return The logging function.
 */
BCJLogFunctionRef BCJGetLogFunction();



/**
 Sets the function used by BCJJSONContinuations to write log messages. For DEBUG builds this value is initalized with
 to use NSLogv. When DEBUG is not defined then it is initalized to NULL.

 @param logFunction a logging function or NULL.
 */
void BCJSetLogFunction(BCJLogFunctionRef logFunction);



/**
 Adds a message to the log.

 @param format NSLog style format string
 @param ...    values specified by format.
 */
void BCJLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);
