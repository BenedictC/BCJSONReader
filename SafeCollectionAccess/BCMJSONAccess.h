//
//  BCMJSONAccess.h
//  BCLTypeCheckedCollectionAccessors
//
//  Created by Benedict Cohen on 24/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#ifndef BCMJSONAccess_h
#define BCMJSONAccess_h

#import "AttemptSalvage.h"
#import "BCLTypeCheckedCollectionAccessors.h"



/**
 BCPSafeCollectionAccess provides a macros to access collections in a type safe manner and provides a control flow
 for handling errors.

 */

#pragma mark - Constants

static NSString * const BCPErrorsKey = @"BCPErrorsKey";
static NSString * const BCPShouldAbandonOnErrorKey = @"BCPShouldAbandonOnErrorKey";



#pragma mark - Control Flow
/**
 <#Description#>

 @param ABANDON_ON_ERROR <#ABANDON_ON_ERROR description#>

 @return <#return value description#>
 */
#define BCPSetAbandonOnError(ABANDON_ON_ERROR) \
do { \
    BOOL shouldAbandon = ABANDON_ON_ERROR; \
    SET_FAILURE_INFO(BCPShouldAbandonOnErrorKey, @(shouldAbandon)); \
} while(0)


/**
 <#Description#>

 @param ERROR <#ERROR_TYPE description#>

 @return <#return value description#>
 */
#define BCPHandleError(ERROR) do { \
/* Fetch/create the errors array and store the error. */ \
NSMutableArray *errors = FAILURE_INFO(BCPErrorsKey); \
if (errors == nil) { \
errors = [NSMutableArray new]; \
SET_FAILURE_INFO(BCPErrorsKey, errors); \
} \
NSError *err = (ERROR); \
if (err != nil) [errors addObject:err]; \
/* Jump ship? */ \
BOOL shouldAbandon = [FAILURE_INFO(BCPShouldAbandonOnErrorKey) boolValue];\
if (shouldAbandon) ABANDON(); \
} while(0)



#pragma mark - BCL* Function Wrappers

#define BCPIsKindOfClass(OBJECT, CLASS) ({ \
    NSError *error = BCLIsKindOfClass((OBJECT), (CLASS)); \
    BOOL success = error == nil; \
    if (!success) BCPHandleError(error); \
    success; \
})



#define BCPArrayGetMandatoryObject(OBJECT, IDX, CLASS) ({ \
    id result; \
    NSError *error = BCLArrayGetMandatoryObject((OBJECT), (IDX), (CLASS), &result); \
    if (error != nil) BCPHandleError(error); \
    result; \
})



#define BCPArrayGetNullableObject(OBJECT, IDX, NULL_SUB, CLASS) ({ \
    id result; \
    NSError *error = BCLArrayGetNullableObject((OBJECT), (IDX), (CLASS), (NULL_SUB), &result); \
    if (error != nil) BCPHandleError(error); \
    result; \
})



#define BCPDictionaryGetMandatoryObject(OBJECT, KEY, CLASS) ({ \
    id result; \
    NSError *error = BCLDictionaryGetMandatoryObject((OBJECT), (KEY), (CLASS), &result); \
    if (error != nil) BCPHandleError(error); \
    result; \
})



#define BCPDictionaryGetNullableObject(OBJECT, KEY, NULL_SUB, CLASS) ({ \
    id result; \
    NSError *error =  BCLDictionaryGetNullableObject((OBJECT), (KEY), (CLASS), (NULL_SUB), &result); \
    if (error != nil) BCPHandleError(error); \
    result; \
})



#define BCPDictionaryGetOptionalObject(OBJECT, KEY, DEFAULT_VALUE, CLASS) ({ \
    id result; \
    NSError *error = BCLDictionaryGetOptionalObject((OBJECT), (KEY), (CLASS), (DEFAULT_VALUE), &result); \
    if (error != nil) BCPHandleError(error); \
    result; \
})



#pragma mark - Type Checking Wrappers

//Common Types
#define BCPIsNumber(OBJECT) BCPIsKindOfClass((OBJECT), [NSNumber class])
#define BCPIsArray(OBJECT)  BCPIsKindOfClass((OBJECT), [NSArray class])
#define BCPIsMutableArray(OBJECT) BCPIsKindOfClass((OBJECT), [NSMutableArray class])
#define BCPIsDictionary(OBJECT) BCPIsKindOfClass((OBJECT), [NSDictionary class])
#define BCPIsMutableDictionary(OBJECT) BCPIsKindOfClass((OBJECT), [NSMutableDictionary class])
#define BCPIsString(OBJECT) BCPIsKindOfClass((OBJECT), [NSString class])
#define BCPIsMutableString(OBJECT) BCPIsKindOfClass((OBJECT), [NSMutableString class])
//JSON Types
#define BCPIsNull(OBJECT) BCPIsKindOfClass((OBJECT), [NSNull class])
//Property List Types
#define BCPIsDate(OBJECT) BCPIsKindOfClass((OBJECT), [NSDate class])
#define BCPIsData(OBJECT) BCPIsKindOfClass((OBJECT), [NSData class])
#define BCPIsMutableData(OBJECT) BCPIsKindOfClass((OBJECT), [NSMutableData class])



#pragma mark - NSArray Specific Wrappers

#pragma mark Mandatory values

//Common Types
#define BCPArrayGetMandatoryInteger(ARRAY, IDX) ({ \
    NSNumber *value = BCPArrayGetMandatoryObject((ARRAY), (IDX), [NSNumber class]); \
    [value integerValue]; \
})

#define BCPArrayGetMandatoryDouble(ARRAY, IDX) ({ \
    NSNumber *value = BCPArrayGetMandatoryObject((ARRAY), (IDX), [NSNumber class]); \
    [value doubleValue]; \
})

#define BCPArrayGetMandatoryBoolean(ARRAY, IDX) ({ \
    NSNumber *value = BCPArrayGetMandatoryObject((ARRAY), (IDX), [NSNumber class]); \
    [value booleanValue]; \
})

#define BCPArrayGetMandatoryString(ARRAY, IDX) BCPArrayGetMandatoryObject((ARRAY), (IDX), [NSString class])
#define BCPArrayGetMandatoryDictionary(ARRAY, IDX) BCPArrayGetMandatoryObject((ARRAY), (IDX), [NSDictionary class])
#define BCPArrayGetMandatoryArray(ARRAY, IDX) BCPArrayGetMandatoryObject((ARRAY), (IDX), [NSArray class])
#define BCPArrayGetMandatoryMutableString(ARRAY, IDX) BCPArrayGetMandatoryObject((ARRAY), (IDX), [NSMutableString class])
#define BCPArrayGetMandatoryMutableDictionary(ARRAY, IDX) BCPArrayGetMandatoryObject((ARRAY), (IDX), [NSMutableDictionary class])
#define BCPArrayGetMandatoryMutableArray(ARRAY, IDX) BCPArrayGetMandatoryObject((ARRAY), (IDX), [NSMutableArray class])
//JSON Types
#define BCPArrayGetMandatoryNull(ARRAY, IDX) BCPArrayGetMandatoryObject((ARRAY), (IDX), [NSNull class])
//Property List Types
#define BCPArrayGetMandatoryDate(ARRAY, IDX) BCPArrayGetMandatoryObject((ARRAY), (IDX), [NSDate class])
#define BCPArrayGetMandatoryData(ARRAY, IDX) BCPArrayGetMandatoryObject((ARRAY), (IDX), [NSData class])
#define BCPArrayGetMandatoryMutableData(ARRAY, IDX) BCPArrayGetMandatoryObject((ARRAY), (IDX), [NSMutableData class])



#pragma mark Nullable values

//Common Types
#define BCPArrayGetNullableInteger(ARRAY, IDX, NULL_SUBSTITUTE) ({ \
    NSNumber *value = BCPArrayGetNullableObject((ARRAY), (IDX), (NULL_SUBSTITUTE), [NSNumber class]); \
    [value integerValue]; \
})

#define BCPArrayGetNullableDouble(ARRAY, IDX, NULL_SUBSTITUTE) ({ \
    NSNumber *value = BCPArrayGetNullableObject((ARRAY), (IDX), (NULL_SUBSTITUTE), [NSNumber class]); \
    [value doubleValue]; \
})

#define BCPArrayGetNullableBoolean(ARRAY, IDX, NULL_SUBSTITUTE) ({ \
    NSNumber *value = BCPArrayGetNullableObject((ARRAY), (IDX), (NULL_SUBSTITUTE), [NSNumber class]); \
    [value booleanValue]; \
})

#define BCPArrayGetNullableString(ARRAY, IDX, NULL_SUBSTITUTE) BCPArrayGetNullableObject((ARRAY), (IDX), (NULL_SUBSTITUTE), [NSString class])
#define BCPArrayGetNullableDictionary(ARRAY, IDX, NULL_SUBSTITUTE) BCPArrayGetNullableObject((ARRAY), (IDX), (NULL_SUBSTITUTE), [NSDictionary class])
#define BCPArrayGetNullableArray(ARRAY, IDX, NULL_SUBSTITUTE) BCPArrayGetNullableObject((ARRAY), (IDX), (NULL_SUBSTITUTE), [NSArray class])
#define BCPArrayGetNullableMutableString(ARRAY, IDX, NULL_SUBSTITUTE) BCPArrayGetNullableObject((ARRAY), (IDX), (NULL_SUBSTITUTE), [NSMutableString class])
#define BCPArrayGetNullableMutableDictionary(ARRAY, IDX, NULL_SUBSTITUTE) BCPArrayGetNullableObject((ARRAY), (IDX), (NULL_SUBSTITUTE), [NSMutableDictionary class])
#define BCPArrayGetNullableMutableArray(ARRAY, IDX, NULL_SUBSTITUTE) BCPArrayGetNullableObject((ARRAY), (IDX), (NULL_SUBSTITUTE), [NSMutableArray class])
//JSON Types
#define BCPArrayGetNullableNull(ARRAY, IDX) BCPArrayGetNullableObject((ARRAY), (IDX), (NULL_SUBSTITUTE), [NSNull class])
//Property Lists do not support NULL so the concept of nullable values isn't relevant.



#pragma mark - NSDictionary Specific Wrappers

#pragma mark Mandatory values

//Common Types
#define BCPDictionaryGetMandatoryInteger(DICTIONARY, KEY) ({ \
    NSNumber *value = BCPDictionaryGetMandatoryObject((DICTIONARY), (KEY), [NSNumber class]); \
    [value integerValue]; \
})

#define BCPDictionaryGetMandatoryDouble(DICTIONARY, KEY) ({ \
    NSNumber *value = BCPDictionaryGetMandatoryObject((DICTIONARY), (KEY), [NSNumber class]); \
    [value doubleValue]; \
})

#define BCPDictionaryGetMandatoryBoolean(DICTIONARY, KEY) ({ \
    NSNumber *value = BCPDictionaryGetMandatoryObject((DICTIONARY), (KEY), [NSNumber class]); \
    [value booleanValue]; \
})

#define BCPDictionaryGetMandatoryString(DICTIONARY, KEY) BCPDictionaryGetMandatoryObject((DICTIONARY), (KEY), [NSString class])
#define BCPDictionaryGetMandatoryDictionary(DICTIONARY, KEY) BCPDictionaryGetMandatoryObject((DICTIONARY), (KEY), [NSDictionary class])
#define BCPDictionaryGetMandatoryArray(DICTIONARY, KEY) BCPDictionaryGetMandatoryObject((DICTIONARY), (KEY), [NSArray class])
#define BCPDictionaryGetMandatoryMutableString(DICTIONARY, KEY) BCPDictionaryGetMandatoryObject((DICTIONARY), (KEY), [NSMutableString class])
#define BCPDictionaryGetMandatoryMutableDictionary(DICTIONARY, KEY) BCPDictionaryGetMandatoryObject((DICTIONARY), (KEY), [NSMutableDictionary class])
#define BCPDictionaryGetMandatoryMutableArray(DICTIONARY, KEY) BCPDictionaryGetMandatoryObject((DICTIONARY), (KEY), [NSMutableArray class])
//JSON Types
#define BCPDictionaryGetMandatoryNull(DICTIONARY, KEY) BCPDictionaryGetMandatoryObject((DICTIONARY), (KEY), [NSNull class])
//Property List Types (NSDate, NSData, NSMutableData)
#define BCPDictionaryGetMandatoryDate(DICTIONARY, KEY) BCPDictionaryGetMandatoryObject((DICTIONARY), (KEY), [NSDate class])
#define BCPDictionaryGetMandatoryData(DICTIONARY, KEY) BCPDictionaryGetMandatoryObject((DICTIONARY), (KEY), [NSData class])
#define BCPDictionaryGetMandatoryMutableData(DICTIONARY, KEY) BCPDictionaryGetMandatoryObject((DICTIONARY), (KEY), [NSMutableData class])



#pragma mark Nullable values

//Common Types
#define BCPDictionaryGetNullableInteger(DICTIONARY, KEY, NULL_SUBSTITUTE) ({ \
    NSNumber *value = BCPDictionaryGetNullableObject((DICTIONARY), (KEY), (NULL_SUBSTITUTE), [NSNumber class]); \
    [value integerValue]; \
})

#define BCPDictionaryGetNullableDouble(DICTIONARY, KEY, NULL_SUBSTITUTE) ({ \
    NSNumber *value = BCPDictionaryGetNullableObject((DICTIONARY), (KEY), (NULL_SUBSTITUTE), [NSNumber class]); \
    [value doubleValue]; \
})

#define BCPDictionaryGetNullableBoolean(DICTIONARY, KEY, NULL_SUBSTITUTE) ({ \
    NSNumber *value = BCPDictionaryGetNullableObject((DICTIONARY), (KEY), (NULL_SUBSTITUTE), [NSNumber class]); \
    [value booleanValue]; \
})

#define BCPDictionaryGetNullableString(DICTIONARY, KEY, NULL_SUBSTITUTE) BCPDictionaryGetNullableObject((DICTIONARY), (KEY), (NULL_SUBSTITUTE), [NSString class])
#define BCPDictionaryGetNullableDictionary(DICTIONARY, KEY, NULL_SUBSTITUTE) BCPDictionaryGetNullableObject((DICTIONARY), (KEY), (NULL_SUBSTITUTE), [NSDictionary class])
#define BCPDictionaryGetNullableArray(DICTIONARY, KEY, NULL_SUBSTITUTE) BCPDictionaryGetNullableObject((DICTIONARY), (KEY), (NULL_SUBSTITUTE), [NSArray class])
#define BCPDictionaryGetNullableMutableString(DICTIONARY, KEY, NULL_SUBSTITUTE) BCPDictionaryGetNullableObject((DICTIONARY), (KEY), (NULL_SUBSTITUTE), [NSMutableString class])
#define BCPDictionaryGetNullableMutableDictionary(DICTIONARY, KEY, NULL_SUBSTITUTE) BCPDictionaryGetNullableObject((DICTIONARY), (KEY), (NULL_SUBSTITUTE), [NSMutableDictionary class])
#define BCPDictionaryGetNullableMutableArray(DICTIONARY, KEY, NULL_SUBSTITUTE) BCPDictionaryGetNullableObject((DICTIONARY), (KEY), (NULL_SUBSTITUTE), [NSMutableArray class])
//JSON Types
#define BCPDictionaryGetNullableNull(DICTIONARY, KEY, NULL_SUBSTITUTE) BCPDictionaryGetNullableObject((DICTIONARY), (KEY), (NULL_SUBSTITUTE), [NSNull class])
//Property Lists do not support NULL so the concept of nullable values isn't relevant.



#pragma mark Optional values

//Common Types
#define BCPDictionaryGetOptionalInteger(DICTIONARY, KEY, DEFAULT_VALUE) ({ \
    NSNumber *value = BCPDictionaryGetOptionalObject((DICTIONARY), (KEY), (DEFAULT_VALUE), [NSNumber class]); \
    [value integerValue]; \
})

#define BCPDictionaryGetOptionalDouble(DICTIONARY, KEY, DEFAULT_VALUE) ({ \
    NSNumber *value = BCPDictionaryGetOptionalObject((DICTIONARY), (KEY), (DEFAULT_VALUE), [NSNumber class]); \
    [value doubleValue]; \
})

#define BCPDictionaryGetOptionalBoolean(DICTIONARY, KEY, DEFAULT_VALUE) ({ \
    NSNumber *value = BCPDictionaryGetOptionalObject((DICTIONARY), (KEY), (DEFAULT_VALUE), [NSNumber class]); \
    [value booleanValue]; \
})

#define BCPDictionaryGetOptionalString(DICTIONARY, KEY, DEFAULT_VALUE) BCPDictionaryGetOptionalObject((DICTIONARY), (KEY), (DEFAULT_VALUE), [NSString class])
#define BCPDictionaryGetOptionalDictionary(DICTIONARY, KEY, DEFAULT_VALUE) BCPDictionaryGetOptionalObject((DICTIONARY), (KEY), (DEFAULT_VALUE), [NSDictionary class])
#define BCPDictionaryGetOptionalArray(DICTIONARY, KEY, DEFAULT_VALUE) BCPDictionaryGetOptionalObject((DICTIONARY), (KEY), (DEFAULT_VALUE), [NSArray class])
#define BCPDictionaryGetOptionalMutableString(DICTIONARY, KEY, DEFAULT_VALUE) BCPDictionaryGetOptionalObject((DICTIONARY), (KEY), (DEFAULT_VALUE), [NSMutableString class])
#define BCPDictionaryGetOptionalMutableDictionary(DICTIONARY, KEY, DEFAULT_VALUE) BCPDictionaryGetOptionalObject((DICTIONARY), (KEY), (DEFAULT_VALUE), [NSMutableDictionary class])
#define BCPDictionaryGetOptionalMutableArray(DICTIONARY, KEY, DEFAULT_VALUE) BCPDictionaryGetOptionalObject((DICTIONARY), (KEY), (DEFAULT_VALUE), [NSMutableArray class])
//JSON Types
#define BCPDictionaryGetOptionalNull(DICTIONARY, KEY, DEFAULT_VALUE) BCPDictionaryGetOptionalObject((DICTIONARY), (KEY), (DEFAULT_VALUE), [NSNull class])
//Property List Types (NSDate, NSData, NSMutableData)
#define BCPDictionaryGetOptionalDate(DICTIONARY, KEY, DEFAULT_VALUE) BCPDictionaryGetOptionalObject((DICTIONARY), (KEY), (DEFAULT_VALUE), [NSDate class])
#define BCPDictionaryGetOptionalData(DICTIONARY, KEY, DEFAULT_VALUE) BCPDictionaryGetOptionalObject((DICTIONARY), (KEY), (DEFAULT_VALUE), [NData class])
#define BCPDictionaryGetOptionalMutableData(DICTIONARY, KEY, DEFAULT_VALUE) BCPDictionaryGetOptionalObject((DICTIONARY), (KEY), (DEFAULT_VALUE), [NSMutableData class])



#endif
