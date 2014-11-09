//
//  BCJError.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 08/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BCJJSONSource;


/**

 BCJError exists only to serve as a 'namespace' for the error creation methods. Instances of BCJError are useless and
 attempting to instatiate an instance will raise an exception.

 */
@interface BCJError : NSObject


+(NSError *)missingValueErrorWithJSONSource:(BCJJSONSource *)source component:(NSString *)component componentIndex:(NSUInteger)componentIndex;
+(NSError *)unexpectedTypeErrorWithJSONSource:(BCJJSONSource *)source value:(id)value expectedClass:(Class)expectedClass;
+(NSError *)unknownKeyForEnumMappingErrorWithJSONSource:(BCJJSONSource *)source enumMapping:(NSDictionary *)enumMapping key:(id)enumKey;
+(NSError *)unexpectedElementTypeErrorWithElement:(id)element subscript:(id)subscript expectedElementClass:(Class)expectedElementClass;
+(NSError *)mappingErrorWithElement:(id)element subscript:(id)subscript underlyingError:(NSError *)underlyingError;
+(NSError *)invalidValueErrorWithJSONSource:(BCJJSONSource *)source value:(id)value criteria:(NSString *)criteria;
+(NSError *)invalidJSONPathErrorWithInvalidJSONPath:(NSString *)JSONPath errorPosition:(NSUInteger)position;

@end
