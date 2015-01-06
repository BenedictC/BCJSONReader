//
//  BCJDefines.h
//  BCJSONReader
//
//  Created by Benedict Cohen on 01/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//



//Macros for __attribute__. Foundation provides similar macros but they are not consistent across platforms.
#define BCJ_WARN_UNUSED __attribute__((warn_unused_result))
#define BCJ_REQUIRED(...) __attribute__((nonnull(__VA_ARGS__)))
#define BCJ_DESIGNATED_INIT __attribute__((objc_designated_initializer))
#define BCJ_PRINTF_FORMAT_STYLE(...) __attribute__((format(__NSString__,__VA_ARGS__)))