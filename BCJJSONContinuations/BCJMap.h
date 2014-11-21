//
//  BCJMap.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 01/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLContinuations.h"
#import "BCJDefines.h"
#import "BCJMapOptions.h"
#import "BCJJSONSourceConstants.h"

@class BCJJSONSource;
@class BCJPropertyTarget;



#pragma mark - Enums
/**
 Returns by references the a value from enumMapping. The value is fetched by getting the value from source and using this as the key in enumMapping.

 @warning source.defaultValue, if specified, is used as the key for the mapping, it is NOT the final value.

 @param source      A source that references a key in enumMapping.
 @param enumMapping A dictionary.
 @param outValue    On success contains the value, otherwise nil.
 @param outError    On failure contains an NSError describing the reason for failure, otherwise nil.

 @return The result of getting the value from the source or BCJJSONSourceResultFailure if the key was not found in enumMapping.
 */
BCJJSONSourceResult BCJ_OVERLOADABLE BCJGetEnum(BCJJSONSource *source, NSDictionary *enumMapping, id *outValue, NSError **outError) BCJ_REQUIRED(1,2,3,4);
/**
 Returns a continuation that calls BCJGetEnum and if a value was fetched invokes setValue:outError: on target with the value from BCJGetEnum.

 @param target      A target that references the same type as the values of enumMapping.
 @param source      A source that references the same type as the keys of enumMapping.
 @param enumMapping A dictionary.

 @return A continuation.
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetEnum(BCJJSONSource *source, BCJPropertyTarget *target, NSDictionary *enumMapping) BCJ_REQUIRED(1,2,3) BCJ_WARN_UNUSED;



#pragma mark - Map functions
/**
 Returns an NSArray created by enumerates the contents of an array, checking that the elements are of type elementClass, invokes mapFromArray with each key/element pair and stores the results in the output array.

 @param array         An array.
 @param elementClass  The expected class of the elements of array.
 @param options       The options to change the mapping behaviour.
 @param ^mapFromArray A block that takes the index & value and returns an object. If the block cannot return an object then it should set the output error to an NSError describing why the mapping failed and return nil.

 @return an NSArray.
 */
BCJ_OVERLOADABLE NSArray *BCJGetMap(NSArray *array, Class elementClass, BCJMapOptions options, id(^mapFromArray)(NSUInteger elementIdx, id elementValue, NSError **outError), NSError **outError) BCJ_REQUIRED(1,2,4,5);
/**
 Returns an NSArray created by enumerates the contents of a dictionary, checking that the elements are of type elementClass, invokes mapFromDictionary with each key/element pair and stores the result in an array then finally sorts the array using sortDescriptors.

 @param dict               A dictionary.
 @param elementClass       The expected class of the elements of dict.
 @param options            The options to change the mapping behaviour.
 @param sortDescriptiors   An array of sortDescriptors or nil.
 @param ^mapFromDictionary A block that takes the a key/value pair and returns an object. If the block cannot return an object then it should set the output error to an NSError describing why the mapping failed and return nil.

 @return an NSArray.
 */
BCJ_OVERLOADABLE NSArray *BCJGetMap(NSDictionary *dict, Class elementClass, BCJMapOptions options, NSArray *sortDescriptiors, id(^mapFromDictionary)(id elementKey, id elementValue, NSError **outError), NSError **outError) BCJ_REQUIRED(1,2,4,5) ;



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
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(BCJJSONSource *source, BCJPropertyTarget *target, Class elementClass, BCJMapOptions options, id(^fromArrayMap)(NSUInteger elementIndex, id elementValue, NSError **outError)) BCJ_REQUIRED(1,2,5) BCJ_WARN_UNUSED;
/**
 Returns a continuation that attempts to get a dictionary from source, invoke BCJMap and if successful attempts to set the resulting array on target.

 @param target             A target that references an NSDictionary property.
 @param source             A source that references an NSArray.
 @param elementClass       The class that elements of the source dictionary are expected to be.
 @param options            The options to chang ethe mapping behaviour.
 @param ^fromDictionaryMap The mapping block.

 @return A continuation.
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetMap(BCJJSONSource *source, BCJPropertyTarget *target, Class elementClass, BCJMapOptions options, NSArray *sortDescriptors, id(^fromDictionaryMap)(id elementKey, id elementValue, NSError **outError)) BCJ_REQUIRED(1,2,6) BCJ_WARN_UNUSED;



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
