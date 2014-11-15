//
//  BCJMap.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 01/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLContinuations.h"
#import "BCJDefines.h"

@class BCJJSONSource;
@class BCJJSONTarget;



#pragma mark - Macros
/**
 Creates an array of ascending sort descriptors using the supplied strings as keys.

 @param ... A list of NSStrings. The list does not need to be nil terminated.

 @return An array containing NSSortDescriptor objects.
 */
#define BCJ_SORT_DESCRIPTORS(...) ({ \
    NSArray *sortKeys = [NSArray arrayWithObjects: __VA_ARGS__, nil];\
    NSMutableArray *sortDescriptors = [NSMutableArray new]; \
    for (NSString *sortKey in sortKeys) { \
        [sortDescriptors addObject:[NSSortDescriptor sortDescriptorWithKey:sortKey ascending:YES]]; \
    } \
    sortDescriptors; \
})



#pragma mark - constants
/**
 Options for changing the behaviour of BCJMap.
 */
typedef NS_OPTIONS(NSUInteger, BCJMapOptions){
    /**
     If the map block returns fails to map an element then the mapping will continue and the error will be ignored.
     */
    BCJMapOptionDiscardMappingErrors  =(1UL  << 1),
};



#pragma mark - Map functions
/**
 Returns an NSArray created by enumerates the contents of an array, checking that the elements are of type elementClass, invokes mapFromArray with each key/element pair and stores the results in the output array.

 @param array         An array.
 @param elementClass  The expected class of the elements of array.
 @param options       The options to change the mapping behaviour.
 @param ^mapFromArray A block that takes the index & value and returns an object. If the block cannot return an object then it should set the output error to an NSError describing why the mapping failed and return nil.

 @return an NSArray.
 */
BCJ_OVERLOADABLE NSArray *BCJMap(NSArray *array, Class elementClass, BCJMapOptions options, id(^mapFromArray)(NSUInteger elementIdx, id elementValue, NSError **outError), NSError **outError) BCJ_REQUIRED(1,2,4,5);
/**
 Returns an NSArray created by enumerates the contents of a dictionary, checking that the elements are of type elementClass, invokes mapFromDictionary with each key/element pair and stores the result in an array then finally sorts the array using sortDescriptors.

 @param dict               A dictionary.
 @param elementClass       The expected class of the elements of dict.
 @param options            The options to change the mapping behaviour.
 @param sortDescriptiors   An array of sortDescriptors or nil.
 @param ^mapFromDictionary A block that takes the a key/value pair and returns an object. If the block cannot return an object then it should set the output error to an NSError describing why the mapping failed and return nil.

 @return an NSArray.
 */
BCJ_OVERLOADABLE NSArray *BCJMap(NSDictionary *dict, Class elementClass, BCJMapOptions options, NSArray *sortDescriptiors, id(^mapFromDictionary)(id elementKey, id elementValue, NSError **outError), NSError **outError) BCJ_REQUIRED(1,2,4,5) ;



#pragma mark - Set Map continuations
/**
 Returns a continuation that attempts to get an array from source, invoke BCJMap and if successful attempts to set the resulting array on target.

 @param target        A target that references an NSArray property.
 @param source        A source that references an NSArray.
 @param elementClass  The class that elements of the source array are expected to be.
 @param options       The options to change the mapping behaviour.
 @param ^fromArrayMap The mapping block.

 @return A continuation.
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(BCJJSONTarget *target, BCJJSONSource *source, Class elementClass, BCJMapOptions options, id(^fromArrayMap)(NSUInteger elementIndex, id elementValue, NSError **outError)) BCJ_REQUIRED(1,2,5) BCJ_WARN_UNUSED;
/**
 Returns a continuation that attempts to get a dictionary from source, invoke BCJMap and if successful attempts to set the resulting array on target.

 @param target             A target that references an NSDictionary property.
 @param source             A source that references an NSArray.
 @param elementClass       The class that elements of the source dictionary are expected to be.
 @param options            The options to chang ethe mapping behaviour.
 @param ^fromDictionaryMap The mapping block.

 @return A continuation.
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(BCJJSONTarget *target, BCJJSONSource *source, Class elementClass, BCJMapOptions options, NSArray *sortDescriptors, id(^fromDictionaryMap)(id elementKey, id elementValue, NSError **outError)) BCJ_REQUIRED(1,2,6) BCJ_WARN_UNUSED;
