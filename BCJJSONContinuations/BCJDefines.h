//
//  BCJDefines.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 01/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//



//Macros for __attribute__. Foundation provides similar macros but they are not consistent across platforms.
#define BCJ_OVERLOADABLE __attribute__((overloadable))
#define BCJ_WARN_UNUSED __attribute__((warn_unused_result))
#define BCJ_REQUIRED(...) __attribute__((nonnull(__VA_ARGS__)))

#ifdef DEBUG
#define BCJ_KEY(NAME) NSStringFromSelector(@selector(NAME))
#else
#define BCJ_KEY(NAME) @"" #NAME
#endif


//TODO: Replace NS*Assert with BCJ*Assert so that they are not removed in release builds
//#define BCJParameterAssert()
//#define BCJAssert()