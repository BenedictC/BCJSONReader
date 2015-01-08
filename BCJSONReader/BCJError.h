//
//  BCJError.h
//  BCJSONReader
//
//  Created by Benedict Cohen on 08/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface BCJError : NSError

+(NSError *)invalidSourceDataErrorWithData:(NSData *)data expectedDataFormatName:(NSString *)dataFormatName underlyingError:(NSError *)underlyingError;

+(NSError *)invalidJSONPathErrorWithJSONPath:(NSString *)JSONPath errorPosition:(NSUInteger)position;

+(NSError *)valueNotFoundErrorWithJSONPath:(NSString *)JSONPath JSONPathComponent:(NSString *)component componentIndex:(NSUInteger)componentIndex;

+(NSError *)unexpectedTypeErrorWithJSONPath:(NSString *)JSONPath value:(id)value expectedClass:(Class)expectedClass;

+(NSError *)missingEnumMappingKeyErrorWithJSONPath:(NSString *)JSONPath enumMapping:(NSDictionary *)enumMapping key:(id)enumKey;

+(NSError *)invalidValueErrorWithJSONPath:(NSString *)JSONPath value:(id)value criteria:(NSString *)criteria;

+(NSError *)collectionMappingErrorWithJSONPath:(NSString *)JSONPath elementSubscript:(id)subscript elementError:(NSError *)elementError;

+(NSError *)multipleErrorsErrorWithErrors:(NSArray *)errors;

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
