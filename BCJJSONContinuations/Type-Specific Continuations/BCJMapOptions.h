//
//  BCJMapOptions.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 20/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#ifndef BCJJSONContinuations_BCJMapOptions_h
#define BCJJSONContinuations_BCJMapOptions_h



/**
 Options for changing the behaviour of BCJMap.
 */
typedef NS_OPTIONS(NSUInteger, BCJMapOptions){
    /**
     If the map block returns fails to map an element then the mapping will continue and the error will be ignored.
     */
    BCJMapOptionIgnoreFailedMappings = (1UL << 0),
};



#endif
