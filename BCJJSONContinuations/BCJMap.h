//
//  BCJMap.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 01/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLContinuation.h"
#import "BCJDefines.h"

@class BCJJSONSource;
@class BCJJSONTarget;



#pragma mark - Macros
#define BCJ_SORT_DESCRIPTORS(...) ({ \
    NSArray *sortKeys = [NSArray arrayWithObjects: __VA_ARGS__, nil];\
    NSMutableArray *sortDescriptors = [NSMutableArray new]; \
    for (NSString *sortKey in sortKeys) { \
        [sortDescriptors addObject:[NSSortDescriptor sortDescriptorWithKey:sortKey ascending:YES]]; \
    } \
    sortDescriptors; \
})



#pragma mark - constants
typedef NS_OPTIONS(NSUInteger, BCJMapOptions) {
    //Control flow behaviour
    BCJMapOptionDiscardMappingErrors  = (1UL  << 1),
};



#pragma mark - Map functions
BCJ_OVERLOADABLE NSArray *BCJMap(NSDictionary *dict, Class elementClass, BCJMapOptions options, NSArray *sortDescriptiors, id(^mapFromDictionary)(id elementKey, id elementValue, NSError **outError), NSError **outError) BCJ_REQUIRED(1,2,4,5) ;

BCJ_OVERLOADABLE NSArray *BCJMap(NSArray *array, Class elementClass, BCJMapOptions options, id(^mapFromArray)(NSUInteger elementIdx, id elementValue, NSError **outError), NSError **outError) BCJ_REQUIRED(1,2,4,5);



#pragma mark - Set Map continuations
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(BCJJSONTarget *target, BCJJSONSource *source, Class elementClass, BCJMapOptions options, id(^fromArrayMap)(NSUInteger elementIndex, id elementValue, NSError **outError)) BCJ_REQUIRED(1,2,5) BCJ_WARN_UNUSED;
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(BCJJSONTarget *target, BCJJSONSource *source, Class elementClass, BCJMapOptions options, NSArray *sortDescriptors, id(^fromDictionaryMap)(id elementKey, id elementValue, NSError **outError)) BCJ_REQUIRED(1,2,6) BCJ_WARN_UNUSED;
