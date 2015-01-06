//
//  BCJError.h
//  BCJSONReader
//
//  Created by Benedict Cohen on 08/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface BCJError : NSError

#pragma mark - Invalid compile time input
+(NSError *)invalidJSONPathErrorWithInvalidJSONPath:(NSString *)JSONPath errorPosition:(NSUInteger)position;

#pragma mark - Missing data
+(NSError *)missingSourceValueErrorWithJSONPath:(NSString *)JSONPath JSONPathComponent:(NSString *)component componentIndex:(NSUInteger)componentIndex;
+(NSError *)missingKeyForEnumMappingErrorWithJSONPath:(NSString *)JSONPath enumMapping:(NSDictionary *)enumMapping key:(id)enumKey;

#pragma mark - Unexpected data/value (wrong type or value)
//Invalid value errors
+(NSError *)invalidJSONDataErrorWithData:(NSData *)data;
+(NSError *)invalidValueErrorWithJSONPath:(NSString *)JSONPath value:(id)value criteria:(NSString *)criteria;
//Value type errors
+(NSError *)unexpectedTypeErrorWithJSONPath:(NSString *)JSONPath value:(id)value expectedClass:(Class)expectedClass;
//Collection type errors
+(NSError *)unexpectedKeyTypeErrorWithKey:(id)key expectedKeyClass:(Class)expectedKeyClass;
+(NSError *)unexpectedElementTypeErrorWithElement:(id)element subscript:(id)subscript expectedElementClass:(Class)expectedElementClass;

+(NSError *)errorWithUnderlyingErrors:(NSArray *)underlyingErrors;

#pragma mark - Failed mapping errors
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
