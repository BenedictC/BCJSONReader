//
//  BCJError.m
//  BCJSONReader
//
//  Created by Benedict Cohen on 08/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJError.h"
#import "BCJConstants.h"



@implementation BCJError

+(NSError *)invalidJSONDataErrorWithData:(NSData *)data underlyingError:(NSError *)underlyingError
{
    NSString *format = NSLocalizedString(@"The data does not contain valid JSON data.", nil);
    NSString *description = [NSString stringWithFormat:format, nil];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
    if (data != nil) userInfo[BCJInvalidJSONDataErrorKey] = data;
    if (underlyingError) userInfo[NSUnderlyingErrorKey] = underlyingError;

    return [NSError errorWithDomain:BCJErrorDomain code:BCJInvalidJSONDataError userInfo:userInfo];
}



+(NSError *)invalidJSONPathErrorWithJSONPath:(NSString *)JSONPath errorPosition:(NSUInteger)position
{
    NSString *format = NSLocalizedString(@"The string %@ is not a valid JSONPath. Error at position %i.", nil);
    NSString *description = [NSString stringWithFormat:format, JSONPath, (unsigned long)position];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
    userInfo[BCJInvalidJSONPathFailurePositionErrorKey] = @(position);

    return [NSError errorWithDomain:BCJErrorDomain code:BCJInvalidJSONPathError userInfo:userInfo];
}



+(NSError *)valueNotFoundErrorWithJSONPath:(NSString *)JSONPath JSONPathComponent:(NSString *)component componentIndex:(NSUInteger)componentIndex
{
    NSString *format = NSLocalizedString(@"Could not fetch object for component %lu (%@) of JSONPath %@.", nil);
    NSString *description = [NSString stringWithFormat:format, (long unsigned)componentIndex, component, JSONPath];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];

    return [NSError errorWithDomain:BCJErrorDomain code:BCJValueNotFoundError userInfo:userInfo];
}



+(NSError *)unexpectedTypeErrorWithJSONPath:(NSString *)JSONPath value:(id)value expectedClass:(Class)expectedClass
{
    NSString *format = NSLocalizedString(@"The value for JSONPath %@ is of type %@ but is expected to be of type %@.", nil);
    NSString *description = [NSString stringWithFormat:format, JSONPath, NSStringFromClass([value class]), NSStringFromClass(expectedClass)];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];

    return [NSError errorWithDomain:BCJErrorDomain code:BCJUnexpectedTypeError userInfo:userInfo];
}



+(NSError *)missingEnumMappingKeyErrorWithJSONPath:(NSString *)JSONPath enumMapping:(NSDictionary *)enumMapping key:(id)enumKey
{
    NSString *format = NSLocalizedString(@"EnumMapping at JSONPath %@ does not contain key <%@>.", nil);
    NSString *description = [NSString stringWithFormat:format, JSONPath, enumKey];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
    if (enumMapping != nil) userInfo[BCJEnumMappingErrorKey] = enumMapping;

    return [NSError errorWithDomain:BCJErrorDomain code:BCJMissingEnumMappingKeyError userInfo:userInfo];
}



+(NSError *)invalidValueErrorWithJSONPath:(NSString *)JSONPath value:(id)value criteria:(NSString *)criteria
{
    NSString *format = NSLocalizedString(@"The value for JSONPath %@ does not match the criteria '%@'.", nil);
    NSString *description = [NSString stringWithFormat:format, JSONPath, criteria];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];

    return [NSError errorWithDomain:BCJErrorDomain code:BCJInvalidValueError userInfo:userInfo];
}



+(NSError *)collectionMappingErrorWithJSONPath:(NSString *)JSONPath elementSubscript:(id)subscript elementError:(NSError *)elementError
{
    NSString *format = NSLocalizedString(@"Error while mapping element for subscript %@.", nil);
    NSString *description = [NSString stringWithFormat:format, subscript];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
    if (elementError != nil) userInfo[BCJElementErrorKey] = elementError;

    return [NSError errorWithDomain:BCJErrorDomain code:BCJCollectionMappingError userInfo:userInfo];
}



+(NSError *)multipleErrorsErrorWithErrors:(NSArray *)errors;
{
    NSString *description = NSLocalizedString(@"Error with underlying errors %@.", nil);
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
    if (errors != nil) userInfo[BCJMultipleErrorsKey] = errors;

    return [NSError errorWithDomain:BCJErrorDomain code:BCJMultipleErrorsError userInfo:userInfo];
}

@end
