//
//  BCJError.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 08/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BCJSource;
@class BCJTarget;



@interface BCJError : NSError

#pragma mark - Invalid compile time input
+(NSError *)invalidJSONPathErrorWithInvalidJSONPath:(NSString *)JSONPath errorPosition:(NSUInteger)position;

#pragma mark - Missing data
+(NSError *)missingSourceValueErrorWithSource:(BCJSource *)source JSONPathComponent:(NSString *)component componentIndex:(NSUInteger)componentIndex;
+(NSError *)missingKeyForEnumMappingErrorWithJSONSource:(BCJSource *)source enumMapping:(NSDictionary *)enumMapping key:(id)enumKey;

#pragma mark - Unexpected data/value (wrong type or value)
//Invalid value errors
+(NSError *)invalidJSONDataErrorWithData:(NSData *)data;
+(NSError *)invalidValueErrorWithJSONSource:(BCJSource *)source value:(id)value criteria:(NSString *)criteria;
//Value type errors
+(NSError *)unexpectedTypeErrorWithSource:(BCJSource *)source value:(id)value expectedClass:(Class)expectedClass;
//Collection type errors
+(NSError *)unexpectedKeyTypeErrorWithKey:(id)key expectedKeyClass:(Class)expectedKeyClass;
+(NSError *)unexpectedElementTypeErrorWithElement:(id)element subscript:(id)subscript expectedElementClass:(Class)expectedElementClass;

#pragma mark - Failed blocks errors
+(NSError *)elementMappingErrorWithElement:(id)element subscript:(id)subscript underlyingError:(NSError *)underlyingError;
+(NSError *)unknownErrorWithDescription:(NSString *)description;

@end



#pragma mark - Expectations
#define BCJParameterExpectation(CONDITION) do { if (! (CONDITION)) {\
    NSString *reason = [NSString stringWithFormat:@"Argument failed to meet condition '%@' on line %@ of file %@.", @#CONDITION, @(__LINE__), @(__FILE__)]; \
    [[NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil] raise];\
} } while (NO)



#define BCJExpectation(CONDITION, FORMAT...) do { if (! (CONDITION)) {\
    NSString *expectation = [NSString stringWithFormat:FORMAT ];\
    NSString *reason = [NSString stringWithFormat:@"Failed to meet expection '%@' on line %@ of file %@.", expectation, @(__LINE__), @(__FILE__)]; \
    [[NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil] raise];\
} } while (NO)





#pragma mark - Warnings
void BCJWarnIfPossibleToSetScalarPropertyToNil(BCJSource *source, BCJTarget *target);
