//
//  BCJError.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 08/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJError.h"
#import "BCJConstants.h"
#import "BCJSource.h"
#import "BCJLogging.h"



@implementation BCJError

+(NSError *)missingSourceValueErrorWithSource:(BCJSource *)source JSONPathComponent:(NSString *)component componentIndex:(NSUInteger)componentIndex
{
    NSString *format = NSLocalizedString(@"Could not fetch object for component %lu (%@) of JSONPath %@.", nil);
    NSString *description = [NSString stringWithFormat:format, (long unsigned)componentIndex, component, source.JSONPath];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
    if (source != nil) userInfo[BCJSourceErrorKey] = source;

    return [NSError errorWithDomain:BCJErrorDomain code:BCJMissingSourceValueError userInfo:userInfo];
}



+(NSError *)unexpectedTypeErrorWithSource:(BCJSource *)source value:(id)value expectedClass:(Class)expectedClass
{
    NSString *format = NSLocalizedString(@"The value for JSONPath %@ is of type %@ but is expected to be of type %@.", nil);
    NSString *description = [NSString stringWithFormat:format, source.JSONPath, NSStringFromClass([value class]), NSStringFromClass(expectedClass)];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
    if (source != nil) userInfo[BCJSourceErrorKey] = source;

    return [NSError errorWithDomain:BCJErrorDomain code:BCJUnexpectedTypeError userInfo:userInfo];
}



+(NSError *)missingKeyForEnumMappingErrorWithJSONSource:(BCJSource *)source enumMapping:(NSDictionary *)enumMapping key:(id)enumKey
{
    NSString *format = NSLocalizedString(@"EnumMapping does not contain key <%@>.", nil);
    NSString *description = [NSString stringWithFormat:format, enumKey];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
    if (source != nil) userInfo[BCJSourceErrorKey] = source;
    if (enumMapping != nil) userInfo[BCJEnumMappingErrorKey] = enumMapping;

    return [NSError errorWithDomain:BCJErrorDomain code:BCJMissingKeyForEnumMappingError userInfo:userInfo];
}



+(NSError *)unexpectedElementTypeErrorWithElement:(id)element subscript:(id)subscript expectedElementClass:(Class)expectedElementClass
{
    NSString *format = NSLocalizedString(@"The element for subscript %@ is of type %@ but is expected to be of type %@.", nil);
    NSString *description = [NSString stringWithFormat:format, subscript, NSStringFromClass([element class]), NSStringFromClass(expectedElementClass)];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];

    return [NSError errorWithDomain:BCJErrorDomain code:BCJUnexpectedElementTypeError userInfo:userInfo];
}



+(NSError *)unexpectedKeyTypeErrorWithKey:(id)key expectedKeyClass:(Class)expectedKeyClass
{
    NSString *format = NSLocalizedString(@"key is of type %@ but is expected to be of type %@.", nil);
    NSString *description = [NSString stringWithFormat:format, NSStringFromClass([key class]), NSStringFromClass(expectedKeyClass)];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];

    return [NSError errorWithDomain:BCJErrorDomain code:BCJUnexpectedKeyTypeError userInfo:userInfo];
}



+(NSError *)elementMappingErrorWithElement:(id)element subscript:(id)subscript underlyingError:(NSError *)underlyingError
{
    NSString *format = NSLocalizedString(@"Error while mapping element for subscript %@.", nil);
    NSString *description = [NSString stringWithFormat:format, subscript];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
    if (underlyingError != nil) userInfo[BCJUnderlyingErrorKey] = underlyingError;

    return [NSError errorWithDomain:BCJErrorDomain code:BCJElementMappingError userInfo:userInfo];
}



+(NSError *)invalidValueErrorWithJSONSource:(BCJSource *)source value:(id)value criteria:(NSString *)criteria
{
    NSString *format = NSLocalizedString(@"The value for JSONPath %@ does not match the criteria '%@'.", nil);
    NSString *description = [NSString stringWithFormat:format, source.JSONPath, criteria];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
    if (source != nil) userInfo[BCJSourceErrorKey] = source;

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



+(NSError *)unknownErrorWithDescription:(NSString *)description
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];

    return [NSError errorWithDomain:BCJErrorDomain code:BCJInvalidJSONDataError userInfo:userInfo];
}

@end



void BCJWarnIfPossibleToSetScalarPropertyToNil(BCJSource *source, BCJTarget *target)
{
    BCJSourceOptions options = source.options;
    BOOL pathMustEvaluateToValue = (options & BCJSourceOptionPathMustEvaluateToValue) != 0;
    BOOL treatValueNotFoundAsSuccess = (options & BCJSourceOptionTreatValueNotFoundAsSuccess) != 0;
    BOOL replaceNullWithNil = (options & BCJSourceOptionReplaceNullWithNil) != 0;

    BOOL canReturnNil = (source.defaultValue == nil) && ((pathMustEvaluateToValue && replaceNullWithNil) || (treatValueNotFoundAsSuccess));
    if (!canReturnNil) return;

    BCJLog(@"Source <%@> may return nil which may be incompatible with target <%@> which resolves to a scalar value. This can be fixed by providing a defaultValue to the source.", source, target);
}


