//
//  BCJError.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 08/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJError.h"
#import "BCJConstants.h"
#import "BCJJSONSource.h"



@implementation BCJError

+(NSError *)missingValueErrorWithJSONSource:(BCJJSONSource *)source component:(NSString *)component componentIndex:(NSUInteger)componentIndex
{
    NSString *format = NSLocalizedString(@"Could not fetch object for component %lu (%@) of JSONPath %@.", nil);
    NSString *description = [NSString stringWithFormat:format, (long unsigned)componentIndex, component, source.JSONPath];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
    if (source != nil) userInfo[BCJJSONSourceErrorKey] = source;

    return [NSError errorWithDomain:BCJErrorDomain code:BCJMissingValueError userInfo:userInfo];
}



+(NSError *)unexpectedTypeErrorWithJSONSource:(BCJJSONSource *)source value:(id)value expectedClass:(Class)expectedClass
{
    NSString *format = NSLocalizedString(@"The value for JSONPath %@ is of type %@ but is expected to be of type %@.", nil);
    NSString *description = [NSString stringWithFormat:format, source.JSONPath, NSStringFromClass([value class]), NSStringFromClass(expectedClass)];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
    if (source != nil) userInfo[BCJJSONSourceErrorKey] = source;

    return [NSError errorWithDomain:BCJErrorDomain code:BCJUnexpectedTypeError userInfo:userInfo];
}



+(NSError *)unknownKeyForEnumMappingErrorWithJSONSource:(BCJJSONSource *)source enumMapping:(NSDictionary *)enumMapping key:(id)enumKey
{
    NSString *format = NSLocalizedString(@"EnumMapping does not contain key <%@>.", nil);
    NSString *description = [NSString stringWithFormat:format, enumKey];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
    if (source != nil) userInfo[BCJJSONSourceErrorKey] = source;
    if (enumMapping != nil) userInfo[BCJEnumMappingErrorKey] = enumMapping;

    return [NSError errorWithDomain:BCJErrorDomain code:BCJUnknownEnumMappingKeyError userInfo:userInfo];
}



+(NSError *)unexpectedElementTypeErrorWithElement:(id)element subscript:(id)subscript expectedElementClass:(Class)expectedElementClass
{
    NSString *format = NSLocalizedString(@"The element for subscript %@ is of type %@ but is expected to be of type %@.", nil);
    NSString *description = [NSString stringWithFormat:format, subscript, NSStringFromClass([element class]), NSStringFromClass(expectedElementClass)];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];

    return [NSError errorWithDomain:BCJErrorDomain code:BCJUnexpectedElementTypeError userInfo:userInfo];
}



+(NSError *)mappingErrorWithElement:(id)element subscript:(id)subscript underlyingError:(NSError *)underlyingError
{
    NSString *format = NSLocalizedString(@"Error while mapping elemeny for subscript %@.", nil);
    NSString *description = [NSString stringWithFormat:format, subscript];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
    if (underlyingError != nil) userInfo[BCJUnderlyingErrorKey] = underlyingError;

    return [NSError errorWithDomain:BCJErrorDomain code:BCJElementMappingError userInfo:userInfo];
}



+(NSError *)invalidValueErrorWithJSONSource:(BCJJSONSource *)source value:(id)value criteria:(NSString *)criteria
{
    NSString *format = NSLocalizedString(@"The value for JSONPath %@ does not match the criteria '%@'.", nil);
    NSString *description = [NSString stringWithFormat:format, source.JSONPath, criteria];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
    if (source != nil) userInfo[BCJJSONSourceErrorKey] = source;

    return [NSError errorWithDomain:BCJErrorDomain code:BCJInvalidValueError userInfo:userInfo];
}



+(NSError *)invalidJSONPathErrorWithInvalidJSONPath:(NSString *)JSONPath errorPosition:(NSUInteger)position
{
    NSString *format = NSLocalizedString(@"The string %@ is not a valid JSONPath. Error at position %i.", nil);
    NSString *description = [NSString stringWithFormat:format, JSONPath, (unsigned long)position];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
    userInfo[BCJInvalidJSONPathFailurePositionErrorKey] = @(position);

    return [NSError errorWithDomain:BCJErrorDomain code:BCJInvalidJSONPathError userInfo:userInfo];
}



+(NSError *)invalidJSONDataErrorWithData:(NSData *)data
{
    NSString *format = NSLocalizedString(@"The data does not contain valid JSON data.", nil);
    NSString *description = [NSString stringWithFormat:format, nil];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
    if (data != nil) userInfo[BCJInvalidJSONDataErrorKey] = data;

    return [NSError errorWithDomain:BCJErrorDomain code:BCJInvalidJSONDataError userInfo:userInfo];
}

@end
