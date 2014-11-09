//
//  BCJDefines.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 01/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#define BCJ_OVERLOADABLE __attribute__((overloadable))
#define BCJ_WARN_UNUSED __attribute__((warn_unused_result))
#define BCJ_REQUIRED(...) __attribute__((nonnull(__VA_ARGS__)))