//
//  BCJLogging.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 03/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJLogging.h"
#import <pthread/pthread.h>
#import <asl.h>



static BCJLogFunctionRef _logFunction = NULL;
static pthread_rwlock_t _logFunctionLock;



#pragma mark - Life cycle
__attribute__((constructor)) static void BCJLogConstructor() {
    pthread_rwlock_init(&_logFunctionLock, NULL);

#ifdef DEBUG
    BCJSetLogFunction(NSLogv);
#endif
}



__attribute__((destructor)) static void BCJLogDeconstructor() {
    BCJSetLogFunction(NULL);
    pthread_rwlock_destroy(&_logFunctionLock);
}



#pragma mark - Getter & setter
BCJLogFunctionRef BCJGetLogFunction() {
    pthread_rwlock_rdlock(&_logFunctionLock);
    BCJLogFunctionRef logFunction = _logFunction;
    pthread_rwlock_unlock(&_logFunctionLock);

    return logFunction;
}



void BCJSetLogFunction(BCJLogFunctionRef logFunction) {
    pthread_rwlock_wrlock(&_logFunctionLock);
    _logFunction = logFunction;
    pthread_rwlock_unlock(&_logFunctionLock);
}



#pragma mark - logging
void BCJLog(NSString *format, ...) {
    BCJLogFunctionRef log = BCJGetLogFunction();
    if (log == NULL) return;

    va_list args;
    va_start(args, format);

    log(format, args);

    va_end(args);
}
