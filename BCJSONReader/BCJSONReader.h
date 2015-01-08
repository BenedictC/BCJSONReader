//
//  BCJSONReader.h
//  BCJSONReader
//
//  Created by Benedict Cohen on 20/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJConstants.h"
#import "BCJDefines.h"



#pragma mark - Reading options
/**
 Options to modifiy the behaviour of the JSONPath reading methods. It is reccommend that these values are not used directly. Instead use a BCJSONReaderMode value which are pre-defined combinations of BCJSONReaderOptions.
 */
typedef NS_OPTIONS(NSUInteger, BCJSONReaderOptions){
    /**
     If the JSONPath evaluates to nil then the source will return BCJSONReaderResultFailure instead of BCJSONReaderResultValueNotFound.
     */
     BCJSONReaderOptionPathMustEvaluateToValue     = (1UL << 0),

    /**
     If the JSONPath evaluates to NSNull then this will be replaced with nil.
     */
     BCJSONReaderOptionReplaceNullWithNil          = (1UL << 1),
};



#pragma mark - Reading modes (i.e. predefined reading options)
/**
  BCJSONReaderMode are pre-defined combinations of BCJSONReaderOptions which describe common behaviours.
 */
typedef BCJSONReaderOptions BCJSONReaderMode;

/**
 The method will return defaultValue if JSONPath evaluates to nil.
 */
const static BCJSONReaderMode BCJSONReaderModeOptional = BCJNoOptions;
/**
 The method will return defaultValue if JSONPath evaluates to NSNull or nil.
 */
const static BCJSONReaderMode BCJSONReaderModeOptionalNullable = BCJSONReaderOptionReplaceNullWithNil;
/**
 The method will return nil and report an error if JSONPath evaluates to nil.
 */
const static BCJSONReaderMode BCJSONReaderModeRequired = BCJSONReaderOptionPathMustEvaluateToValue;
/**
 The method will return nil and report an error if JSONPath evaluates to nil. If JSONPath evaluates to NSNull then it will return defaultValue which maybe nil.
 */
const static BCJSONReaderMode BCJSONReaderModeRequiredNullable = BCJSONReaderOptionPathMustEvaluateToValue | BCJSONReaderOptionReplaceNullWithNil;



/**
 
 BCJSONReader provides an API for query a JSON object graph. BCJSONReader provides type checking and error reporting thus making extracting values from the object graphs safer.
 
 The recommend usage of BCJSONReader is to call the readJSON... class methods, for example:
 
 NSError *mappingError = [BCJSONReader readJSONData:jsonData defaultOptions:BCJSONReaderModeOptional usingBlock:(BCJSONReader *reader) {
    NSString *title = [reader stringAt:@"title"];
    NSString *name = [reader stringAt:@"author.name"];
    NSDate *publishedDate = [reader dateFromTimeIntervalSince1970At:@"publishedAt"];
 }];
 
 Values are extracted by calling the query methods on an BCJSONReader instance. The query methods come in 2 forms, short form, eg stringAt: and long form stringAt:options:defaultValue:outError:.
 
 The first parameter is a require JSONPath that is used to locate the object. A valid JSONPath path is comprised of one or more path components. A path component takes one of the following forms:
 - subscript component: square braces containing one of the following:
    - an integer
    - a single quote delimited string enclosed by square braces. Single quotes are escaped with the '`' character. Literal '`' are represented with as '``'.
    - self, i.e, @"[self]"
 - identifier component: a string that starts with the a character matching the regex a-z|A-Z|$|_ followed by zero of more characters matching a-z|A-Z|$|_|0-9 . Identifier components must be terminated with a '.' except if the component is the final component in the path.

 Note that the allowable characters for an identifier component is a subset of the allowable characters for a Javascript identifier which allows for many unicode codepoints. If a unicode character is required then a subscript component should be used.

 Example JSONPaths:
 - @"events"                    Path consists of one component which is an identifier component.
 - @"events[0]"                 Two component; an identifier component followed by a subscript component.
 - @"events[0].date"            Identifier, subscript, identifer.
 - @"['events'][0]['date']"     3 subscript components
 - @"['latest events']"         One subscript component containing a string which cannot be represented by identifer component
 - @"[self]"                    [self] represents the current object. @"[self]" will fetch the root object, @"dict[self]" is equivalent to @"dict".
 - @"['']"                      The empty string component
 - @"$schema"                   $ and _ are valid in indentifer components

 The second parameter takes options which affect the behaviour of the method. There are options which affect how NSNull is handled and options which for affect how a method behaves if the value is not found. When using the short form self.defaultOptions are used.
 
 The third parameter is the defaultValue to use. This value is used if the path evaluates to nil. defaultValue may be nil.
 
 The forth parameter is didSucceed. If the query fails then didSucceed will be set to NO, otherwise YES. This parameter can be NULL. A failed method will add exactly 1 error to the readers error array.

 */
@interface BCJSONReader : NSObject

#pragma mark - convienence methods
/**
 Creates an instance using the supplied JSON data and options and invokes the supplied block. After the block has been executed the errors are taken from the reader and returned.

 @param jsonData       A data object containing JSON data. The data may represent a JSON fragment.
 @param defaultOptions The default options for the instance to use
 @param block          A block to execute

 @return If errors are reported by the reader instance while executing block then an error, otherwise nil.
 */
+(NSError *)readJSONData:(NSData *)jsonData defaultOptions:(BCJSONReaderOptions)defaultOptions usingBlock:(void(^)(BCJSONReader *reader))block BCJ_REQUIRED(1,3);
/**
 Creates an instance using the supplied object and options and invokes the supplied block. After the block has been executed the errors are taken from the reader and returned.

 @param object         An object that to perform JSONPath queries against
 @param defaultOptions The options used be short form query methods
 @param block          A block to execute

 @return If errors are reported by the reader instance while executing block then an error, otherwise nil.
 */
+(NSError *)readObject:(id)jsonObject defaultOptions:(BCJSONReaderOptions)defaultOptions usingBlock:(void(^)(BCJSONReader *reader))block BCJ_REQUIRED(1,3);

#pragma mark - instance life cycle
/**
 Return an initalized instance.

 @param jsonObject     An object that is a valid JSON object types
 @param defaultOptions The options used be short form query methods

 @return an instance
 */
-(instancetype)initWithObject:(id)object defaultOptions:(BCJSONReaderOptions)defaultOptions BCJ_DESIGNATED_INIT BCJ_REQUIRED(1);
/**
 The object to perform JSONPath queries against.
 */
@property(nonatomic, readonly) id object;
/**
 The options used by short form query methods.
 */
@property(nonatomic, readonly) BCJSONReaderOptions defaultOptions;

#pragma mark - errors
/**
 An array of NSError that have been reported by query methods or by addError:.
 */
@property(nonatomic, readonly) NSArray *errors;
/**
 Adds the given error to the errors array.

 @param error the error object to add.
 */
-(void)addError:(NSError *)error BCJ_REQUIRED();
/**
 A boolean value that indicates if any errors have been reported.

 @return returns YES if errors contains any errors.
 */
-(BOOL)hasErrors;

#pragma mark - JSON path access
/**
 Queries the JSONObject for the object at JSONPath using the default options. The fetched object is then type check against expected class. If the fetch fails or the type check fails then an error is added to errors.

 @param jsonPath      The JSON path to query.
 @param expectedClass The class that the JSON path is expected to return or nil if type checking is not required.

 @return if the query matches an object and the object is of the expected class then returns the object, otherwise nil.
 */
-(id)objectAt:(NSString *)jsonPath type:(Class)expectedClass BCJ_REQUIRED(1);
/**
 Queries the JSONObject for the object at JSONPath using options. The fetched object is then type check against expected class. If the fetch fails or the type check fails then an error is added to errors.

 @param jsonPath      The JSON path to query.
 @param expectedClass The class that the JSON path is expected to return or nil if type checking is not required.
 @param options       The options used perform the fetch.
 @param defaultValue  A default value to return if required. The object must be of type expectedClass.
 @param didSucceed    On return contains YES if the method was successful, otherwise NO. NULL is permitted.

 @return If the query matches an object of the expected class then returns the object, otherwise nil or defaultValue depending on options.
 */
-(id)objectAt:(NSString *)jsonPath type:(Class)expectedClass options:(BCJSONReaderOptions)options defaultValue:(id)defaultValue didSucceed:(BOOL *)didSucceed BCJ_REQUIRED(1);

@end



@interface BCJSONReader (StandardTypeQueries)

/**
 Queries the JSONObject for a string at JSONPath using the default options. If the fetch fails then an error is added to errors.

 @param jsonPath The JSON path to query.

 @return If the query matches a string then returns the string, otherwise nil;
 */
-(NSString *)stringAt:(NSString *)jsonPath BCJ_REQUIRED();
/**
 Queries the JSONObject for a string at JSONPath using options and default value. If the fetch fails then an error is added to errors.

 @param jsonPath     The JSON path to query.
 @param options      The options used to perform the fetch.
 @param defaultValue A default value to return if required.
 @param didSucceed   On return contains YES if the method was successful, otherwise NO. NULL is permitted.

 @return If the query matches a string then returns the string, otherwise nil or defaultValue depending on options.
 */
-(NSString *)stringAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(NSString *)defaultValue didSucceed:(BOOL *)didSucceed BCJ_REQUIRED(1);

/**
 Queries the JSONObject for null at JSONPath using the default options. If the default options include BCJSONReaderOptionReplaceNullWithNil then it is ignored. If the fetch fails then an error is added to errors.

 @param jsonPath The JSON path to query.

 @return If the query matches null then returns null, otherwise nil.
 */
-(NSNull *)nullAt:(NSString *)jsonPath BCJ_REQUIRED();
/**
 Queries the JSONObject for a string at JSONPath using options. If the fetch fails then an error is added to errors.

 @param jsonPath   The JSON path to query.
 @param options    The options used to perform the fetch. An exception is raised if BCJSONReaderOptionReplaceNullWithNil is specified.
 @param didSucceed On return contains YES if the method was successful, otherwise NO. NULL is permitted.

 @return If the query matches NSNull then returns NSNull, otherwise nil.
 */
-(NSNull *)nullAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options didSucceed:(BOOL *)didSucceed BCJ_REQUIRED(1);

/**
 Queries the JSONObject for an array at JSONPath using the default options. If the fetch fails then an error is added to errors.

 @param jsonPath The JSON path to query.

 @return If the query matches an array then returns the array, otherwise nil;
 */
-(NSArray *)arrayAt:(NSString *)jsonPath BCJ_REQUIRED();
/**
 Queries the JSONObject for an array at JSONPath using options and default value. If the fetch fails then an error is added to errors.

 @param jsonPath     The JSON path to query.
 @param options      The options used to perform the fetch.
 @param defaultValue A default value to return if required.
 @param didSucceed   On return contains YES if the method was successful, otherwise NO. NULL is permitted.

 @return If the query matches an array then returns the array, otherwise nil or defaultValue depending on options.
 */
-(NSArray *)arrayAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(NSArray *)defaultValue didSucceed:(BOOL *)didSucceed BCJ_REQUIRED(1);

/**
 Queries the JSONObject for a dictionary at JSONPath using the default options. If the fetch fails then an error is added to errors.

 @param jsonPath The JSON path to query.

 @return If the query matches a dictionary then returns the dictionary, otherwise nil;
 */
-(NSDictionary *)dictionaryAt:(NSString *)jsonPath BCJ_REQUIRED();
/**
 Queries the JSONObject for a dictionary at JSONPath using options and default value. If the fetch fails then an error is added to errors.

 @param jsonPath     The JSON path to query.
 @param options      The options used to perform the fetch.
 @param defaultValue A default value to return if required.
 @param didSucceed   On return contains YES if the method was successful, otherwise NO. NULL is permitted.

 @return If the query matches a dictionary then returns the dictionary, otherwise nil or defaultValue depending on options.
 */
-(NSDictionary *)dictionaryAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(NSDictionary *)defaultValue didSucceed:(BOOL *)didSucceed BCJ_REQUIRED(1);

/**
 Queries the JSONObject for a number at JSONPath using the default options. If the fetch fails then an error is added to errors.

 @param jsonPath The JSON path to query.

 @return If the query matches a number then returns the number, otherwise nil or defaultValue depending on options.
 */
-(NSNumber *)numberAt:(NSString *)jsonPath BCJ_REQUIRED();
-(NSNumber *)numberAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(NSNumber *)defaultValue didSucceed:(BOOL *)didSucceed BCJ_REQUIRED(1);

/**
 Queries the JSONObject for an NSNumber at JSONPath using the default options. If the fetch fails then an error is added to errors.

 @param jsonPath The JSON path to query.

 @return If the query matches an NSNumber then returns the boolean value of the number, otherwise NO.
 */
-(BOOL)boolAt:(NSString *)jsonPath BCJ_REQUIRED();
/**
 Queries the JSONObject for an NSNumber at JSONPath using options and default value. If the fetch fails then an error is added to errors.

 @param jsonPath     The JSON path to query.
 @param options      The options used to perform the fetch.
 @param defaultValue A default value to return if required.
 @param didSucceed   On return contains YES if the method was successful, otherwise NO. NULL is permitted.

 @return If the query matches an NSNumber then returns the boolean value of the number, otherwise the defaultValue.
 */
-(BOOL)boolAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(BOOL)defaultValue didSucceed:(BOOL *)didSucceed BCJ_REQUIRED(1);

/**
 Queries the JSONObject for an NSNumber at JSONPath using the default options. If the fetch fails then an error is added to errors.

 @param jsonPath The JSON path to query.

 @return If the query matches an NSNumber then returns the integer value of the number, otherwise 0.
 */
-(int64_t)integerAt:(NSString *)jsonPath BCJ_REQUIRED();
/**
 Queries the JSONObject for an NSNumber at JSONPath using options and default value. If the fetch fails then an error is added to errors.

 @param jsonPath     The JSON path to query.
 @param options      The options used to perform the fetch.
 @param defaultValue A default value to return if required.
 @param didSucceed   On return contains YES if the method was successful, otherwise NO. NULL is permitted.

 @return If the query matches an NSNumber then returns the integer value of the number, otherwise the defaultValue.
 */
-(int64_t)integerAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(int64_t)defaultValue didSucceed:(BOOL *)didSucceed BCJ_REQUIRED(1);

/**
 Queries the JSONObject for an NSNumber at JSONPath using the default options. If the fetch fails then an error is added to errors.

 @param jsonPath The JSON path to query.

 @return If the query matches an NSNumber then returns the double value of the number, otherwise 0.
 */
-(double)doubleAt:(NSString *)jsonPath BCJ_REQUIRED();
/**
 Queries the JSONObject for an NSNumber at JSONPath using options and default value. If the fetch fails then an error is added to errors.

 @param jsonPath     The JSON path to query.
 @param options      The options used to perform the fetch.
 @param defaultValue A default value to return if required.
 @param didSucceed   On return contains YES if the method was successful, otherwise NO. NULL is permitted.

 @return If the query matches an NSNumber then returns the double value of the number, otherwise the defaultValue.
 */
-(double)doubleAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(double)defaultValue didSucceed:(BOOL *)didSucceed BCJ_REQUIRED(1);

@end



@interface BCJSONReader (TransformedTypeQueries)

/**
 Queries the JSONObject for an NSNumber at JSONPath using the default options. If an NSNumber is found then an NSDate is created using dateWithTimeIntervalSince1970: and returned. If the fetch fails then an error is added to errors.

 @param jsonPath The JSON path to query.

 @return If the query matches an NSNumber then return an NSDate, otherwise nil.
 */
-(NSDate *)dateFromTimeIntervalSince1970At:(NSString *)jsonPath BCJ_REQUIRED();
/**
 Queries the JSONObject for an NSNumber at JSONPath using options and default. If an NSNumber is found then an NSDate is created using dateWithTimeIntervalSince1970: and returned. If the fetch fails then an error is added to errors.

 @param jsonPath     The JSON path to query.
 @param options      The options used to perform the fetch.
 @param defaultValue A default value to return if required.
 @param didSucceed   On return contains YES if the method was successful, otherwise NO. NULL is permitted.

 @return If the query matches an NSNumber then return an NSDate, otherwise nil or defaultValue depending on options.
 */
-(NSDate *)dateFromTimeIntervalSince1970At:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(NSDate *)defaultValue didSucceed:(BOOL *)didSucceed BCJ_REQUIRED(1);

/**
 Queries the JSONObject for an NSString at JSONPath using the default options. If an NSString is found and it matches the date format yyyy-MM-dd'T'HH:mm:ss.SSSZ then an NSDate is created and returned. If the fetch fails or the string does not conform to the correct format then an error is added to errors.

 @param jsonPath The JSON path to query.

 @return If the query matches an NSNumber then return an NSDate, otherwise nil.
 */
-(NSDate *)dateFromISO8601StringAt:(NSString *)jsonPath BCJ_REQUIRED();
/**
 Queries the JSONObject for an NSString at JSONPath using options and default value. If an NSString is found and it matches the date format yyyy-MM-dd'T'HH:mm:ss.SSSZ then an NSDate is created and returned. If the fetch fails or the string does not conform to the correct format then an error is added to errors.

 @param jsonPath     The JSON path to query.
 @param options      The options used to perform the fetch.
 @param defaultValue A default value to return if required.
 @param didSucceed   On return contains YES if the method was successful, otherwise NO. NULL is permitted.

 @return If the query matches an NSString in the correct format then return an NSDate, otherwise nil or defaultValue depending on options.
 */
-(NSDate *)dateFromISO8601StringAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(NSDate *)defaultValue didSucceed:(BOOL *)didSucceed BCJ_REQUIRED(1);

/**
 Queries the JSONObject for an NSString at JSONPath using the default options. If an NSString is found and it is a valid URL then an NSURL is created and returned. If the fetch fails or the string is not a valid URL then an error is added to errors.

 @param jsonPath     The JSON path to query.

 @return If the query matches an NSString then return an NSURL, otherwise nil.
 */
-(NSURL *)URLFromStringAt:(NSString *)jsonPath BCJ_REQUIRED();
/**
 Queries the JSONObject for an NSString at JSONPath using the options and default value. If an NSString is found and it is a valid URL then an NSURL is created and returned. If the fetch fails or the string is not a valid URL then an error is added to errors.

 @param jsonPath     The JSON path to query.
 @param options      The options used to perform the fetch.
 @param defaultValue A default value to return if required.
 @param didSucceed   On return contains YES if the method was successful, otherwise NO. NULL is permitted.

 @return If the query matches an NSString then return an NSURL, otherwise nil or defaultValue depending on options.
 */
-(NSURL *)URLFromStringAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(NSURL *)defaultValue didSucceed:(BOOL *)didSucceed BCJ_REQUIRED(1);

/**
 Queries the JSONObject for an NSString at JSONPath using the default options. If an NSString is found and it is valid base64 encoded data then an NSData is created and returned. If the fetch fails or the string is not a valid URL then an error is added to errors.

 @param jsonPath     The JSON path to query.

 @return If the query matches an NSString then return an NSData, otherwise nil.
 */
-(NSData *)dataFromBase64EncodedStringAt:(NSString *)jsonPath BCJ_REQUIRED();
/**
 Queries the JSONObject for an NSString at JSONPath using options and default value. If an NSString is found and it is valid base64 encoded data then an NSData is created and returned. If the fetch fails or the string is not a valid URL then an error is added to errors.

 @param jsonPath     The JSON path to query.
 @param options      The options used to perform the fetch.
 @param defaultValue A default value to return if required.
 @param didSucceed   On return contains YES if the method was successful, otherwise NO. NULL is permitted.

 @return If the query matches an NSString then return an NSData, otherwise nil or defaultValue depending on options.
 */
-(NSData *)dataFromBase64EncodedStringAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(NSData *)defaultValue didSucceed:(BOOL *)didSucceed BCJ_REQUIRED(1);
@end



@interface BCJSONReader (Collections)

/**
 Queries the JSONObject for an object at JSONPath using the default options. If an object is found or the default key is specifed then the a look up is performed on enumMapping. If the fetch fails or a value is not found in enumMapping then an error is added to errors.

 @param jsonPath     The JSON path to query.
 @param enumMapping  A dictionary containing keys that match fetched objects and associated values to return.

 @return If the enumMapping look up succeeds then an object, otherwise nil.
 */
-(id)enumAt:(NSString *)jsonPath enumMapping:(NSDictionary *)enumMapping BCJ_REQUIRED();
/**
 Queries the JSONObject for an object at JSONPath using the options and default key. If an object is found or the default key is specifed then the a look up is performed on enumMapping. If the fetch fails or a value is not found in enumMapping then an error is added to errors.

 @param jsonPath     The JSON path to query.
 @param enumMapping  A dictionary containing keys that match fetched objects and associated values to return.
 @param options      The options used to perform the fetch.
 @param defaultKey   A default key to use if required.
 @param didSucceed   On return contains YES if the method was successful, otherwise NO. NULL is permitted.

 @return If the enumMapping look up succeeds then an object, otherwise nil.
 */
-(id)enumAt:(NSString *)jsonPath enumMapping:(NSDictionary *)enumMapping options:(BCJSONReaderOptions)options defaultKey:(id)defaultKey didSucceed:(BOOL *)didSucceed BCJ_REQUIRED(1,2);

/**
 Queries the JSONObject for an array at JSONPath using the default options. If an array is found then the elementReaderBlock is invoked for each element. The BCJSONReader passed to the elementReaderBlock is initialized with the element and default options. The objects returned by the elementReaderBlock are collated into a new array which is then returned. If the fetch fails or any of the elementReader contain errors then an error is added to errors.

 @param jsonPath           The JSON path to query.
 @param elementReaderBlock A block that returns a object to add to the output array. This block is invoked once for each element. It may return nil.

 @return If the query matches an array and each element in the array is successfully mapped then returns an array, otherwise nil.
 */
-(NSArray *)arrayFromArrayAt:(NSString *)jsonPath usingElementReaderBlock:(id(^)(BCJSONReader *elementReader, NSUInteger elementIndex))elementReaderBlock BCJ_REQUIRED();
/**
 Queries the JSONObject for an array at JSONPath using options. If an array is found then the elementReaderBlock is invoked for each element. The BCJSONReader passed to the elementReaderBlock is initialized with the element and options. The objects returned by the elementReaderBlock are collated into a new array which is then returned. If the fetch fails or any of the elementReader contain errors then an error is added to errors.

 @param jsonPath           The JSON path to query.
 @param options            The options used to perform the fetch.
 @param didSucceed         On return contains YES if the method was successful, otherwise NO. NULL is permitted.
 @param elementReaderBlock A block that returns a object to add to the output array. This block is invoked once for each element. It may return nil.

 @return If the query matches an array and each element in the array is successfully mapped then returns an array, otherwise nil.
 */
-(NSArray *)arrayFromArrayAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options didSucceed:(BOOL *)didSucceed usingElementReaderBlock:(id(^)(BCJSONReader *elementReader, NSUInteger elementIndex))elementReaderBlock BCJ_REQUIRED(1,4);

/**
 Queries the JSONObject for a dictionary at JSONPath using the default options. If a dictionary is found then the elementReaderBlock is invoked for each element. The BCJSONReader passed to the elementReaderBlock is initialized with the element and the default options. The objects returned by the elementReaderBlock are collated into a new array which is then returned. If the fetch fails or any of the elementReader contain errors then an error is added to errors.

 The unsafeElementKey of elementReaderBlock can be made safe by calling verifyObject:isKindOfClass:didSucceed:. In most cases the key will be an NSString (the JSON spec only always keys to be strings), this however is not enforced by BCJSONReader allowing it to be useful for handing a super-set of the what is permitted by the JSON spec. Note that the order in which the elements are enumerated is not specified.

 @param jsonPath           The JSON path to query.
 @param elementReaderBlock A block that returns a object to add to the output array. This block is invoked once for each element. It may return nil.

 @return If the query matches an array and each element in the array is successfully mapped then returns an array, otherwise nil.
 */
-(NSArray *)arrayFromDictionaryAt:(NSString *)jsonPath usingElementReaderBlock:(id(^)(BCJSONReader *elementReader, id unsafeElementKey))elementReaderBlock BCJ_REQUIRED();

/**
 Queries the JSONObject for a dictionary at JSONPath using options. If a dictionary is found then the elementReaderBlock is invoked for each element. The BCJSONReader passed to the elementReaderBlock is initialized with the element and options. The objects returned by the elementReaderBlock are collated into a new array which is then returned. If the fetch fails or any of the elementReader contain errors then an error is added to errors.
 
 The unsafeElementKey of elementReaderBlock can be made safe by calling verifyObject:isKindOfClass:didSucceed:. In most cases the key will be an NSString (the JSON spec only always keys to be strings), this however is not enforced by BCJSONReader allowing it to be useful for handing a super-set of the what is permitted by the JSON spec. Note that the order in which the elements are enumerated is not specified.

 @param jsonPath           The JSON path to query.
 @param options            The options used to perform the fetch.
 @param didSucceed         On return contains YES if the method was successful, otherwise NO. NULL is permitted.
 @param elementReaderBlock A block that returns a object to add to the output array. This block is invoked once for each element. It may return nil.

 @return If the query matches an array and each element in the array is successfully mapped then returns an array, otherwise nil.
 */
-(NSArray *)arrayFromDictionaryAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options didSucceed:(BOOL *)didSucceed usingElementReaderBlock:(id(^)(BCJSONReader *elementReader, id unsafeElementKey))elementReaderBlock BCJ_REQUIRED(1,4);

/**
 Verifies that object is of kind of class class. If it is not the an error is added to errors.

 @param object     The object to verify.
 @param class      The class that object is expected to be. If this is Nil then an exception is raised.
 @param didSucceed On return contains YES if object is nil or is of type class, otherwise nil.

 @return If successful then object otherwise nil.
 @see arrayFromDictionaryAt:usingElementReaderBlock:
 @see arrayFromDictionaryAt:options:didSucceed:usingElementReaderBlock:
 */
-(id)verifyObject:(id)object isKindOfClass:(Class)class didSucceed:(BOOL *)didSucceed;

@end



@interface BCJSONReader (Validation)

/**
 Checks that object is of type class. If it is not then an error is added to errors.

 @param object The object to check. May be nil.
 @param class  The expected class. If Nil then an exception is raised.

 @return YES if object is nil or is of type class, otherwise NO.
 */
-(BOOL)assertObject:(id)object isKindOfClass:(Class)class BCJ_REQUIRED();
/**
 Evaluates predicate against JSONObject. If evaluation fails then an error is added to errors.
 
 The predicate can safely access values within the JSON object by using the %K type specifier. For example:
 [NSPredicate predicateWithFormat:@"%K == 'John Lennon'", @"members['guitar']['name']"].
 This behaviour differs from standard key path access embedded in the predicate format which will raise an exception if a path cannot be evaluated.

 @param predicate The predicate to evaluate.

 @return YES if the evaluation succeeds, otherwise NO.
 */
-(BOOL)assertPredicate:(NSPredicate *)predicate BCJ_REQUIRED();

/**
 Creates a predicate using predicateFormat and evaluates it against JSONObject. If evaluation fails then an error is added to errors.

 The predicate can safely access values within the JSON object by using the %K type specifier. For example:
 [NSPredicate predicateWithFormat:@"%K == 'John Lennon'", @"members['guitar']['name']"].
 This behaviour differs from standard key path access embedded in the predicate format which will raise an exception if a path cannot be evaluated.

 @param predicateFormat The predicate format to create and evaluate.

 @return YES if the evaluation succeeds, otherwise NO.
 */
-(BOOL)assertPredicateWithFormat:(NSString *)predicateFormat, ... BCJ_REQUIRED(1);

@end



@interface BCJSONReader (PropertyListAdditions)
/**
 Creates an instance using the supplied JSON data and options and invokes the supplied block. After the block has been executed the errors are taken from the reader and returned.

 @param jsonData       A data object containing JSON data. The data may represent a JSON fragment.
 @param defaultOptions The default options for the instance to use
 @param block          A block to execute

 @return If errors are reported by the reader instance while executing block then an error, otherwise nil.
 */
+(NSError *)readPropertyListData:(NSData *)propertyListData defaultOptions:(BCJSONReaderOptions)defaultOptions usingBlock:(void(^)(BCJSONReader *reader))block BCJ_REQUIRED(1,3);

/**
 Queries the JSONObject for an NSData at JSONPath using the default options. If the fetch fails then an error is added to errors.

 @param jsonPath The JSON path to query.

 @return If the query matches an NSData then returns the data, otherwise nil;
 */
-(NSData *)dataAt:(NSString *)jsonPath BCJ_REQUIRED();
/**
 Queries the JSONObject for an NSData at JSONPath using options and default value. If the fetch fails then an error is added to errors.

 @param jsonPath     The JSON path to query.
 @param options      The options used to perform the fetch.
 @param defaultValue A default value to return if required.
 @param didSucceed   On return contains YES if the method was successful, otherwise NO. NULL is permitted.

 @return If the query matches an NSData then returns the data, otherwise nil or defaultValue depending on options.
 */
-(NSData *)dataAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(NSData *)defaultValue didSucceed:(BOOL *)didSucceed BCJ_REQUIRED(1);

/**
 Queries the JSONObject for an NSDate at JSONPath using the default options. If the fetch fails then an error is added to errors.

 @param jsonPath The JSON path to query.

 @return If the query matches an NSDate then returns the date, otherwise nil;
 */
-(NSDate *)dateAt:(NSString *)jsonPath BCJ_REQUIRED();
/**
 Queries the JSONObject for an NSDate at JSONPath using options and default value. If the fetch fails then an error is added to errors.

 @param jsonPath     The JSON path to query.
 @param options      The options used to perform the fetch.
 @param defaultValue A default value to return if required.
 @param didSucceed   On return contains YES if the method was successful, otherwise NO. NULL is permitted.

 @return If the query matches an NSDate then returns the date, otherwise nil or defaultValue depending on options.
 */
-(NSDate *)dateAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(NSDate *)defaultValue didSucceed:(BOOL *)didSucceed BCJ_REQUIRED(1);

@end
