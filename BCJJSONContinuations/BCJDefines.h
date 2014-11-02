//
//  BCJDefines.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 01/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#define BCJ_OVERLOADABLE __attribute__((overloadable))



#ifdef DEBUG
#define BCJ_KEY(NAME) NSStringFromSelector(@selector(NAME))
#else
#define BCJ_KEY(NAME) @"" #NAME
#endif

