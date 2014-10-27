//
//  BCMJSONAccessMacros.h
//  BCMJSONAccessMacros
//
//  Created by Benedict Cohen on 24/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#ifndef BCMJSONAccessMacros_h
#define BCMJSONAccessMacros_h

#import "AttemptSalvage.h"
#import "BCLTypeCheckedCollectionAccessors.h"

/**

 BCMJSONAccessMacros provides macros to access collections in a type safe manner and control flow for handling
 errors. BCMJSONAccessMacros depends on BCLTypeCheckedCollectionAccessors for accessing the objects and
 ATTEMPT/SALVAGE for control flow.

 */



#pragma mark - FAILURE_INFO Keys
/**
 The key for the NSArray which stores NSErrors occured during the ATTEMPT block.
 */
static NSString * const BCMErrorsKey = @"BCMErrorsKey";
/**
 The key for the NSNumber which stores a BOOL which indicates if BCMSetAbandonOnError should ABANDON() when called.
 */
static NSString * const BCMShouldAbandonOnErrorKey = @"BCMShouldAbandonOnErrorKey";



#pragma mark - Control Flow
/**
 Changes the behaviour of BCMHandleError to call ABANDON() when an error occurs. All other BCM* macros call
 BCMHandleError.

 @param ABANDON_ON_ERROR A bool.

 @return none.
 */
#define BCMSetAbandonOnError(ABANDON_ON_ERROR) \
do { \
BOOL shouldAbandon = (ABANDON_ON_ERROR); \
SET_FAILURE_INFO(BCMShouldAbandonOnErrorKey, @(shouldAbandon)); \
} while(0)



#pragma mark - Error Handling
/**
 Adds the supplied error to the error array. If BCMSetAbandonOnError has been called with YES then this macro will also
 call ABANDON.

 @param ERROR The error to add to the error array.

 @return none
 */
#define BCMHandleError(ERROR) do { \
/* Fetch/create the errors array and store the error. */ \
NSMutableArray *errors = FAILURE_INFO(BCMErrorsKey); \
if (errors == nil) { \
errors = [NSMutableArray new]; \
SET_FAILURE_INFO(BCMErrorsKey, errors); \
} \
NSError *err = (ERROR); \
if (err != nil) [errors addObject:err]; \
/* Jump ship? */ \
BOOL shouldAbandon = [FAILURE_INFO(BCMShouldAbandonOnErrorKey) boolValue];\
if (shouldAbandon) ABANDON(); \
} while(0)



/**
 Returns an NSArray of NSError objects that occured within the ATTEMPT block.

 @return an NSArray of NSError objects.
 */
#define BCMGetErrors() FAILURE_INFO(BCMErrorsKey)


#pragma mark - BCL* Function Wrappers

#define BCMIsKindOfClass(OBJECT, CLASS) ({ \
NSError *error = BCLIsKindOfClass((OBJECT), (CLASS)); \
BOOL success = error == nil; \
if (!success) BCMHandleError(error); \
success; \
})



#define BCMArrayGetMandatoryObject(OBJECT, IDX, CLASS) ({ \
id result; \
NSError *error = BCLArrayGetMandatoryObject((OBJECT), (IDX), (CLASS), &result); \
if (error != nil) BCMHandleError(error); \
result; \
})



#define BCMArrayGetNullableObject(OBJECT, IDX, NULL_SUB, CLASS) ({ \
id result; \
NSError *error = BCLArrayGetNullableObject((OBJECT), (IDX), (CLASS), (NULL_SUB), &result); \
if (error != nil) BCMHandleError(error); \
result; \
})



#define BCMDictionaryGetMandatoryObject(OBJECT, KEY, CLASS) ({ \
id result; \
NSError *error = BCLDictionaryGetMandatoryObject((OBJECT), (KEY), (CLASS), &result); \
if (error != nil) BCMHandleError(error); \
result; \
})



#define BCMDictionaryGetNullableObject(OBJECT, KEY, NULL_SUB, CLASS) ({ \
id result; \
NSError *error =  BCLDictionaryGetNullableObject((OBJECT), (KEY), (CLASS), (NULL_SUB), &result); \
if (error != nil) BCMHandleError(error); \
result; \
})



#define BCMDictionaryGetOptionalObject(OBJECT, KEY, DEFAULT_VALUE, CLASS) ({ \
id result; \
NSError *error = BCLDictionaryGetOptionalObject((OBJECT), (KEY), (CLASS), (DEFAULT_VALUE), &result); \
if (error != nil) BCMHandleError(error); \
result; \
})



#pragma mark - Type Checking Wrappers

//Common Types
#define BCMIsNumber(OBJECT) BCMIsKindOfClass((OBJECT), [NSNumber class])
#define BCMIsArray(OBJECT)  BCMIsKindOfClass((OBJECT), [NSArray class])
#define BCMIsMutableArray(OBJECT) BCMIsKindOfClass((OBJECT), [NSMutableArray class])
#define BCMIsDictionary(OBJECT) BCMIsKindOfClass((OBJECT), [NSDictionary class])
#define BCMIsMutableDictionary(OBJECT) BCMIsKindOfClass((OBJECT), [NSMutableDictionary class])
#define BCMIsString(OBJECT) BCMIsKindOfClass((OBJECT), [NSString class])
#define BCMIsMutableString(OBJECT) BCMIsKindOfClass((OBJECT), [NSMutableString class])
//JSON Types
#define BCMIsNull(OBJECT) BCMIsKindOfClass((OBJECT), [NSNull class])
//Property List Types
#define BCMIsDate(OBJECT) BCMIsKindOfClass((OBJECT), [NSDate class])
#define BCMIsData(OBJECT) BCMIsKindOfClass((OBJECT), [NSData class])
#define BCMIsMutableData(OBJECT) BCMIsKindOfClass((OBJECT), [NSMutableData class])



#pragma mark - NSArray Specific Wrappers

#pragma mark Mandatory values

//Common Types
#define BCMArrayGetMandatoryInteger(ARRAY, IDX) ({ \
NSNumber *value = BCMArrayGetMandatoryObject((ARRAY), (IDX), [NSNumber class]); \
[value integerValue]; \
})
#define BCMArrayGetMandatoryDouble(ARRAY, IDX) ({ \
NSNumber *value = BCMArrayGetMandatoryObject((ARRAY), (IDX), [NSNumber class]); \
[value doubleValue]; \
})
#define BCMArrayGetMandatoryBoolean(ARRAY, IDX) ({ \
NSNumber *value = BCMArrayGetMandatoryObject((ARRAY), (IDX), [NSNumber class]); \
[value booleanValue]; \
})
#define BCMArrayGetMandatoryString(ARRAY, IDX) BCMArrayGetMandatoryObject((ARRAY), (IDX), [NSString class])
#define BCMArrayGetMandatoryDictionary(ARRAY, IDX) BCMArrayGetMandatoryObject((ARRAY), (IDX), [NSDictionary class])
#define BCMArrayGetMandatoryArray(ARRAY, IDX) BCMArrayGetMandatoryObject((ARRAY), (IDX), [NSArray class])
#define BCMArrayGetMandatoryMutableString(ARRAY, IDX) BCMArrayGetMandatoryObject((ARRAY), (IDX), [NSMutableString class])
#define BCMArrayGetMandatoryMutableDictionary(ARRAY, IDX) BCMArrayGetMandatoryObject((ARRAY), (IDX), [NSMutableDictionary class])
#define BCMArrayGetMandatoryMutableArray(ARRAY, IDX) BCMArrayGetMandatoryObject((ARRAY), (IDX), [NSMutableArray class])
//JSON Types
#define BCMArrayGetMandatoryNull(ARRAY, IDX) BCMArrayGetMandatoryObject((ARRAY), (IDX), [NSNull class])
//Property List Types
#define BCMArrayGetMandatoryDate(ARRAY, IDX) BCMArrayGetMandatoryObject((ARRAY), (IDX), [NSDate class])
#define BCMArrayGetMandatoryData(ARRAY, IDX) BCMArrayGetMandatoryObject((ARRAY), (IDX), [NSData class])
#define BCMArrayGetMandatoryMutableData(ARRAY, IDX) BCMArrayGetMandatoryObject((ARRAY), (IDX), [NSMutableData class])



#pragma mark Nullable values

//Common Types
#define BCMArrayGetNullableInteger(ARRAY, IDX, NULL_SUBSTITUTE) ({ \
NSNumber *value = BCMArrayGetNullableObject((ARRAY), (IDX), (NULL_SUBSTITUTE), [NSNumber class]); \
[value integerValue]; \
})
#define BCMArrayGetNullableDouble(ARRAY, IDX, NULL_SUBSTITUTE) ({ \
NSNumber *value = BCMArrayGetNullableObject((ARRAY), (IDX), (NULL_SUBSTITUTE), [NSNumber class]); \
[value doubleValue]; \
})
#define BCMArrayGetNullableBoolean(ARRAY, IDX, NULL_SUBSTITUTE) ({ \
NSNumber *value = BCMArrayGetNullableObject((ARRAY), (IDX), (NULL_SUBSTITUTE), [NSNumber class]); \
[value booleanValue]; \
})
#define BCMArrayGetNullableString(ARRAY, IDX, NULL_SUBSTITUTE) BCMArrayGetNullableObject((ARRAY), (IDX), (NULL_SUBSTITUTE), [NSString class])
#define BCMArrayGetNullableDictionary(ARRAY, IDX, NULL_SUBSTITUTE) BCMArrayGetNullableObject((ARRAY), (IDX), (NULL_SUBSTITUTE), [NSDictionary class])
#define BCMArrayGetNullableArray(ARRAY, IDX, NULL_SUBSTITUTE) BCMArrayGetNullableObject((ARRAY), (IDX), (NULL_SUBSTITUTE), [NSArray class])
#define BCMArrayGetNullableMutableString(ARRAY, IDX, NULL_SUBSTITUTE) BCMArrayGetNullableObject((ARRAY), (IDX), (NULL_SUBSTITUTE), [NSMutableString class])
#define BCMArrayGetNullableMutableDictionary(ARRAY, IDX, NULL_SUBSTITUTE) BCMArrayGetNullableObject((ARRAY), (IDX), (NULL_SUBSTITUTE), [NSMutableDictionary class])
#define BCMArrayGetNullableMutableArray(ARRAY, IDX, NULL_SUBSTITUTE) BCMArrayGetNullableObject((ARRAY), (IDX), (NULL_SUBSTITUTE), [NSMutableArray class])
//JSON Types
#define BCMArrayGetNullableNull(ARRAY, IDX) BCMArrayGetNullableObject((ARRAY), (IDX), (NULL_SUBSTITUTE), [NSNull class])
//Property Lists do not support NULL so the concept of nullable values isn't relevant.



#pragma mark - NSDictionary Specific Wrappers

#pragma mark Mandatory values

//Common Types
#define BCMDictionaryGetMandatoryInteger(DICTIONARY, KEY) ({ \
NSNumber *value = BCMDictionaryGetMandatoryObject((DICTIONARY), (KEY), [NSNumber class]); \
[value integerValue]; \
})
#define BCMDictionaryGetMandatoryDouble(DICTIONARY, KEY) ({ \
NSNumber *value = BCMDictionaryGetMandatoryObject((DICTIONARY), (KEY), [NSNumber class]); \
[value doubleValue]; \
})
#define BCMDictionaryGetMandatoryBoolean(DICTIONARY, KEY) ({ \
NSNumber *value = BCMDictionaryGetMandatoryObject((DICTIONARY), (KEY), [NSNumber class]); \
[value booleanValue]; \
})
#define BCMDictionaryGetMandatoryString(DICTIONARY, KEY) BCMDictionaryGetMandatoryObject((DICTIONARY), (KEY), [NSString class])
#define BCMDictionaryGetMandatoryDictionary(DICTIONARY, KEY) BCMDictionaryGetMandatoryObject((DICTIONARY), (KEY), [NSDictionary class])
#define BCMDictionaryGetMandatoryArray(DICTIONARY, KEY) BCMDictionaryGetMandatoryObject((DICTIONARY), (KEY), [NSArray class])
#define BCMDictionaryGetMandatoryMutableString(DICTIONARY, KEY) BCMDictionaryGetMandatoryObject((DICTIONARY), (KEY), [NSMutableString class])
#define BCMDictionaryGetMandatoryMutableDictionary(DICTIONARY, KEY) BCMDictionaryGetMandatoryObject((DICTIONARY), (KEY), [NSMutableDictionary class])
#define BCMDictionaryGetMandatoryMutableArray(DICTIONARY, KEY) BCMDictionaryGetMandatoryObject((DICTIONARY), (KEY), [NSMutableArray class])
//JSON Types
#define BCMDictionaryGetMandatoryNull(DICTIONARY, KEY) BCMDictionaryGetMandatoryObject((DICTIONARY), (KEY), [NSNull class])
//Property List Types (NSDate, NSData, NSMutableData)
#define BCMDictionaryGetMandatoryDate(DICTIONARY, KEY) BCMDictionaryGetMandatoryObject((DICTIONARY), (KEY), [NSDate class])
#define BCMDictionaryGetMandatoryData(DICTIONARY, KEY) BCMDictionaryGetMandatoryObject((DICTIONARY), (KEY), [NSData class])
#define BCMDictionaryGetMandatoryMutableData(DICTIONARY, KEY) BCMDictionaryGetMandatoryObject((DICTIONARY), (KEY), [NSMutableData class])



#pragma mark Nullable values

//Common Types
#define BCMDictionaryGetNullableInteger(DICTIONARY, KEY, NULL_SUBSTITUTE) ({ \
NSNumber *value = BCMDictionaryGetNullableObject((DICTIONARY), (KEY), (NULL_SUBSTITUTE), [NSNumber class]); \
[value integerValue]; \
})
#define BCMDictionaryGetNullableDouble(DICTIONARY, KEY, NULL_SUBSTITUTE) ({ \
NSNumber *value = BCMDictionaryGetNullableObject((DICTIONARY), (KEY), (NULL_SUBSTITUTE), [NSNumber class]); \
[value doubleValue]; \
})
#define BCMDictionaryGetNullableBoolean(DICTIONARY, KEY, NULL_SUBSTITUTE) ({ \
NSNumber *value = BCMDictionaryGetNullableObject((DICTIONARY), (KEY), (NULL_SUBSTITUTE), [NSNumber class]); \
[value booleanValue]; \
})
#define BCMDictionaryGetNullableString(DICTIONARY, KEY, NULL_SUBSTITUTE) BCMDictionaryGetNullableObject((DICTIONARY), (KEY), (NULL_SUBSTITUTE), [NSString class])
#define BCMDictionaryGetNullableDictionary(DICTIONARY, KEY, NULL_SUBSTITUTE) BCMDictionaryGetNullableObject((DICTIONARY), (KEY), (NULL_SUBSTITUTE), [NSDictionary class])
#define BCMDictionaryGetNullableArray(DICTIONARY, KEY, NULL_SUBSTITUTE) BCMDictionaryGetNullableObject((DICTIONARY), (KEY), (NULL_SUBSTITUTE), [NSArray class])
#define BCMDictionaryGetNullableMutableString(DICTIONARY, KEY, NULL_SUBSTITUTE) BCMDictionaryGetNullableObject((DICTIONARY), (KEY), (NULL_SUBSTITUTE), [NSMutableString class])
#define BCMDictionaryGetNullableMutableDictionary(DICTIONARY, KEY, NULL_SUBSTITUTE) BCMDictionaryGetNullableObject((DICTIONARY), (KEY), (NULL_SUBSTITUTE), [NSMutableDictionary class])
#define BCMDictionaryGetNullableMutableArray(DICTIONARY, KEY, NULL_SUBSTITUTE) BCMDictionaryGetNullableObject((DICTIONARY), (KEY), (NULL_SUBSTITUTE), [NSMutableArray class])
//JSON Types
#define BCMDictionaryGetNullableNull(DICTIONARY, KEY, NULL_SUBSTITUTE) BCMDictionaryGetNullableObject((DICTIONARY), (KEY), (NULL_SUBSTITUTE), [NSNull class])
//Property Lists do not support NULL so the concept of nullable values isn't relevant.



#pragma mark Optional values

//Common Types
#define BCMDictionaryGetOptionalInteger(DICTIONARY, KEY, DEFAULT_VALUE) ({ \
NSNumber *value = BCMDictionaryGetOptionalObject((DICTIONARY), (KEY), (DEFAULT_VALUE), [NSNumber class]); \
[value integerValue]; \
})
#define BCMDictionaryGetOptionalDouble(DICTIONARY, KEY, DEFAULT_VALUE) ({ \
NSNumber *value = BCMDictionaryGetOptionalObject((DICTIONARY), (KEY), (DEFAULT_VALUE), [NSNumber class]); \
[value doubleValue]; \
})
#define BCMDictionaryGetOptionalBoolean(DICTIONARY, KEY, DEFAULT_VALUE) ({ \
NSNumber *value = BCMDictionaryGetOptionalObject((DICTIONARY), (KEY), (DEFAULT_VALUE), [NSNumber class]); \
[value booleanValue]; \
})
#define BCMDictionaryGetOptionalString(DICTIONARY, KEY, DEFAULT_VALUE) BCMDictionaryGetOptionalObject((DICTIONARY), (KEY), (DEFAULT_VALUE), [NSString class])
#define BCMDictionaryGetOptionalDictionary(DICTIONARY, KEY, DEFAULT_VALUE) BCMDictionaryGetOptionalObject((DICTIONARY), (KEY), (DEFAULT_VALUE), [NSDictionary class])
#define BCMDictionaryGetOptionalArray(DICTIONARY, KEY, DEFAULT_VALUE) BCMDictionaryGetOptionalObject((DICTIONARY), (KEY), (DEFAULT_VALUE), [NSArray class])
#define BCMDictionaryGetOptionalMutableString(DICTIONARY, KEY, DEFAULT_VALUE) BCMDictionaryGetOptionalObject((DICTIONARY), (KEY), (DEFAULT_VALUE), [NSMutableString class])
#define BCMDictionaryGetOptionalMutableDictionary(DICTIONARY, KEY, DEFAULT_VALUE) BCMDictionaryGetOptionalObject((DICTIONARY), (KEY), (DEFAULT_VALUE), [NSMutableDictionary class])
#define BCMDictionaryGetOptionalMutableArray(DICTIONARY, KEY, DEFAULT_VALUE) BCMDictionaryGetOptionalObject((DICTIONARY), (KEY), (DEFAULT_VALUE), [NSMutableArray class])
//JSON Types
#define BCMDictionaryGetOptionalNull(DICTIONARY, KEY, DEFAULT_VALUE) BCMDictionaryGetOptionalObject((DICTIONARY), (KEY), (DEFAULT_VALUE), [NSNull class])
//Property List Types (NSDate, NSData, NSMutableData)
#define BCMDictionaryGetOptionalDate(DICTIONARY, KEY, DEFAULT_VALUE) BCMDictionaryGetOptionalObject((DICTIONARY), (KEY), (DEFAULT_VALUE), [NSDate class])
#define BCMDictionaryGetOptionalData(DICTIONARY, KEY, DEFAULT_VALUE) BCMDictionaryGetOptionalObject((DICTIONARY), (KEY), (DEFAULT_VALUE), [NData class])
#define BCMDictionaryGetOptionalMutableData(DICTIONARY, KEY, DEFAULT_VALUE) BCMDictionaryGetOptionalObject((DICTIONARY), (KEY), (DEFAULT_VALUE), [NSMutableData class])



#endif
